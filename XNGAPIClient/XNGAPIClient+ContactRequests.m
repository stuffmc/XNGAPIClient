//
// Copyright (c) 2013 XING AG (http://xing.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XNGAPIClient+ContactRequests.h"

@implementation XNGAPIClient (ContactRequests)

#pragma mark - public methods

- (void)getContactRequestsWithLimit:(NSInteger)limit
                             offset:(NSInteger)offset
                         userFields:(NSString *)userField
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if ([userField length]) {
        parameters[@"user_fields"] = userField;
    }

    NSString *path = @"v1/users/me/contact_requests";
    [self getJSONPath:path
           parameters:parameters
              success:success
              failure:failure];
}

- (void)postCreateContactRequestToUserWithID:(NSString*)userID
                                     message:(NSString*)message
                                     success:(void (^)(id JSON))success
                                     failure:(void (^)(NSError *error))failure {
    NSParameterAssert(userID);

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([message length]) {
        parameters[@"message"] = message;
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/%@/contact_requests", userID];
    [self postJSONPath:path
            parameters:parameters
               success:success
               failure:failure];
}

- (void)putConfirmContactRequestForUserID:(NSString*)userID
                                 senderID:(NSString*)senderID
                                  success:(void (^)(id JSON))success
                                  failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"v1/users/%@/contact_requests/%@/accept", userID, senderID];
    [self putJSONPath:path
           parameters:nil
              success:success
              failure:failure];
}

- (void)deleteDeclineContactRequestForUserID:(NSString*)userID
                                    senderID:(NSString*)senderID
                                     success:(void (^)(id JSON))success
                                     failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"v1/users/%@/contact_requests/%@", userID, senderID];
    [self deleteJSONPath:path
              parameters:nil
                 success:success
                 failure:failure];
}

@end
