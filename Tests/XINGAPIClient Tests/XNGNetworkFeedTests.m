#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import "XINGAPI.h"

@interface XNGNetworkFeedTests : XCTestCase

@end

@implementation XNGNetworkFeedTests

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

- (void)testGetNetworkFeed {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getNetworkFeedUntil:nil
                                               userFields:nil
                                                  success:nil
                                                  failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/network_feed");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetNetworkFeedWithParameters {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getNetworkFeedUntil:@"1"
                                               userFields:@"display_name"
                                                  success:nil
                                                  failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/network_feed");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"until"]).to.equal(@"1");
         [query removeObjectForKey:@"until"];
         expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
         [query removeObjectForKey:@"user_fields"];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetUserFeed {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getUserFeedForUserID:@"1"
                                                     until:nil
                                                userFields:nil
                                                  success:nil
                                                  failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/feed");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetUserFeedWithParameters {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getUserFeedForUserID:@"1"
                                                     until:@"2"
                                                userFields:@"display_name"
                                                   success:nil
                                                   failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/feed");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"until"]).to.equal(@"2");
         [query removeObjectForKey:@"until"];
         expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
         [query removeObjectForKey:@"user_fields"];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testPostStatusMessage {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postStatusMessage:@"status message"
                                                 userID:@"1"
                                                success:nil
                                                failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/status_message");
         expect(request.HTTPMethod).to.equal(@"POST");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body valueForKey:@"message"]).to.equal(@"status%20message");
         [body removeObjectForKey:@"message"];

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testPostLink {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postLink:@"blalup"
                                       success:nil
                                       failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/share/link");
         expect(request.HTTPMethod).to.equal(@"POST");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body valueForKey:@"uri"]).to.equal(@"blalup");
         [body removeObjectForKey:@"uri"];

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetSingleActivity {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getSingleActivityWithID:@"1"
                                                   userFields:@"display_name"
                                                      success:nil
                                                      failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/activities/1");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
         [query removeObjectForKey:@"user_fields"];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testRecommendActivity {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postRecommendActivityWithID:@"1"
                                                          success:nil
                                                          failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/activities/1/share");
         expect(request.HTTPMethod).to.equal(@"POST");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testDeleteActivity {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] deleteActivityWithID:@"1"
                                                   success:nil
                                                   failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/activities/1");
         expect(request.HTTPMethod).to.equal(@"DELETE");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetComments {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getCommentsWithActivityID:@"1"
                                                     userFields:nil
                                                         offset:0
                                                          limit:0
                                                        success:nil
                                                        failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/activities/1/comments");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetCommentsWithParameters {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getCommentsWithActivityID:@"1"
                                                     userFields:@"display_name"
                                                         offset:20
                                                          limit:40
                                                        success:nil
                                                        failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/activities/1/comments");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"offset"]).to.equal(@"20");
         [query removeObjectForKey:@"offset"];
         expect([query valueForKey:@"limit"]).to.equal(@"40");
         [query removeObjectForKey:@"limit"];
         expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
         [query removeObjectForKey:@"user_fields"];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testPostNewComment {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postNewComment:@"comment"
                                          activityID:@"1"
                                             success:nil
                                             failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/activities/1/comments");
         expect(request.HTTPMethod).to.equal(@"POST");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body valueForKey:@"text"]).to.equal(@"comment");
         [body removeObjectForKey:@"text"];
         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testDeleteComment {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] deleteCommentWithID:@"1"
                                               activityID:@"2"
                                                  success:nil
                                                  failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/activities/2/comments/1");
         expect(request.HTTPMethod).to.equal(@"DELETE");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetLikes {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getLikesForActivityID:@"1"
                                                 userFields:nil
                                                     offset:0
                                                      limit:0
                                                    success:nil
                                                    failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/activities/1/likes");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetLikesWithParameters {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getLikesForActivityID:@"1"
                                                 userFields:@"display_name"
                                                     offset:20
                                                      limit:40
                                                    success:nil
                                                    failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/activities/1/likes");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"offset"]).to.equal(@"20");
         [query removeObjectForKey:@"offset"];
         expect([query valueForKey:@"limit"]).to.equal(@"40");
         [query removeObjectForKey:@"limit"];
         expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
         [query removeObjectForKey:@"user_fields"];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testLikeActivity {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] putLikeActivityWithID:@"1"
                                                    success:nil
                                                    failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/activities/1/like");
         expect(request.HTTPMethod).to.equal(@"PUT");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testUnlikeActivity {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] deleteUnlikeActivityWithID:@"1"
                                                         success:nil
                                                         failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/activities/1/like");
         expect(request.HTTPMethod).to.equal(@"DELETE");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

@end
