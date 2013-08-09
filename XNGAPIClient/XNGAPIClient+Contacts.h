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

#import "XNGAPIClient.h"

@interface XNGAPIClient (Contacts)

typedef enum XNGConctactsOrderOptions {
    XNGContactsOrderOptionByID,
    XNGContactsOrderOptionByLastName
} XNGContactsOrderOptions;

/**
 Returns the requested user's contacts. The nested user data this call returns are the same as the get user details call. You can't request more than 100 contacts at once (see limit parameter), but you can perform several requests in parallel. If you execute this call with limit=0, it will tell you how many contacts the user has without returning any user data....

 https://dev.xing.com/docs/get/users/:user_id/contacts
 */
- (void)getContactsForUserID:(NSString*)userID
                       limit:(NSInteger)limit
                      offset:(NSInteger)offset
                     orderBy:(XNGContactsOrderOptions)orderBy
                  userFields:(NSString *)userFields
                     success:(void (^)(id JSON))success
                     failure:(void (^)(NSError *error))failure;

/**
 Cancel all contacts calls and contact count calls that are currently running/queued.
 */
- (void)cancelGetContactsForUserID:(NSString *)userID;

/**
 This is a customization of the normal contacts call to just get the contact IDs, still batched in up to 100 contacts at once.
 */
- (void)getContactIDsForUserID:(NSString*)userID
                         limit:(NSUInteger)limit
                        offset:(NSUInteger)offset
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error))failure;

/**
 Cancel all contact id calls that are currently running/queued.
 */
- (void)cancelGetContactIDsForUserID:(NSString *)userID;

/**
 Returns the list of contacts who are direct contacts of both the given and the current user. The nested user data this call returns are the same as the get user details call. You can't request more than 100 shared contacts at once (see limit parameter), but you can perform several requests in parallel. If you execute this call with limit=0, it will tell you how many contacts the user has without returning any user data....

 https://dev.xing.com/docs/get/users/:user_id/contacts/shared
 */
- (void)getSharedContactsForUserID:(NSString*)userID
                             limit:(NSInteger)limit
                            offset:(NSInteger)offset
                           orderBy:(XNGContactsOrderOptions)orderBy
                        userFields:(NSString *)userFields
                           success:(void (^)(id JSON))success
                           failure:(void (^)(NSError *error))failure;

/**
 Cancel all shared contacts calls that are currently running/queued.
 */
- (void)cancelGetSharedContactsForUserID:(NSString *)userID;

/**
 Just get the contact count (normal contacts call with limit=0)
 */
- (void)getContactsCountForUserID:(NSString*)userID
                         success:(void (^)(id JSON))success
                         failure:(void (^)(NSError *error))failure;

@end
