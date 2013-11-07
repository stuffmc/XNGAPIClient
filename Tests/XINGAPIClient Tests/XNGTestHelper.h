#import <Foundation/Foundation.h>

#import <OHHTTPStubs/OHHTTPStubs.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "XNGAPIClient.h"

@interface XNGTestHelper : NSObject

+ (void)setupOAuthCredentials;
+ (void)tearDownOAuthCredentials;

+ (void)setupLoggedInUserWithUserID:(NSString *)userID;
+ (void)tearDownLoggedInUser;


+ (void)assertAndRemoveOAuthParametersInQueryDict:(NSMutableDictionary *)queryDict;
+ (NSMutableDictionary *)queryDictFromQueryString:(NSString *)queryString;

@end
