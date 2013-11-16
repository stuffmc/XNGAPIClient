#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"

@interface XINGAPIClientTests : XCTestCase

@end

@implementation XINGAPIClientTests

- (void)setUp {
    [super setUp];

    // make sure no user is logged in, e.g. from a dev or beta app.
    [XNGTestHelper tearDownLoggedInUser];

    [XNGTestHelper setupOAuthCredentials];

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

- (void)testloginXAuth {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] loginXAuthWithUsername:@"username"
                                                    password:@"password"
                                                     success:^{}
                                                     failure:^(NSError *error) {}];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/xauth");
         expect(request.HTTPMethod).to.equal(@"POST");

         NSString *authHeader = [request.allHTTPHeaderFields valueForKey:@"Authorization"];
         expect([authHeader hasPrefix:@"OAuth oauth_consumer_key=\"123\""]).to.beTruthy;

         expect([body valueForKey:@"x_auth_mode"]).to.equal(@"client_auth");
         [body removeObjectForKey:@"x_auth_mode"];

         expect([body valueForKey:@"x_auth_password"]).to.equal(@"password");
         [body removeObjectForKey:@"x_auth_password"];

         expect([body valueForKey:@"x_auth_username"]).to.equal(@"username");
         [body removeObjectForKey:@"x_auth_username"];

         expect([body allKeys]).to.haveCountOf(0);

         expect([query allKeys]).to.haveCountOf(0);
     }];
}

- (void)testLoginOAuth {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] loginOAuthWithSuccess:^{}
                                                    failure:^(NSError *error) {}];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/request_token");
         expect(request.HTTPMethod).to.equal(@"POST");
         expect([query allKeys]).to.haveCountOf(0);
         expect([body allKeys]).to.haveCountOf(0);
     }];
}

@end
