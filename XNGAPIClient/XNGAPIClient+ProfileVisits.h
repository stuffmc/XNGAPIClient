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

@interface XNGAPIClient (ProfileVisits)

/**
 Returns a list of users who recently visited the specified user's profile. Entries with a value of null in the user_id attribute indicate anonymous (non-XING) users (e.g. resulting from Google searches)....

 https://dev.xing.com/docs/get/users/:user_id/visits
 */
- (void)getVisitsWithLimit:(NSInteger)limit
                    offset:(NSInteger)offset
                     since:(NSString *)since
                 stripHTML:(BOOL)stripHTML
                   success:(void (^)(id JSON))success
                   failure:(void (^)(NSError *error))failure;

/**
 Cancel all get visits operation that are currently running/queued.
 */
- (void)cancelAllGetVisitsOperations;

/**
 Creates a profile visit. The visiting user will be derived from the user executing the call, and the visit reason derived from the consumer.

 https://dev.xing.com/docs/post/users/:user_id/visits
 */
- (void)postReportProfileVisitForUserID:(NSString *)userID
                                success:(void (^)(id JSON))success
                                failure:(void (^)(NSError *error))failure;

@end
