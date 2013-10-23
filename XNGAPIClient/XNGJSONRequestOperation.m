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

#import "XNGJSONRequestOperation.h"

@implementation XNGJSONRequestOperation

@synthesize responseJSON = _responseJSON;

+ (void)initialize {
    [super initialize];
    [self addAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
}

- (id)responseJSON {
    if ([self.responseData length] > 60) {
        return [super responseJSON];
    }
    NSString *json = self.responseString;
    if (([@"The profile visit was created successfully." isEqualToString:json]) ||
        ([@"Status update has been posted" isEqualToString:json]) ||
        ([@"The comment was created successfully" isEqualToString:json]) ||
        ([@"Contact request was successfully sent" isEqualToString:json]) ||
        ([@"The token was successfully registered" isEqualToString:json])) {
        return nil;
    }
    return [super responseJSON];
}

@end
