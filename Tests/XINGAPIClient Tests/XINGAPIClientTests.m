#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"

@interface XINGAPIClientTests : XCTestCase

@end

@implementation XINGAPIClientTests

- (void)setUp {
    [super setUp];

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
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        expect(request.URL.host).to.equal(@"www.xing.com");
        expect(request.URL.path).to.equal(@"/v1/xauth");


        NSString *bodyString = [[NSString alloc] initWithData:request.HTTPBody
                                                      encoding:NSUTF8StringEncoding];

        NSMutableDictionary *bodyDict = [XNGTestHelper dictFromQueryString:bodyString];
        expect([bodyDict valueForKey:@"oauth_consumer_key"]).to.equal([XNGTestHelper fakeOAuthConsumerKey]);
        [bodyDict removeObjectForKey:@"oauth_consumer_key"];

        expect([bodyDict valueForKey:@"x_auth_mode"]).to.equal(@"client_auth");
        [bodyDict removeObjectForKey:@"x_auth_mode"];

        expect([bodyDict valueForKey:@"x_auth_password"]).to.equal(@"password");
        [bodyDict removeObjectForKey:@"x_auth_password"];

        expect([bodyDict valueForKey:@"x_auth_username"]).to.equal(@"username");
        [bodyDict removeObjectForKey:@"x_auth_username"];

        expect([bodyDict allKeys]).to.haveCountOf(0);


        NSMutableDictionary *queryDict = [XNGTestHelper dictFromQueryString:request.URL.query];
        expect([queryDict allKeys]).to.haveCountOf(0);

    }];

    [[XNGAPIClient sharedClient] loginXAuthWithUsername:@"username"
                                               password:@"password"
                                                success:^{}
                                                failure:^(NSError *error) {}];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
}


- (void)testLoginOAuth {
    [OHHTTPStubs onStubActivation:^(NSURLRequest *request, id<OHHTTPStubsDescriptor> stub) {
        expect(request.URL.host).to.equal(@"www.xing.com");
        expect(request.URL.path).to.equal(@"/v1/request_token");
        expect(request.URL.query).to.beNil;
        expect(request.HTTPBody).to.beNil;
    }];

    [[XNGAPIClient sharedClient] loginOAuthWithSuccess:^{}
                                               failure:^(NSError *error) {}];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
}

@end
