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

@interface XNGAPIClient (Messages)

/**
 Returns the list of conversations for the given user....

 https://dev.xing.com/docs/get/users/:user_id/conversations
 */
- (void)getConversationsWithLimit:(NSInteger)limit
                           offset:(NSInteger)offset
                       userFields:(NSString *)userFields
               withLatestMessages:(NSInteger)latestMessagesCount
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *error))failure;

/**
 Cancel all GET-conversations-calls that are currently running/queued.
 */
- (void)cancelAllConversationsHTTPOperations;

/**
 Starts a conversation by sending the passed message to the recipients. The subject of a conversation cannot be changed afterwards. Basic members are not allowed to send messages to non-contacts. Premium members are limited to 20 messages to non-contacts per month....

 https://dev.xing.com/docs/post/users/:user_id/conversations
 */
- (void)postCreateNewConversationWithRecipientIDs:(NSString*)recipientIDs
                                          subject:(NSString*)subject
                                          content:(NSString*)content
                                          success:(void (^)(id JSON))success
                                          failure:(void (^)(NSError *error))failure;

/**
 Check if it's possible to send a message to the selected recipient.

 https://dev.xing.com/docs/get/users/me/conversations/valid_recipients/:id
 */
- (void)getIsRecipientValidWithUserID:(NSString*)userID
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *error))failure;

/**
 Returns a single conversation. This call returns the same conversations format as the "List conversations" call.

 https://dev.xing.com/docs/get/users/:user_id/conversations/:id
 */
- (void)getConversationWithID:(NSString *)conversationID
                   userFields:(NSString *)userFields
           withLatestMessages:(NSInteger)latestMessagesCount
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error))failure;

/**
 The URL will be returned via response body and is valid for 300 seconds.

 https://dev.xing.com/docs/post/users/me/conversations/:conversation_id/attachments/:id/download
 */
- (void)postDownloadURLForAttachmentID:(NSString*)attachmentID
                        conversationID:(NSString*)conversationID
                               success:(void (^)(NSURL *downloadURL))success
                               failure:(void (^)(NSError *error))failure;

/**
 Marks all messages in the conversation as read.

 https://dev.xing.com/docs/put/users/:user_id/conversations/:id/read
 */
- (void)putMarkConversationAsReadWithConversationID:(NSString*)conversationID
                                            success:(void (^)(id JSON))success
                                            failure:(void (^)(NSError *error))failure;

/**
 Returns the messages for a conversation.

 https://dev.xing.com/docs/get/users/:user_id/conversations/:conversation_id/messages
 */
- (void)getMessagesForConversationID:(NSString*)conversationID
                               limit:(NSInteger)limit
                              offset:(NSInteger)offset
                          userFields:(NSString *)userFields
                             success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *error))failure;

/**
 Cancel all GET-messages-calls that are currently running/queued.
 */
- (void)cancelAllMessagesHTTPOperationsForConversationID:(NSString *)conversationID;

/**
 Marks a message in a conversation as read.

 https://dev.xing.com/docs/put/users/:user_id/conversations/:conversation_id/messages/:id/read
 */
- (void)putMarkMessageAsReadWithMessageID:(NSString*)messageID
                           conversationID:(NSString*)conversationID
                                  success:(void (^)(id JSON))success
                                  failure:(void (^)(NSError *error))failure;

/**
 Marks a message in a conversation as unread.

 https://dev.xing.com/docs/delete/users/:user_id/conversations/:conversation_id/messages/:id/read
 */
- (void)deleteMarkMessageAsUnreadWithMessageID:(NSString*)messageID
                                conversationID:(NSString*)conversationID
                                       success:(void (^)(id JSON))success
                                       failure:(void (^)(NSError *error))failure;

/**
 Creates a new message in an existing conversation....

 https://dev.xing.com/docs/post/users/:user_id/conversations/:conversation_id/messages
 */
- (void)postCreateReplyToConversationWithConversationID:(NSString*)conversationID
                                                content:(NSString*)content
                                                success:(void (^)(id JSON))success
                                                failure:(void (^)(NSError *error))failure;

/**
 Delete a conversation.

 https://dev.xing.com/docs/delete/users/:user_id/conversations/:id
 */
- (void)deleteConversationWithConversationID:(NSString*)conversationID
                                     success:(void (^)(id JSON))success
                                     failure:(void (^)(NSError *error))failure;

@end
