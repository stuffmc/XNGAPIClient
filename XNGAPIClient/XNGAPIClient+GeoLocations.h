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

@interface XNGAPIClient (GeoLocations)

/**
 Update a user's geographical location with a given user_id. This user can then be found using the "get nearby users" call.

 https://dev.xing.com/docs/put/users/:user_id/geo_location
 */
- (void)putUpdateGeoLocationForUserID:(NSString*)userID
                             accuracy:(CGFloat)accuracy
                             latitude:(CGFloat)latitude
                            longitude:(CGFloat)longitude
                                  ttl:(NSUInteger)ttl
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *error))failure;

/**
 Get the users that are near your current location....

 https://dev.xing.com/docs/get/users/:user_id/nearby_users
 */
- (void)getNearbyUsersWithAge:(NSUInteger)age
                       radius:(NSUInteger)radius
                   userFields:(NSString *)userFields
                      success:(void (^)(id JSON))success
                      failure:(void (^)(NSError *error))failure;


@end
