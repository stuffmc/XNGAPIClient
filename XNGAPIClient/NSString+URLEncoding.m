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

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)


- (NSString *)xng_URLEncodedString {
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (__bridge CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    return result;
}

- (NSString *)xng_URLDecodedString {
    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (__bridge CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8);
    return result;
}

+ (NSURL *)xng_URLFromURLString:(NSString *)URLString parameters:(NSDictionary *)parameters {
	NSURL *URL = nil;
	if ([parameters count]) {
        NSString *encodedParameters = [NSString xng_URLEncodedStringFromDictionary:parameters];
		URL = [NSURL URLWithString:[URLString stringByAppendingFormat:@"?%@", encodedParameters]];
	} else {
		URL = [NSURL URLWithString:URLString];
	}
	return URL;
}

+ (NSString *)xng_URLEncodedStringFromObject:(id)object {
    NSString *string = object;
    if (![string isKindOfClass:[NSString class]]) {
        string = [NSString stringWithFormat: @"%@", object];
    }
    return [string xng_URLEncodedString];
}

+ (NSString *)xng_URLEncodedStringFromDictionary:(NSDictionary *)dictionary {
    NSMutableArray *parts = [NSMutableArray array];
	for (id key in dictionary) {
		id value = dictionary[key];
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        }
		NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key xng_URLEncodedString],
                          [value xng_URLEncodedString]];
		[parts addObject:part];
	}
	return [parts componentsJoinedByString: @"&"];
}

+ (NSDictionary *)xng_URLDecodedDictionaryFromString:(NSString *)string {
    NSArray *components = [string componentsSeparatedByString:@"&"];
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	for(NSString *comp in components) {
		NSArray *parts = [comp componentsSeparatedByString:@"="];
		if( [parts count] != 2) {
            continue;
        }
        NSString *key = parts[0];
        NSString *value = parts[1];
        [dict setValue:value
                forKey:key];
	}
	return [NSDictionary dictionaryWithDictionary:dict];
}

@end
