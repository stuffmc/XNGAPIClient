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

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "XNGJSONRequestOperation.h"
#import "XNGOAuthHandler.h"
#import "NSError+XWS.h"

@interface XNGAPIClient : AFHTTPClient

extern NSString * const XNGAPIClientInvalidTokenErrorNotification;
extern NSString * const XNGAPIClientDeprecationErrorNotification;
extern NSString * const XNGAPIClientDeprecationWarningNotification;

+ (XNGAPIClient *)clientWithBaseURL:(NSURL *)url;
+ (XNGAPIClient *)sharedClient;
+ (void)setSharedClient:(XNGAPIClient *)sharedClient;
+ (void)addAcceptableContentTypes:(NSSet *)set;

#pragma mark - Login / Logout

- (void)loginOAuthWithSuccess:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure;

- (BOOL)handleOpenURL:(NSURL *)URL;
- (void)loginXAuthWithUsername:(NSString*)username
                      password:(NSString*)password
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure;
- (BOOL)isLoggedin;
- (void)logout;

#pragma mark - block-based GET / PUT / POST / DELETE

/**
  default method to make a GET call to the public XING API.
  */
- (void)getJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure;

/**
 default method to make a PUT call to the public XING API.
 */
- (void)putJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
            success:(void (^)(id JSON))success
            failure:(void (^)(NSError *error))failure;

/**
 default method to make a POST call to the public XING API.
 */
- (void)postJSONPath:(NSString *)path
          parameters:(NSDictionary *)parameters
             success:(void (^)(id JSON))success
             failure:(void (^)(NSError *error))failure;

/**
 default method to make a DELETE call to the public XING API.
 */
- (void)deleteJSONPath:(NSString *)path
            parameters:(NSDictionary *)parameters
               success:(void (^)(id JSON))success
               failure:(void (^)(NSError *error))failure;

#pragma mark - block-based GET / PUT / POST / DELETE with optional accept headers

/**
 use this method to make a GET call to a vendor resource of the XING API.
 */
- (void)getJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
       acceptHeader:(NSString *)acceptHeader
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure;

/**
 use this method to make a PUT call to a vendor resource of the XING API.
 */
- (void)putJSONPath:(NSString *)path
         parameters:(NSDictionary *)parameters
       acceptHeader:(NSString *)acceptHeader
            success:(void (^)(id))success
            failure:(void (^)(NSError *))failure;

/**
 use this method to make a POST call to a vendor resource of the XING API.
 */
- (void)postJSONPath:(NSString *)path
          parameters:(NSDictionary *)parameters
        acceptHeader:(NSString *)acceptHeader
             success:(void (^)(id))success
             failure:(void (^)(NSError *))failure;

/**
 use this method to make a DELETE call to a vendor resource of the XING API.
 */
- (void)deleteJSONPath:(NSString *)path
            parameters:(NSDictionary *)parameters
          acceptHeader:(NSString *)acceptHeader
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure;

#pragma mark - HTTP Operation queue methods

- (void)enqueueJSONRequest:(NSMutableURLRequest *)request
                   success:(void (^)(id JSON))success
                   failure:(void (^)(NSError *error))failure;

#pragma mark - cancel requests methods

- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method paths:(NSArray *)paths;
- (void)cancelAllHTTPOperations;

#pragma mark - OAuth related methods

- (NSString *)currentUserID;

- (void)setConsumerKey:(NSString *)consumerKey;
- (void)setConsumerSecret:(NSString *)consumerSecret;
- (void)setCallbackScheme:(NSString*)callbackScheme;
- (void)setSignatureMethod:(NSString *)signatureMethod;
- (void)setServiceProvider:(NSString *)serviceProvider;
- (void)setUserAgent:(NSString *)userAgent;

@end
