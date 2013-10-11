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

#import "NSError+XWS.h"
#import "NSDictionary+Typecheck.h"

#define kErrorDomainXWS @"XWSError"
#define kErrorDomainHTTP @"HTTPError"
#define kErrorDomainXWSErrorName @"error_name" // attached in error's userInfo

@implementation NSError (XWS)

#pragma mark - Instance Methods

- (BOOL)isXWSError {
    return [self.domain isEqualToString:kErrorDomainXWS];
}

- (BOOL)isHTTPError {
    return [self.domain isEqualToString:kErrorDomainHTTP];
}

- (NSString *)xwsErrorName {
    return [self.userInfo xng_stringForKey:kErrorDomainXWSErrorName];
}

- (BOOL)xws_accessDenied {
    if (self.isXWSError &&
        [self.xwsErrorName isEqualToString:@"ACCESS_DENIED"]) {
        return YES;
    }
    return NO;
}

- (BOOL)xws_invalidRecipient {
    if (self.isXWSError &&
        [self.xwsErrorName isEqualToString:@"INVALID_RECIPIENT"]) {
        return YES;
    }
    return NO;
}

#pragma mark - Class Methods

+ (NSError *)xwsErrorWithStatusCode:(NSInteger)statusCode
                           userInfo:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:kErrorDomainXWS code:statusCode userInfo:userInfo];
}

+ (NSError *)httpErrorWithStatusCode:(NSInteger)statusCode
                            userInfo:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:kErrorDomainHTTP code:statusCode userInfo:userInfo];
}

@end
