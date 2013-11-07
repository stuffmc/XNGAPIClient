#import "XNGTestHelper.h"

@implementation XNGTestHelper

#pragma mark - setup and teardown helper

+ (void)setupOAuthCredentials {
    [[XNGAPIClient sharedClient] setConsumerKey:@"123"];
    [[XNGAPIClient sharedClient] setConsumerSecret:@"456"];
}

+ (void)tearDownOAuthCredentials {
    [[XNGAPIClient sharedClient] setConsumerKey:nil];
    [[XNGAPIClient sharedClient] setConsumerSecret:nil];
}

+ (void)setupLoggedInUserWithUserID:(NSString *)userID {
    XNGOAuthHandler *oauthHandler = [[XNGOAuthHandler alloc] init];
    [oauthHandler saveUserID:userID
                 accessToken:@"789"
                      secret:@"456"
                     success:nil
                     failure:nil];
}

+ (void)tearDownLoggedInUser {
    XNGOAuthHandler *oauthHandler = [[XNGOAuthHandler alloc] init];
    [oauthHandler deleteKeychainEntriesAndGTMOAuthAuthentication];
}

#pragma mark - oauth parameter helper

+ (void)assertAndRemoveOAuthParametersInQueryDict:(NSMutableDictionary *)queryDict {
    for (NSString *oauthParameter in @[ @"oauth_token",
                                        @"oauth_signature_method",
                                        @"oauth_version",
                                        @"oauth_nonce",
                                        @"oauth_consumer_key",
                                        @"oauth_timestamp",
                                        @"oauth_signature" ]) {
        expect([queryDict valueForKey:oauthParameter]).toNot.beNil;
        [queryDict removeObjectForKey:oauthParameter];
    }
}

+ (NSMutableDictionary *)queryDictFromQueryString:(NSString *)queryString {
    NSArray *componentsArray = [queryString componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *keyValueString in componentsArray) {
        NSArray *array = [keyValueString componentsSeparatedByString:@"="];
        [dict setValue:array[1] forKey:array[0]];
    }
    return dict;
}
@end
