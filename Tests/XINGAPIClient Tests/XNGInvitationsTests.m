#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import "XNGAPIClient+Invitations.h"

@interface XNGInvitationsTests : XCTestCase

@end

@implementation XNGInvitationsTests

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

- (void)testPostSendInvitations {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postSendInvitationsToEmails:@"invite@someone.com"
                                                          message:@"inviting text"
                                                          success:nil
                                                          failure:nil];
     }
               withExpecations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/invite");
         expect(request.HTTPMethod).to.equal(@"POST");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body valueForKey:@"message"]).to.equal(@"inviting%20text");
         [body removeObjectForKey:@"message"];
         expect([body valueForKey:@"user_fields"]).to.equal(@"id");
         [body removeObjectForKey:@"user_fields"];
         expect([body valueForKey:@"to_emails"]).to.equal(@"invite%40someone.com");
         [body removeObjectForKey:@"to_emails"];

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

@end
