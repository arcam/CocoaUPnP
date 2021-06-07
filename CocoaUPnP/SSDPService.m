//
//  Copyright (c) 2014 Stephane Boisson
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Expanded for CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
//  Copyright 2015 Arcam. See LICENSE file.

#import "SSDPService.h"


@implementation SSDPService

- (id)initWithHeaders:(NSDictionary *)headers {
    self = [super init];
    if (self) {
        _xmlLocation = [NSURL URLWithString:[headers objectForKey:@"location"]];
        _serviceType = [headers objectForKey:@"st"] ?: [headers objectForKey:@"nt"];
        _uniqueServiceName = [headers objectForKey:@"usn"];
        _server = [headers objectForKey:@"server"];

        NSString *cacheControl = [headers objectForKey:@"cache-control"];
        if (cacheControl) {
            _cacheControlTime = [self scanCacheControlTime:cacheControl];
        }
    }
    return self;
}

- (NSNumber *)scanCacheControlTime:(NSString *)cacheControl
{
    NSScanner *scanner = [NSScanner scannerWithString:cacheControl];
    NSCharacterSet *numbers = [NSCharacterSet decimalDigitCharacterSet];
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];

    NSInteger cacheTime;
    [scanner scanInteger:&cacheTime];

    return @(cacheTime);
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"SSDPService<%@>", self.uniqueServiceName];
}

@end
