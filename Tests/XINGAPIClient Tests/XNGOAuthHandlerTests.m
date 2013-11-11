//
//  XNGOAuthHandlerTests.m
//  XINGAPIClient Tests
//
//  Created by Piet Brauer on 11.11.13.
//  Copyright (c) 2013 XING AG. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <XINGAPI/XNGOAuthHandler.h>
#import <SFHFKeychainUtils/SFHFKeychainUtils.h>

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

    [SFHFKeychainUtils deleteItemForUsername:@"UserID"
							  andServiceName:@"com.xing.iphone-app-2010" error:nil];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.userID).to.beNil;
}

- (void)testUserIDGettingWhenInKeychain {
    [SFHFKeychainUtils storeUsername:@"UserID" andPassword:@"3" forServiceName:@"com.xing.iphone-app-2010" updateExisting:YES error:nil];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.userID).to.equal(@"3");
}

- (void)testAccessTokenGettingWhenNotInKeychain {

    [SFHFKeychainUtils deleteItemForUsername:@"AccessToken"
							  andServiceName:@"com.xing.iphone-app-2010" error:nil];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.accessToken).to.beNil;
}

- (void)testAccessTokenGettingWhenInKeychain {
    [SFHFKeychainUtils storeUsername:@"AccessToken" andPassword:@"12345" forServiceName:@"com.xing.iphone-app-2010" updateExisting:YES error:nil];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.accessToken).to.equal(@"12345");
}

- (void)testTokenSecretGettingWhenNotInKeychain {

    [SFHFKeychainUtils deleteItemForUsername:@"TokenSecret"
							  andServiceName:@"com.xing.iphone-app-2010" error:nil];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.tokenSecret).to.beNil;
}

- (void)testTokenSecretGettingWhenInKeychain {
    [SFHFKeychainUtils storeUsername:@"TokenSecret" andPassword:@"65785" forServiceName:@"com.xing.iphone-app-2010" updateExisting:YES error:nil];

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    expect(classUnderTest.tokenSecret).to.equal(@"65785");
}

- (void)testXAuthSavingToKeychain {
    NSDictionary *responseParameters = @{@"user_id": @"123", @"oauth_token": @"45678", @"oauth_token_secret": @"54321"};

    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    [classUnderTest saveXAuthResponseParametersToKeychain:responseParameters success:nil failure:nil];

    NSString *userID = [SFHFKeychainUtils getPasswordForUsername:@"UserID" andServiceName:@"com.xing.iphone-app-2010" error:nil];
    expect(userID).to.equal(@"123");

    NSString *accessToken = [SFHFKeychainUtils getPasswordForUsername:@"AccessToken" andServiceName:@"com.xing.iphone-app-2010" error:nil];
    expect(accessToken).to.equal(@"45678");

    NSString *tokenSecret = [SFHFKeychainUtils getPasswordForUsername:@"TokenSecret" andServiceName:@"com.xing.iphone-app-2010" error:nil];
    expect(tokenSecret).to.equal(@"54321");
}

- (void)testSaving
{
    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    [classUnderTest saveUserID:@"3" accessToken:@"1234567" secret:@"890" success:nil failure:nil];

    NSString *userID = [SFHFKeychainUtils getPasswordForUsername:@"UserID" andServiceName:@"com.xing.iphone-app-2010" error:nil];
    expect(userID).to.equal(@"3");

    NSString *accessToken = [SFHFKeychainUtils getPasswordForUsername:@"AccessToken" andServiceName:@"com.xing.iphone-app-2010" error:nil];
    expect(accessToken).to.equal(@"1234567");

    NSString *tokenSecret = [SFHFKeychainUtils getPasswordForUsername:@"TokenSecret" andServiceName:@"com.xing.iphone-app-2010" error:nil];
    expect(tokenSecret).to.equal(@"890");
}

- (void)testDeleting {
    XNGOAuthHandler *classUnderTest = [[XNGOAuthHandler alloc] init];
    [classUnderTest deleteKeychainEntriesAndGTMOAuthAuthentication];

    NSString *userID = [SFHFKeychainUtils getPasswordForUsername:@"UserID" andServiceName:@"com.xing.iphone-app-2010" error:nil];
    expect(userID).to.beNil;

    NSString *accessToken = [SFHFKeychainUtils getPasswordForUsername:@"AccessToken" andServiceName:@"com.xing.iphone-app-2010" error:nil];
    expect(accessToken).to.beNil;

    NSString *tokenSecret = [SFHFKeychainUtils getPasswordForUsername:@"TokenSecret" andServiceName:@"com.xing.iphone-app-2010" error:nil];
    expect(tokenSecret).to.beNil;
}

@end
