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

#import "NSDictionary+Typecheck.h"


@implementation NSDictionary (Typecheck)


- (NSString *)xng_stringForKey:(id)key
{
	id value = self[key];
	if ([value isKindOfClass:[NSString class]])
		return value;
	else
		return nil;
}

- (NSArray *)xng_arrayForKey:(id)key
{
	id value = self[key];
	if ([value isKindOfClass:[NSArray class]])
		return value;
	else
		return nil;
}

- (CGFloat)xng_floatForKey:(id)key
{
	id value = self[key];
	if ([value isKindOfClass:[NSString class]])
		return [value floatValue];
	else if ([value isKindOfClass:[NSNumber class]])
	{
		return [value floatValue];
	}
	else
		return 0.0;
}


- (NSInteger)xng_intForKey:(id)key
{
	id value = self[key];
	if ([value isKindOfClass:[NSString class]])
		return [value intValue];
	else if ([value isKindOfClass:[NSNumber class]])
	{
		return [value intValue];
	}
	else
		return 0;
}

- (BOOL)xng_BOOLForKey:(id)key
{
	id value = self[key];
	if ([value isKindOfClass:[NSNumber class]])
	{
		return [value boolValue];
	} else if ([value isKindOfClass:[NSString class]])
    {
        if ([value isEqualToString:@"true"]) {
            return YES;
        }
    }
    return NO;
}

- (NSNumber *)xng_numberForKey:(id)key {
	id value = self[key];
	if ([value isKindOfClass:[NSNumber class]])
	{
		return value;
	}
    return NO;
}

- (NSMutableArray *)xng_mutableArrayForKey:(id)key
{
	id value = self[key];

	if ([value isKindOfClass:[NSMutableArray class]])
		return value;
	else if ([value isKindOfClass:[NSArray class]])
		return [NSMutableArray arrayWithArray:value];
	else
		return nil;
}

- (NSDictionary *)xng_dictForKey:(id)key
{
	id value = self[key];

	if ([value isKindOfClass:[NSDictionary class]])
		return value;
	else
		return nil;
}


@end
