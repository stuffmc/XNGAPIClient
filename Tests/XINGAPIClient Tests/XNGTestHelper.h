#import <Foundation/Foundation.h>

#import <OHHTTPStubs/OHHTTPStubs.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "XNGAPIClient.h"

@interface XNGTestHelper : NSObject

+ (NSString *)fakeOAuthConsumerKey;
+ (NSString *)fakeOAuthConsumerSecret;

+ (void)setupOAuthCredentials;
+ (void)tearDownOAuthCredentials;

+ (void)setupLoggedInUserWithUserID:(NSString *)userID;
+ (void)tearDownLoggedInUser;

+ (NSString *)stringFromData:(NSData *)data;

+ (void)assertAndRemoveOAuthParametersInQueryDict:(NSMutableDictionary *)queryDict;
+ (NSMutableDictionary *)dictFromQueryString:(NSString *)queryString;

+ (void)runRunLoopShortly;

@end
