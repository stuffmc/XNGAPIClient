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

#import "XNGAPIClient+GeoLocations.h"

@implementation XNGAPIClient (GeoLocations)

#pragma mark - public methods

- (void)putUpdateGeoLocationForUserID:(NSString*)userID
                             accuracy:(CGFloat)accuracy
                             latitude:(CGFloat)latitude
                            longitude:(CGFloat)longitude
                                  ttl:(NSUInteger)ttl
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *error))failure {
    // If we set up the parameters NSDictionary and send it in the PUT HTTP body, XWS is unhappy
    // and says: {message=Invalid OAuth signature, error_name=INVALID_OAUTH_SIGNATURE}
    // So either our OAuth signing is incorrect, or XWS is doing something wrong there. There's
    // a ticket already for that: https://jira.xing.hh/jira/browse/XWS-1353
    // This is also the first use case where we have a PUT request together with an HTTP body. On
    // the other hand POST request with an HTTP body just work correctly.
    NSString *format = @"v1/users/%@/geo_location?latitude=%f&longitude=%f&accuracy=%f&ttl=%d";
    NSString *path = [NSString stringWithFormat:format, userID, latitude, longitude, accuracy, ttl];
    [self putJSONPath:path parameters:nil success:success failure:failure];
}

- (void)getNearbyUsersWithAge:(NSUInteger)age
                       radius:(NSUInteger)radius
                   userFields:(NSString *)userFields
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([userFields length]) {
        parameters[@"user_fields"] = userFields;
    }

    if (age) {
        parameters[@"age"] = @(age);
    }

    if (radius) {
        parameters[@"radius"] = @(radius);
    }

    NSString *path = @"v1/users/me/nearby_users";

    [self getJSONPath:path parameters:parameters success:success failure:failure];
}

@end
