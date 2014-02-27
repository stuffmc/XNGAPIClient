#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import "XNGAPI.h"

@interface XNGProfileVisitsTests : XCTestCase

@end

@implementation XNGProfileVisitsTests

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

- (void)testGetVisits {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getVisitsWithLimit:0
                                                  offset:0
                                                   since:nil
                                               stripHTML:NO
                                                 success:nil
                                                 failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/visits");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetVisitsWithParameters {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getVisitsWithLimit:20
                                                  offset:40
                                                   since:@"some_date"
                                               stripHTML:YES
                                                 success:nil
                                                 failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/visits");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];
         expect([query valueForKey:@"limit"]).to.equal(@"20");
         [query removeObjectForKey:@"limit"];
         expect([query valueForKey:@"offset"]).to.equal(@"40");
         [query removeObjectForKey:@"offset"];
         expect([query valueForKey:@"strip_html"]).to.equal(@"true");
         [query removeObjectForKey:@"strip_html"];
         expect([query valueForKey:@"since"]).to.equal(@"some_date");
         [query removeObjectForKey:@"since"];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testReportProfileVisit {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postReportProfileVisitForUserID:@"1"
                                                              success:nil
                                                              failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/visits");
         expect(request.HTTPMethod).to.equal(@"POST");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

@end
