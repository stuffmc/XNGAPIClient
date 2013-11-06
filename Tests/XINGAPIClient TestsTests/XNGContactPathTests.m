#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

#import "XNGAPIClient+ContactPath.h"

@interface XNGContactPathTests : XCTestCase

@end

@implementation XNGContactPathTests

- (void)setUp {
    [super setUp];
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return nil;
    }];
}

- (void)tearDown {
    [super tearDown];
    [OHHTTPStubs removeAllStubs];
}

- (void)testContactPath {
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        XCTAssertTrue([request.URL.host isEqualToString:@"www.xing.com"], @"called the wrong host");
        XCTAssertTrue([request.URL.path isEqualToString:@"/v1/users/me/network/1/paths"], @"called the wrong path");
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
        XCTAssertTrue([request.URL.host isEqualToString:@"www.xing.com"], @"called the wrong host");
        XCTAssertTrue([request.URL.path isEqualToString:@"/v1/users/me/network/1/paths"], @"called the wrong path");
        NSDictionary *queryDict = [self queryDictFromQueryString:request.URL.query];
        [self assertOAuthParametersInQueryDict:queryDict];
        XCTAssertTrue([[queryDict valueForKey:@"user_fields"] isEqualToString:@"display_name"], @"no/incorrect user_fields in query");
    }];

    [[XNGAPIClient sharedClient] getContactPathForOtherUserID:@"1"
                                                   userFields:@"display_name"
                                                      success:nil
                                                      failure:nil];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
}


#pragma mark - Helper

- (void)assertOAuthParametersInQueryDict:(NSDictionary *)queryDict {
    XCTAssertTrue([queryDict valueForKey:@"oauth_token"], @"no oauth_token in query");
    XCTAssertTrue([queryDict valueForKey:@"oauth_signature_method"], @"no oauth_signature_method in query");
    XCTAssertTrue([queryDict valueForKey:@"oauth_version"], @"no oauth_version in query");
    XCTAssertTrue([queryDict valueForKey:@"oauth_nonce"], @"no oauth_nonce in query");
    XCTAssertTrue([queryDict valueForKey:@"oauth_timestamp"], @"no oauth_timestamp in query");
    XCTAssertTrue([queryDict valueForKey:@"oauth_signature"], @"no oauth_signature in query");
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
