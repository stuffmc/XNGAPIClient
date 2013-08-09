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

@interface XNGAPIClient (ContactRequests)

/**
 Lists all pending incoming contact requests the specified user has received from other users.

 https://dev.xing.com/docs/get/users/:user_id/contact_requests
 */
- (void)getContactRequestsWithLimit:(NSInteger)limit
                             offset:(NSInteger)offset
                         userFields:(NSString *)userField
                            success:(void (^)(id JSON))success
                            failure:(void (^)(NSError *error))failure;

/**
 Initiates a contact request between the current user (sender) and the specified user (recipient).

 https://dev.xing.com/docs/post/users/:user_id/contact_requests
 */
- (void)postCreateContactRequestToUserWithID:(NSString*)userID
                                     message:(NSString*)message
                                     success:(void (^)(id JSON))success
                                     failure:(void (^)(NSError *error))failure;

/**
 Accepts an incoming contact request.

 https://dev.xing.com/docs/put/users/:user_id/contact_requests/:id/accept
 */
- (void)putConfirmContactRequestForUserID:(NSString*)userID
                                 senderID:(NSString*)senderID
                                  success:(void (^)(id JSON))success
                                  failure:(void (^)(NSError *error))failure;

/**
 Denies an incoming contact request or revokes an initiated contact request.

 https://dev.xing.com/docs/delete/users/:user_id/contact_requests/:id
 */
- (void)deleteDeclineContactRequestForUserID:(NSString*)userID
                                    senderID:(NSString*)senderID
                                     success:(void (^)(id JSON))success
                                     failure:(void (^)(NSError *error))failure;

@end
