//
// Copyright (c) 2013 XING AG (http://xing.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XNGAPIClient.h"
#import "NSString+URLEncoding.h"
#import "NSDictionary+Typecheck.h"
#import "XNGOAuth1Client.h"

@interface XNGAPIClient()
@property(nonatomic, strong, readwrite) XNGOAuthHandler *oAuthHandler;
@property(nonatomic, strong, readwrite) NSURL *baseURL;
@property(nonatomic, strong, readwrite) NSString *callbackScheme;
@end

@implementation XNGAPIClient

NSString * const XNGAPIClientInvalidTokenErrorNotification = @"com.xing.apiClient.error.invalidToken";
NSString * const XNGAPIClientDeprecationErrorNotification = @"com.xing.apiClient.error.deprecatedAPI";
NSString * const XNGAPIClientDeprecationWarningNotification = @"com.xing.apiClient.warning.deprecatedAPI";

static XNGAPIClient *_sharedClient = nil;

+ (XNGAPIClient *)clientWithBaseURL:(NSURL *)url {
    return [[XNGAPIClient alloc] initWithBaseURL:url];
}

+ (XNGAPIClient *)sharedClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedClient == nil) {
            NSURL *baseURL = [NSURL URLWithString:@"https://www.xing.com"];
            _sharedClient = [[XNGAPIClient alloc] initWithBaseURL:baseURL];
        }
    });
    return _sharedClient;
}

+ (void)setSharedClient:(XNGAPIClient *)sharedClient {
    _sharedClient = sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        _oAuthHandler = [[XNGOAuthHandler alloc] init];
        self.baseURL = url;
        [self registerHTTPOperationClass:[XNGJSONRequestOperation class]];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

#pragma mark - Getters / Setters

- (NSString *)callbackScheme {
    if (!_callbackScheme) {
        _callbackScheme =[NSString stringWithFormat:@"xingapp%@",self.consumerKey];
    }
    return _callbackScheme;
}

- (void)setUserAgent:(NSString *)userAgent {
    [self setDefaultHeader:@"User-Agent" value:userAgent];
}

#pragma mark - XAuth signing

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [super requestWithMethod:method path:path parameters:parameters];
    [self.oAuthHandler.GTMOAuthAuthentication authorizeRequest:request];
    return request;
}

#pragma mark - handling login / logout

- (BOOL)isLoggedin {
    return [self.oAuthHandler hasAccessToken];
}

- (void)logout {
    return [self.oAuthHandler deleteKeychainEntriesAndGTMOAuthAuthentication];
}

- (void)loginOAuthWithSuccess:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure {
    if (self.isLoggedin) {
        [[self exceptionForUserAlreadyLoggedIn] raise];
        return;
    }

    if ([self.consumerKey length] == 0) {
        [[self exceptionForNoConsumerKey] raise];
        return;
    }

    if ([self.consumerSecret length] == 0) {
        [[self exceptionForNoConsumerSecret] raise];
        return;
    }


    NSURL *callbackURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://success",self.callbackScheme]];

    __weak __typeof(&*self)weakSelf = self;
    XNGOAuth1Client *oauthClient = [[XNGOAuth1Client alloc] initWithBaseURL:self.baseURL
                                                                      key:self.consumerKey
                                                                   secret:self.consumerSecret];
    [oauthClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [oauthClient authorizeUsingOAuthWithRequestTokenPath:@"v1/request_token"
                                   userAuthorizationPath:@"v1/authorize"
                                             callbackURL:callbackURL
                                         accessTokenPath:@"v1/access_token"
                                            accessMethod:@"POST"
                                                   scope:nil
                                                 success:
     ^(AFOAuth1Token *accessToken, id responseObject) {
         NSString *userID = [accessToken.additionalParameters xng_stringForKey:@"user_id"];
         [weakSelf.oAuthHandler saveUserID:userID
                               accessToken:accessToken.key
                                    secret:accessToken.secret
                                   success:success
                                   failure:failure];
     } failure:^(NSError *error) {
         failure(error);
     }];
}

- (BOOL)handleOpenURL:(NSURL *)URL {
    if([[URL scheme] isEqualToString:self.callbackScheme] == NO) {
        return NO;
    }

    NSDictionary *dict = [NSDictionary dictionaryWithObject:URL forKey:kAFApplicationLaunchOptionsURLKey];
    NSNotification *notification = [NSNotification notificationWithName:kAFApplicationLaunchedWithURLNotification
                                                                 object:nil
                                                               userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    return YES;
}

- (void)loginXAuthWithUsername:(NSString*)username
                      password:(NSString*)password
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure {
    if (self.isLoggedin) {
        [[self exceptionForUserAlreadyLoggedIn] raise];
        return;
    }

    if ([self.consumerKey length] == 0) {
        [[self exceptionForNoConsumerKey] raise];
        return;
    }

    if ([self.consumerSecret length] == 0) {
        [[self exceptionForNoConsumerSecret] raise];
        return;
    }

    [self postRequestXAuthAccessTokenWithUsername:username
                                         password:password
                                          success:
     ^(AFHTTPRequestOperation *operation, id responseJSON) {
         NSString *body = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
         NSDictionary *xAuthResponseFields = [NSString xng_URLDecodedDictionaryFromString:body];

         [self.oAuthHandler saveXAuthResponseParametersToKeychain:xAuthResponseFields
                                                          success:success
                                                          failure:failure];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
}

- (void)postRequestXAuthAccessTokenWithUsername:(NSString*)username
                                       password:(NSString*)password
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseJSON))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSParameterAssert(username);
    NSParameterAssert(password);

	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"oauth_consumer_key"] =  self.consumerKey;
    parameters[@"x_auth_username"] = username;
    parameters[@"x_auth_password"] = password;
    parameters[@"x_auth_mode"] = @"client_auth";

    NSString* path = [NSString stringWithFormat:@"%@/v1/xauth", self.baseURL];
    [self postPath:path parameters:parameters success:success failure:failure];
}

#pragma mark - block-based GET / PUT / POST / DELETE

- (void)getJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    [self enqueueJSONRequest:request success:success failure:failure];
}

- (void)putJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [self requestWithMethod:@"PUT" path:path parameters:parameters];
    [self enqueueJSONRequest:request success:success failure:failure];
}

- (void)postJSONPath:(NSString *)path
          parameters:(NSDictionary *)parameters
             success:(void (^)(id JSON))success
             failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    [self enqueueJSONRequest:request success:success failure:failure];
}

- (void)deleteJSONPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               success:(void (^)(id JSON))success
               failure:(void (^)(NSError *error))failure {
    NSMutableURLRequest *request = [self requestWithMethod:@"DELETE" path:path parameters:parameters];
    [self enqueueJSONRequest:request success:success failure:failure];
}

#pragma mark - OAuth related methods

- (NSString *)currentUserID {
    return self.oAuthHandler.userID;
}

- (void)setConsumerKey:(NSString *)consumerKey {
    self.oAuthHandler.consumerKey = consumerKey;
}

- (void)setConsumerSecret:(NSString *)consumerSecret {
    self.oAuthHandler.consumerSecret = consumerSecret;
}

- (void)setSignatureMethod:(NSString *)signatureMethod {
    self.oAuthHandler.signatureMethod = signatureMethod;
}

- (void)setServiceProvider:(NSString *)serviceProvider {
    self.oAuthHandler.serviceProvider = serviceProvider;
}

#pragma mark - OAuth related methods (private)

- (NSString *)consumerKey {
    NSAssert([self.oAuthHandler.consumerKey length], @"No ConsumerKey returned. \n Did you forget to implement XNGAPIClient delegate method consumerKeyForXNGAPIClient: ?");
    return self.oAuthHandler.consumerKey;
}

- (NSString *)consumerSecret {
    NSAssert([self.oAuthHandler.consumerSecret length], @"No ConsumerSecret returned. \n Did you forget to implement XNGAPIClient delegate method consumerSecretForXNGAPIClient: ?");
    return self.oAuthHandler.consumerSecret;
}

- (NSString *)signatureMethod {
    return self.oAuthHandler.signatureMethod;
}

- (NSString *)serviceProvider {
    return self.oAuthHandler.serviceProvider;
}

#pragma mark - checking methods

- (void)checkForGlobalErrors:(NSHTTPURLResponse *)response
                    withJSON:(id)JSON {
    if (response.statusCode == 410) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XNGAPIClientDeprecationErrorNotification object:nil];
        return;
    }
    if ([JSON isKindOfClass:[NSDictionary class]] &&
        [[JSON xng_stringForKey:@"error_name"] isEqualToString:@"INVALID_OAUTH_TOKEN"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XNGAPIClientInvalidTokenErrorNotification object:nil];
        return;
    }
}

- (void)checkForDeprecation:(NSHTTPURLResponse *)response {
    if ([[response.allHeaderFields xng_stringForKey:@"X-Xing-Deprecation-Status"] isEqualToString:@"deprecated"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XNGAPIClientDeprecationWarningNotification object:nil];
    }
}

#pragma mark - cancel requests methods

- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method paths:(NSArray *)paths {
    for (NSString* path in paths) {
        [self cancelAllHTTPOperationsWithMethod:method path:path];
    }
}

- (void)cancelAllHTTPOperations {
    for (NSOperation *operation in self.operationQueue.operations) {
        operation.completionBlock = nil;
        [operation cancel];
    }
}

#pragma mark - HTTP Operation queue methods

- (void)enqueueJSONRequest:(NSMutableURLRequest *)request
                   success:(void (^)(id JSON))success
                   failure:(void (^)(NSError *error))failure {
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    __weak __typeof(&*self)weakSelf = self;
    XNGJSONRequestOperation *operation = nil;
    operation = [XNGJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                 success:
                 ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                     [weakSelf checkForDeprecation:response];
                     if (success) {
                         success(JSON);
                     }
                 } failure:
                 ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                     [weakSelf checkForDeprecation:response];
                     [weakSelf checkForGlobalErrors:response withJSON:JSON];

                     if ([JSON isKindOfClass:[NSDictionary class]]) {
                         error = [NSError xwsErrorWithStatusCode:response.statusCode
                                                        userInfo:JSON];
                     }

                     if (failure) {
                         failure(error);
                     }
                 }];
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Helper methods

- (NSException *)exceptionForUserAlreadyLoggedIn {
    return [NSException exceptionWithName:@"XNGUserLoginException" reason:@"A User is already loggedIn. Use the isLoggedin method to verfiy that no user is logged in before you use this method." userInfo:@{@"XNGLoggedInUserID":self.currentUserID}];
}

- (NSException *)exceptionForNoConsumerKey {
    return [NSException exceptionWithName:@"XNGNoConsumerKeyException"
                                   reason:@"There is no Consumer Key set yet. Please set it first before invoking login."
                                 userInfo:nil];
}

- (NSException *)exceptionForNoConsumerSecret {
    return [NSException exceptionWithName:@"XNGNoConsumerSecretException"
                                   reason:@"There is no Consumer Secret set yet. Please set it first before invoking login."
                                 userInfo:nil];
}

@end
