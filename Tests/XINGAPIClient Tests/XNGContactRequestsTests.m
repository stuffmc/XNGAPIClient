#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import "XNGAPIClient+ContactRequests.h"

@interface XNGContactRequestsTests : XCTestCase

@end

@implementation XNGContactRequestsTests

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

#pragma mark - get contact requests

- (void)testGetContactRequests {
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        expect(request.URL.host).to.equal(@"www.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/contact_requests");
        expect(request.HTTPMethod).to.equal(@"GET");

        NSMutableDictionary *queryDict = [XNGTestHelper dictFromQueryString:request.URL.query];
        [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:queryDict];

        expect([queryDict allKeys]).to.haveCountOf(0);
    }];

    [[XNGAPIClient sharedClient] getContactRequestsWithLimit:0
                                                      offset:0
                                                  userFields:nil
                                                     success:nil
                                                     failure:nil];

    [XNGTestHelper runRunLoopShortly];
}

- (void)testGetContactRequestsWithLimitAndOffset {
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        expect(request.URL.host).to.equal(@"www.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/me/contact_requests");
        expect(request.HTTPMethod).to.equal(@"GET");

        NSMutableDictionary *queryDict = [XNGTestHelper dictFromQueryString:request.URL.query];
        [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:queryDict];

        expect([queryDict valueForKey:@"limit"]).to.equal(@"20");
        [queryDict removeObjectForKey:@"limit"];
        expect([queryDict valueForKey:@"offset"]).to.equal(@"40");
        [queryDict removeObjectForKey:@"offset"];
        expect([queryDict allKeys]).to.haveCountOf(0);
    }];

    [[XNGAPIClient sharedClient] getContactRequestsWithLimit:20
                                                      offset:40
                                                  userFields:nil
                                                     success:nil
                                                     failure:nil];

    [XNGTestHelper runRunLoopShortly];
}

#pragma mark - put post delete calls

- (void)testPostCreateContactRequest {
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        expect(request.URL.host).to.equal(@"www.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/2/contact_requests");
        expect(request.HTTPMethod).to.equal(@"POST");

        NSMutableDictionary *queryDict = [XNGTestHelper dictFromQueryString:request.URL.query];
        [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:queryDict];

        expect([queryDict allKeys]).to.haveCountOf(0);

        NSString *bodyString = [XNGTestHelper stringFromData:request.HTTPBody];
        NSMutableDictionary *bodyDict = [XNGTestHelper dictFromQueryString:bodyString];

        expect([bodyDict valueForKey:@"message"]).to.equal(@"blalup");
        [bodyDict removeObjectForKey:@"message"];

        expect([bodyDict allKeys]).to.haveCountOf(0);
    }];

    [[XNGAPIClient sharedClient] postCreateContactRequestToUserWithID:@"2"
                                                              message:@"blalup"
                                                              success:nil
                                                              failure:nil];

    [XNGTestHelper runRunLoopShortly];
}

- (void)testPutConfirmContactRequest {
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        expect(request.URL.host).to.equal(@"www.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/1/contact_requests/2/accept");
        expect(request.HTTPMethod).to.equal(@"PUT");

        NSMutableDictionary *queryDict = [XNGTestHelper dictFromQueryString:request.URL.query];
        [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:queryDict];

        expect([queryDict allKeys]).to.haveCountOf(0);

        NSString *bodyString = [XNGTestHelper stringFromData:request.HTTPBody];
        NSMutableDictionary *bodyDict = [XNGTestHelper dictFromQueryString:bodyString];

        expect([bodyDict allKeys]).to.haveCountOf(0);
    }];

    [[XNGAPIClient sharedClient] putConfirmContactRequestForUserID:@"1"
                                                          senderID:@"2"
                                                           success:nil
                                                           failure:nil];
    
    [XNGTestHelper runRunLoopShortly];
}

- (void)testDeleteDeclineContactRequest {
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        expect(request.URL.host).to.equal(@"www.xing.com");
        expect(request.URL.path).to.equal(@"/v1/users/1/contact_requests/2");
        expect(request.HTTPMethod).to.equal(@"DELETE");

        NSMutableDictionary *queryDict = [XNGTestHelper dictFromQueryString:request.URL.query];
        [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:queryDict];

        expect([queryDict allKeys]).to.haveCountOf(0);

        NSString *bodyString = [XNGTestHelper stringFromData:request.HTTPBody];
        NSMutableDictionary *bodyDict = [XNGTestHelper dictFromQueryString:bodyString];

        expect([bodyDict allKeys]).to.haveCountOf(0);
    }];

    [[XNGAPIClient sharedClient] deleteDeclineContactRequestForUserID:@"1"
                                                             senderID:@"2"
                                                              success:nil
                                                              failure:nil];

    [XNGTestHelper runRunLoopShortly];
}

@end
