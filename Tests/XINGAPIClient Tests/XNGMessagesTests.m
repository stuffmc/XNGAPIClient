#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import "XNGAPI.h"

@interface XNGMessagesTests : XCTestCase

@end

@implementation XNGMessagesTests

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

- (void)testGetConversations {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getConversationsWithLimit:0
                                                         offset:0
                                                     userFields:nil
                                             withLatestMessages:0
                                                        success:nil
                                                        failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetConversationsWithParameters {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getConversationsWithLimit:20
                                                         offset:40
                                                     userFields:@"display_name"
                                             withLatestMessages:60
                                                        success:nil
                                                        failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"limit"]).to.equal(@"20");
         [query removeObjectForKey:@"limit"];
         expect([query valueForKey:@"offset"]).to.equal(@"40");
         [query removeObjectForKey:@"offset"];
         expect([query valueForKey:@"with_latest_messages"]).to.equal(@"60");
         [query removeObjectForKey:@"with_latest_messages"];
         expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
         [query removeObjectForKey:@"user_fields"];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testPostNewConversation {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postCreateNewConversationWithRecipientIDs:@"2"
                                                                        subject:@"Hey"
                                                                        content:@"some content" success:nil
                                                                        failure:nil];
     } withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations");
         expect(request.HTTPMethod).to.equal(@"POST");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body valueForKey:@"content"]).to.equal(@"some%20content");
         [body removeObjectForKey:@"content"];
         expect([body valueForKey:@"recipient_ids"]).to.equal(@"2");
         [body removeObjectForKey:@"recipient_ids"];
         expect([body valueForKey:@"subject"]).to.equal(@"Hey");
         [body removeObjectForKey:@"subject"];

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetIsRecipientValid {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getIsRecipientValidWithUserID:@"2"
                                                            success:nil
                                                            failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations/valid_recipients/2");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetConversation {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getConversationWithID:@"1"
                                                 userFields:nil
                                         withLatestMessages:0
                                                    success:nil
                                                    failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations/1");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetConversationWithParameters {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getConversationWithID:@"1"
                                                 userFields:@"display_name"
                                         withLatestMessages:20
                                                    success:nil
                                                    failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations/1");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
         [query removeObjectForKey:@"user_fields"];
         expect([query valueForKey:@"with_latest_messages"]).to.equal(@"20");
         [query removeObjectForKey:@"with_latest_messages"];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}


- (void)testPostDownloadURL {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postDownloadURLForAttachmentID:@"1"
                                                      conversationID:@"2"
                                                             success:nil
                                                             failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations/2/attachments/1/download");
         expect(request.HTTPMethod).to.equal(@"POST");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testPutMarkConversationRead {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] putMarkConversationAsReadWithConversationID:@"1"
                                                                          success:nil
                                                                          failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations/1/read");
         expect(request.HTTPMethod).to.equal(@"PUT");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetMessages {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getMessagesForConversationID:@"1"
                                                             limit:0
                                                            offset:0
                                                        userFields:nil
                                                           success:nil
                                                           failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations/1/messages");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testMarkMessageRead {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] putMarkMessageAsReadWithMessageID:@"1"
                                                         conversationID:@"2"
                                                                success:nil
                                                                failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations/2/messages/1/read");
         expect(request.HTTPMethod).to.equal(@"PUT");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testMarkMessageUnread {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] deleteMarkMessageAsUnreadWithMessageID:@"1"
                                                              conversationID:@"2"
                                                                     success:nil
                                                                     failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations/2/messages/1/read");
         expect(request.HTTPMethod).to.equal(@"DELETE");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testCreateReply {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] postCreateReplyToConversationWithConversationID:@"1"
                                                                              content:@"blala"
                                                                              success:nil
                                                                              failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations/1/messages");
         expect(request.HTTPMethod).to.equal(@"POST");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body valueForKey:@"content"]).to.equal(@"blala");
         [body removeObjectForKey:@"content"];

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testDeleteConversation {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] deleteConversationWithConversationID:@"1"
                                                                   success:nil
                                                                   failure:nil];
     }
              withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/me/conversations/1");
         expect(request.HTTPMethod).to.equal(@"DELETE");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

@end
