//
//  XNGOAuthHandlerTests.m
//  XINGAPIClient Tests
//
//  Created by Piet Brauer on 11.11.13.
//  Copyright (c) 2013 XING AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XINGAPI/XNGOAuthHandler.h>
#import <SSKeychain/SSKeychain.h>

#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

@interface XNGOAuthHandlerTests : XCTestCase

@end

@implementation XNGOAuthHandlerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testUserIDGettingWhenNotInKeychain {
    [SSKeychain deletePasswordForService:@"com.xing.iphone-app-2010" account:@"UserID"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.userID).to.beNil;
}

- (void)testUserIDGettingWhenInKeychain {
    [SSKeychain setPassword:@"3" forService:@"com.xing.iphone-app-2010" account:@"UserID"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.userID).to.equal(@"3");
}

- (void)testAccessTokenGettingWhenNotInKeychain {
    [SSKeychain deletePasswordForService:@"com.xing.iphone-app-2010" account:@"AccessToken"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.accessToken).to.beNil;
}

- (void)testAccessTokenGettingWhenInKeychain {
    [SSKeychain setPassword:@"12345" forService:@"com.xing.iphone-app-2010" account:@"AccessToken"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.accessToken).to.equal(@"12345");
}

- (void)testTokenSecretGettingWhenNotInKeychain {
    [SSKeychain deletePasswordForService:@"com.xing.iphone-app-2010" account:@"TokenSecret"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.tokenSecret).to.beNil;
}

- (void)testTokenSecretGettingWhenInKeychain {
    [SSKeychain setPassword:@"65785" forService:@"com.xing.iphone-app-2010" account:@"TokenSecret"];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.tokenSecret).to.equal(@"65785");
}

- (void)testXAuthSavingToKeychain {
    NSDictionary *responseParameters = @{@"user_id": @"123", @"oauth_token": @"45678", @"oauth_token_secret": @"54321"};

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    [classUnderTest saveXAuthResponseParametersToKeychain:responseParameters success:nil failure:nil];

    NSString *userID = [SSKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"UserID"];
    expect(userID).to.equal(@"123");

    NSString *accessToken = [SSKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"AccessToken"];
    expect(accessToken).to.equal(@"45678");

    NSString *tokenSecret = [SSKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"TokenSecret"];
    expect(tokenSecret).to.equal(@"54321");
}

- (void)testSaving
{
    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    [classUnderTest saveUserID:@"3" accessToken:@"1234567" secret:@"890" success:nil failure:nil];

    NSString *userID = [SSKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"UserID"];
    expect(userID).to.equal(@"3");

    NSString *accessToken = [SSKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"AccessToken"];
    expect(accessToken).to.equal(@"1234567");

    NSString *tokenSecret = [SSKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"TokenSecret"];
    expect(tokenSecret).to.equal(@"890");
}

- (void)testDeleting {
    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    [classUnderTest deleteKeychainEntries];

    NSString *userID = [SSKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"UserID"];
    expect(userID).to.beNil;

    NSString *accessToken = [SSKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"AccessToken"];
    expect(accessToken).to.beNil;

    NSString *tokenSecret = [SSKeychain passwordForService:@"com.xing.iphone-app-2010" account:@"TokenSecret"];
    expect(tokenSecret).to.beNil;
}

@end
