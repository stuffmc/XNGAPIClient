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

#import "XNGOAuthHandler.h"
#import "XNGAPIClient.h"
#import "NSString+URLEncoding.h"
#import "SFHFKeychainUtils.h"
#import "GTMOAuthAuthentication.h"
#import "NSError+XWS.h"

static NSString *kIdentifier = @"com.xing.iphone-app-2010";
static NSString *kTokenSecretName = @"TokenSecret";//Keychain username
static NSString *kUserIDName = @"UserID";//Keychain username
static NSString *kAccessTokenName = @"AccessToken";//Keychain username

@interface XNGOAuthHandler ()
@property (nonatomic, strong, readwrite) NSString *accessToken;
@property (nonatomic, strong, readwrite) NSString *tokenSecret;
@property (nonatomic, strong, readwrite) NSString *userID;
@property (nonatomic, strong, readwrite) GTMOAuthAuthentication *GTMOAuthAuthentication;
@end

@implementation XNGOAuthHandler

- (GTMOAuthAuthentication*) GTMOAuthAuthentication {
    if (_GTMOAuthAuthentication == nil) {
        _GTMOAuthAuthentication = [[GTMOAuthAuthentication alloc]initWithSignatureMethod:self.signatureMethod
                                                                             consumerKey:self.consumerKey
                                                                              privateKey:self.consumerSecret];

        _GTMOAuthAuthentication.shouldUseParamsToAuthorize = YES;
		_GTMOAuthAuthentication.serviceProvider = self.serviceProvider;
		_GTMOAuthAuthentication.token = self.accessToken;
		_GTMOAuthAuthentication.tokenSecret = self.tokenSecret;
    }

    return _GTMOAuthAuthentication;
}

#pragma mark - handling oauth consumer/secret

- (NSString *)userID {
	if (_userID == nil) {
		NSError *error;
		_userID = [SFHFKeychainUtils getPasswordForUsername:kUserIDName
                                             andServiceName:kIdentifier
                                                      error:&error];
		NSAssert( !error || [error code] == -25291, @"KeychainUserIDReadError: %@",error);
	}
	return _userID;
}

- (BOOL)hasAccessToken {
    return (self.accessToken != nil) && (self.accessToken.length > 0);
}

- (NSString *)accessToken {
	if (_accessToken == nil) {
		NSError *error;
		_accessToken = [SFHFKeychainUtils getPasswordForUsername:kAccessTokenName
                                                  andServiceName:kIdentifier
                                                           error:&error];
		NSAssert( !error || [error code] == -25291, @"KeychainUserAccesstokenError: %@",error);
	}
	return _accessToken;
}

- (NSString *)tokenSecret {
	if (_tokenSecret  == nil) {
		NSError *error;
		_tokenSecret = [SFHFKeychainUtils getPasswordForUsername:kTokenSecretName
                                                  andServiceName:kIdentifier
                                                           error:&error];
		NSAssert( !error || [error code] == -25291, @"KeychainTokenSecretReadError: %@",error);
	}
	return _tokenSecret;
}

- (NSError*)xwsErrorWithAFHTTPRequestOperation:(AFHTTPRequestOperation*)operation {
    NSUInteger statusCode = operation.response.statusCode;

    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    userInfo[@"responseStatusCode"] = @(statusCode);

    NSError *xwsError = [NSError xwsErrorWithStatusCode:statusCode
                                               userInfo:userInfo];
    return xwsError;
}

- (void)saveXAuthResponseParametersToKeychain:(NSDictionary*)responseParameters
                                      success:(void (^)(void))success
                                      failure:(void (^)(NSError *error))failure {
    NSString *userID = responseParameters[@"user_id"];
    NSString *accessToken = responseParameters[@"oauth_token"];
    NSString *accessTokenSecret = responseParameters[@"oauth_token_secret"];

    [self saveUserID:userID
         accessToken:accessToken
              secret:accessTokenSecret
             success:success
             failure:failure];
}

- (void)saveUserID:(NSString *)userID
       accessToken:(NSString *)accessToken
            secret:(NSString *)accessTokenSecret
           success:(void (^)(void))success
           failure:(void (^)(NSError *error))failure {

    NSError *error = nil;

    [SFHFKeychainUtils storeUsername:kUserIDName
                         andPassword:userID
                      forServiceName:kIdentifier
                      updateExisting:YES
                               error:&error];
    NSAssert( !error, @"KeychainUserIDWriteError: %@",error);

    [SFHFKeychainUtils storeUsername:kAccessTokenName
                         andPassword:accessToken
                      forServiceName:kIdentifier
                      updateExisting:YES
                               error:&error];
    NSAssert( !error, @"KeychainAccessToksaenWriteError: %@",error);
    _accessToken = accessToken;
    self.GTMOAuthAuthentication.token = accessToken;

    [SFHFKeychainUtils storeUsername:kTokenSecretName
                         andPassword:accessTokenSecret
                      forServiceName:kIdentifier
                      updateExisting:YES
                               error:&error];
    NSAssert( !error, @"KeychainTokenSecretWriteError: %@",error);
    _tokenSecret = accessTokenSecret;
    self.GTMOAuthAuthentication.tokenSecret = accessTokenSecret;

    if (error) {
        NSAssert(NO,@"Could not save into keychain");

        failure(error);
        return;
    }

    // all finished, call success block
    if (success) {
        success();
    }
}

- (void)deleteKeychainEntriesAndGTMOAuthAuthentication {

	NSError *error = nil;
	_userID = nil;
	[SFHFKeychainUtils deleteItemForUsername:kUserIDName
							  andServiceName:kIdentifier error:&error];
	NSAssert( !error || [error code] == -25300, @"KeychainUserIDDeleteError: %@",error);
	_accessToken = nil;
	[SFHFKeychainUtils deleteItemForUsername:kAccessTokenName
							  andServiceName:kIdentifier error:&error];
	NSAssert( !error || [error code] == -25300, @"KeychainAccessTokenDeleteError: %@",error);
	_tokenSecret = nil;
	[SFHFKeychainUtils deleteItemForUsername:kTokenSecretName
							  andServiceName:kIdentifier error:&error];
	NSAssert( !error || [error code] == -25300, @"KeychainTokenSecretDeleteError: %@",error);

    // delete the oauthAuthentication
	self.GTMOAuthAuthentication = nil;
}

- (NSString *)serviceProvider {
    if ([_serviceProvider length]) {
        return _serviceProvider;
    }
    return @"api.xing.com";
}

- (NSString *)signatureMethod {
    if ([_signatureMethod length]) {
        return _signatureMethod;
    }
    return @"HMAC-SHA1";
}

@end
