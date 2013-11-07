#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>


#import "XNGAPIClient+ContactPath.h"

@interface XNGContactPathTests : XCTestCase

@end

@implementation XNGContactPathTests

- (void)setUp {
    [super setUp];
    [[XNGAPIClient sharedClient] setConsumerKey:@"123"];
    [[XNGAPIClient sharedClient] setConsumerSecret:@"456"];
    XNGOAuthHandler *oauthHandler = [[XNGOAuthHandler alloc] init];
    [oauthHandler saveUserID:@"1" accessToken:@"789" secret:@"456" success:nil failure:nil];

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return nil;
    }];
}

- (void)tearDown {
    [super tearDown];
    XNGOAuthHandler *oauthHandler = [[XNGOAuthHandler alloc] init];
    [oauthHandler deleteKeychainEntriesAndGTMOAuthAuthentication];
    [OHHTTPStubs removeAllStubs];
}

- (void)testContactPath {
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        expect(request.URL.host).to.equal(@"www.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/network/1/paths");
        NSDictionary *queryDict = [self queryDictFromQueryString:request.URL.query];
        [self assertOAuthParametersInQueryDict:queryDict];
    }];

    [[XNGAPIClient sharedClient] getContactPathForOtherUserID:@"1"
                                                   userFields:nil
                                                      success:nil
                                                      failure:nil];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
}


- (void)testContactPathWithUserFields {
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        expect(request.URL.host).to.equal(@"www.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/network/1/paths");
        NSDictionary *queryDict = [self queryDictFromQueryString:request.URL.query];
        [self assertOAuthParametersInQueryDict:queryDict];
        expect([queryDict valueForKey:@"user_fields"]).to.equal(@"display_name");
    }];

    [[XNGAPIClient sharedClient] getContactPathForOtherUserID:@"1"
                                                   userFields:@"display_name"
                                                      success:nil
                                                      failure:nil];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
}


#pragma mark - Helper

- (void)assertOAuthParametersInQueryDict:(NSDictionary *)queryDict {
    expect([queryDict valueForKey:@"oauth_token"]).toNot.beNil;
    expect([queryDict valueForKey:@"oauth_signature_method"]).toNot.beNil;
    expect([queryDict valueForKey:@"oauth_version"]).toNot.beNil;
    expect([queryDict valueForKey:@"oauth_nonce"]).toNot.beNil;
    expect([queryDict valueForKey:@"oauth_timestamp"]).toNot.beNil;
    expect([queryDict valueForKey:@"oauth_signature"]).toNot.beNil;
}

- (NSDictionary *)queryDictFromQueryString:(NSString *)queryString {
    NSArray *componentsArray = [queryString componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *keyValueString in componentsArray) {
        NSArray *array = [keyValueString componentsSeparatedByString:@"="];
        [dict setValue:array[1] forKey:array[0]];
    }
    return dict;
}

@end
