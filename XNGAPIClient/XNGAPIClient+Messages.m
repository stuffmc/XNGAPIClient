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

#import "XNGAPIClient+Messages.h"
#import "NSDictionary+Typecheck.h"

@implementation XNGAPIClient (Messages)

#pragma mark - public methods

- (void)getConversationsWithLimit:(NSInteger)limit
                           offset:(NSInteger)offset
                       userFields:(NSString *)userFields
               withLatestMessages:(NSInteger)latestMessagesCount
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) {
        parameters[@"limit"] = @(limit);
    }
    if (offset) {
        parameters[@"offset"] = @(offset);
    }
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (latestMessagesCount) {
        parameters[@"with_latest_messages"] = @(latestMessagesCount);
    }
    NSString *path = @"v1/users/me/conversations";
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)cancelAllConversationsHTTPOperations {
    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations"];
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}


- (void)postCreateNewConversationWithRecipientIDs:(NSString*)recipientIDs
                                          subject:(NSString*)subject
                                          content:(NSString*)content
                                          success:(void (^)(id JSON))success
                                          failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"recipient_ids"] = recipientIDs;
    parameters[@"subject"] = subject;
    parameters[@"content"] = content;

    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations"];
    [self postJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)getIsRecipientValidWithUserID:(NSString*)userID
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations/valid_recipients/%@", userID];
    [self getJSONPath:path parameters:nil success:success failure:failure];
}

- (void)getConversationWithID:(NSString *)conversationID
                   userFields:(NSString *)userFields
           withLatestMessages:(NSInteger)latestMessagesCount
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userFields) {
        parameters[@"user_fields"] = userFields;
    }
    if (latestMessagesCount) {
        parameters[@"with_latest_messages"] = @(latestMessagesCount);
    }
    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations/%@", conversationID];

    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)postDownloadURLForAttachmentID:(NSString*)attachmentID
                        conversationID:(NSString*)conversationID
                               success:(void (^)(NSURL *downloadURL))success
                               failure:(void (^)(NSError *error))failure {
    if (attachmentID == nil || conversationID == nil) {
        return;
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations/%@/attachments/%@/download", conversationID, attachmentID];
    [self postJSONPath:path parameters:nil success:^(id JSON) {
        NSURL *downloadURL = nil;
        if ([JSON isKindOfClass:NSDictionary.class]) {
            NSDictionary *downloadURLDictionary = [JSON xng_dictForKey:@"download"];
            NSString *downloadURLString = [downloadURLDictionary xng_stringForKey:@"url"];
            if (downloadURLString) {
                downloadURL = [NSURL URLWithString:downloadURLString];
                success(downloadURL);
            }
        }
    } failure:failure];
}

- (void)putMarkConversationAsReadWithConversationID:(NSString*)conversationID
                                            success:(void (^)(id JSON))success
                                            failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations/%@/read", conversationID];
    [self putJSONPath:path parameters:nil success:success failure:failure];
}

- (void)getMessagesForConversationID:(NSString*)conversationID
                               limit:(NSInteger)limit
                              offset:(NSInteger)offset
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
    if ([userFields length]) {
        parameters[@"user_fields"] = userFields;
    }

    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations/%@/messages", conversationID];
    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)cancelAllMessagesHTTPOperationsForConversationID:(NSString *)conversationID {
    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations/%@",conversationID];
    [self cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}

- (void)putMarkMessageAsReadWithMessageID:(NSString*)messageID
                           conversationID:(NSString*)conversationID
                                  success:(void (^)(id JSON))success
                                  failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations/%@/messages/%@/read", conversationID, messageID];
    [self putJSONPath:path parameters:nil success:success failure:failure];
}

- (void)deleteMarkMessageAsUnreadWithMessageID:(NSString*)messageID
                                conversationID:(NSString*)conversationID
                                       success:(void (^)(id JSON))success
                                       failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations/%@/messages/%@/read", conversationID, messageID];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

- (void)postCreateReplyToConversationWithConversationID:(NSString*)conversationID
                                                content:(NSString*)content
                                                success:(void (^)(id JSON))success
                                                failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"content"] = content;

    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations/%@/messages", conversationID];
    [self postJSONPath:path parameters:parameters success:success failure:failure];
}

- (void)deleteConversationWithConversationID:(NSString*)conversationID
                                     success:(void (^)(id JSON))success
                                     failure:(void (^)(NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"v1/users/me/conversations/%@", conversationID];
    [self deleteJSONPath:path parameters:nil success:success failure:failure];
}

@end
