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

#import "XNGAPIClient+Contacts.h"

@implementation XNGAPIClient (Contacts)

#pragma mark - public methods

- (void)getContactsForUserID:(NSString*)userID
                       limit:(NSInteger)limit
                      offset:(NSInteger)offset
                     orderBy:(XNGContactsOrderOptions)orderBy
                  userFields:(NSString *)userFields
                     success:(void (^)(id JSON))success
                     failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    if (limit) {
        parameters[@"limit"] = @(limit);
    }

    if (offset) {
        parameters[@"offset"] = @(offset);
    }

    if (orderBy == XNGContactsOrderOptionByLastName) {
        parameters[@"order_by"] = @"last_name";
    }

    if ([userFields length]) {
        parameters[@"user_fields"] = userFields;
    }

    NSString* path = [self pathForGetContactsWithUserID:userID];
    [self getJSONPath:path
           parameters:parameters
              success:success
              failure:failure];
}

- (void)cancelGetContactsForUserID:(NSString *)userID {
    NSString* path = [self pathForGetContactsWithUserID:userID];
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}

- (void)getContactIDsForUserID:(NSString*)userID
                         limit:(NSUInteger)limit
                        offset:(NSUInteger)offset
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }

    NSString* path = [self pathForGetContactsWithUserID:userID];
    [self getJSONPath:path
           parameters:parameters
              success:success
              failure:failure];
}

- (void)cancelGetContactIDsForUserID:(NSString *)userID {
    NSString* path = [self pathForGetContactsWithUserID:userID];
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}

- (void)getSharedContactsForUserID:(NSString*)userID
                             limit:(NSInteger)limit
                            offset:(NSInteger)offset
                           orderBy:(XNGContactsOrderOptions)orderBy
                        userFields:(NSString *)userFields
                           success:(void (^)(id JSON))success
                           failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    if (limit) {
        parameters[@"limit"] = @(limit);
    }

    if (offset) {
        parameters[@"offset"] = @(offset);
    }

    if (orderBy == XNGContactsOrderOptionByLastName) {
        parameters[@"order_by"] = @"last_name";
    }

    if ([userFields length]) {
        parameters[@"user_fields"] = userFields;
    }

    NSString* path = [self pathForGetSharedContactsWithUserID:userID];
    [self getJSONPath:path
           parameters:parameters
              success:success
              failure:failure];
}

- (void)cancelGetSharedContactsForUserID:(NSString *)userID {
    NSString* path = [self pathForGetSharedContactsWithUserID:userID];
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}

- (void)getContactsCountForUserID:(NSString*)userID
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *error))failure {
    NSParameterAssert(userID);

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"limit"] = @0;

    NSString *path = [self pathForGetContactsWithUserID:userID];

    [self getJSONPath:path
           parameters:parameters
              success:success
              failure:failure];
}

#pragma mark - private methods

- (NSString*)pathForGetContactsWithUserID:(NSString*)userID {
    return [NSString stringWithFormat:@"v1/users/%@/contacts", userID];
}

- (NSString*)pathForGetSharedContactsWithUserID:(NSString*)userID {
    return [NSString stringWithFormat:@"v1/users/%@/contacts/shared", userID];
}
@end
