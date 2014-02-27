#import <XCTest/XCTest.h>
#import "XNGTestHelper.h"
#import "XNGAPI.h"

@interface XNGContactsTests : XCTestCase

@end

@implementation XNGContactsTests

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
}

#pragma mark - get contacts

- (void)testGetContacts {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getContactsForUserID:@"1"
                                                     limit:0
                                                    offset:0
                                                   orderBy:XNGContactsOrderOptionByID
                                                userFields:nil
                                                   success:nil
                                                   failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/contacts");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];
         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetContactsWithParameters {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getContactsForUserID:@"1"
                                                     limit:20
                                                    offset:40
                                                   orderBy:XNGContactsOrderOptionByLastName
                                                userFields:@"display_name"
                                                   success:nil
                                                   failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/contacts");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
         [query removeObjectForKey:@"user_fields"];

         expect([query valueForKey:@"limit"]).to.equal(@"20");
         [query removeObjectForKey:@"limit"];
         expect([query valueForKey:@"offset"]).to.equal(@"40");
         [query removeObjectForKey:@"offset"];
         expect([query valueForKey:@"order_by"]).to.equal(@"last_name");
         [query removeObjectForKey:@"order_by"];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetContactIDs {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getContactIDsForUserID:@"1"
                                                       limit:0
                                                      offset:0
                                                     success:nil
                                                     failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/contacts");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetContactIDsWithParameters {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getContactIDsForUserID:@"1"
                                                       limit:20
                                                      offset:40
                                                     success:nil
                                                     failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/contacts");
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

- (void)testGetSharedContacts {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getSharedContactsForUserID:@"1"
                                                           limit:0
                                                          offset:0
                                                         orderBy:XNGContactsOrderOptionByID
                                                      userFields:nil
                                                         success:nil
                                                         failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/contacts/shared");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetSharedContactsWithParameters {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getSharedContactsForUserID:@"1"
                                                           limit:20
                                                          offset:40
                                                         orderBy:XNGContactsOrderOptionByLastName
                                                      userFields:@"display_name"
                                                         success:nil
                                                         failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/contacts/shared");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"user_fields"]).to.equal(@"display_name");
         [query removeObjectForKey:@"user_fields"];
         expect([query valueForKey:@"limit"]).to.equal(@"20");
         [query removeObjectForKey:@"limit"];
         expect([query valueForKey:@"offset"]).to.equal(@"40");
         [query removeObjectForKey:@"offset"];
         expect([query valueForKey:@"order_by"]).to.equal(@"last_name");
         [query removeObjectForKey:@"order_by"];

         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

- (void)testGetContactCount {
    [XNGTestHelper executeCall:
     ^{
         [[XNGAPIClient sharedClient] getContactsCountForUserID:@"1"
                                                        success:nil
                                                        failure:nil];
     }
               withExpectations:
     ^(NSURLRequest *request, NSMutableDictionary *query, NSMutableDictionary *body) {
         expect(request.URL.host).to.equal(@"www.xing.com");
         expect(request.URL.path).to.equal(@"/v1/users/1/contacts");
         expect(request.HTTPMethod).to.equal(@"GET");

         [XNGTestHelper assertAndRemoveOAuthParametersInQueryDict:query];

         expect([query valueForKey:@"limit"]).to.equal(@"0");
         [query removeObjectForKey:@"limit"];
         expect([query allKeys]).to.haveCountOf(0);

         expect([body allKeys]).to.haveCountOf(0);
     }];
}

@end
