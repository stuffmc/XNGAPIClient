#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import "XNGAPIClient+ContactPath.h"

@interface XNGContactPathTests : XCTestCase

@end

@implementation XNGContactPathTests

- (void)setUp {
    [super setUp];

    [XNGTestHelper setupOAuthCredentials];

    [XNGTestHelper setupLoggedInUserWithUserID:@"1"];

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return nil;
    }];
}

- (void)tearDown {
    [super tearDown];

    [XNGTestHelper tearDownOAuthCredentials];

    [XNGTestHelper tearDownLoggedInUser];

    [OHHTTPStubs removeAllStubs];
}

- (void)testGetContactPath {
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        expect(request.URL.host).to.equal(@"www.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/network/1/paths");
        expect(request.HTTPMethod).to.equal(@"GET");

        NSMutableDictionary *queryDict = [XNGTestHelper dictFromQueryString:request.URL.query];
        [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:queryDict];

        expect([queryDict allKeys]).to.haveCountOf(0);
    }];

    [[XNGAPIClient sharedClient] getContactPathForOtherUserID:@"1"
                                                   userFields:nil
                                                      success:nil
                                                      failure:nil];

    [XNGTestHelper runRunLoopShortly];
}


- (void)testGetContactPathWithUserFields {
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        expect(request.URL.host).to.equal(@"www.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/network/1/paths");
        expect(request.HTTPMethod).to.equal(@"GET");

        NSMutableDictionary *queryDict = [XNGTestHelper dictFromQueryString:request.URL.query];
        [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:queryDict];

        expect([queryDict valueForKey:@"user_fields"]).to.equal(@"display_name");
        [queryDict removeObjectForKey:@"user_fields"];

        expect([queryDict allKeys]).to.haveCountOf(0);
    }];

    [[XNGAPIClient sharedClient] getContactPathForOtherUserID:@"1"
                                                   userFields:@"display_name"
                                                      success:nil
                                                      failure:nil];

    [XNGTestHelper runRunLoopShortly];
}

@end
