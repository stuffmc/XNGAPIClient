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
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getContactRequestsWithLimit:0
                                                           offset:0
                                                       userFields:nil
                                                          success:nil
                                                          failure:nil];
     }
               withExpecations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/contact_requests");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];
         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
    }];
}

- (void)testGetContactRequestsWithLimitAndOffset {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getContactRequestsWithLimit:20
                                                           offset:40
                                                       userFields:nil
                                                          success:nil
                                                          failure:nil];
     }
               withExpecations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/contact_requests");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"limit"]).to.equal(@"20");
         [query removeObjectForKey:@"limit"];
         expect([query valueForKey:@"offset"]).to.equal(@"40");
         [query removeObjectForKey:@"offset"];
         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

#pragma mark - put post delete calls

- (void)testPostCreateContactRequest {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postCreateContactRequestToUserWithID:@"2"
                                                                   message:@"blalup"
                                                                   success:nil
                                                                   failure:nil];
     }
               withExpecations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/2/contact_requests");
         expect(request.HTTPMethod).to.equal(@"POST");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body valueForKey:@"message"]).to.equal(@"blalup");
         [body removeObjectForKey:@"message"];

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testPutConfirmContactRequest {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] putConfirmContactRequestForUserID:@"1"
                                                               senderID:@"2"
                                                                success:nil
                                                                failure:nil];
     }
               withExpecations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/contact_requests/2/accept");
         expect(request.HTTPMethod).to.equal(@"PUT");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testDeleteDeclineContactRequest {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] deleteDeclineContactRequestForUserID:@"1"
                                                                  senderID:@"2"
                                                                   success:nil
                                                                   failure:nil];
     }
               withExpecations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/contact_requests/2");
         expect(request.HTTPMethod).to.equal(@"DELETE");

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

@end
