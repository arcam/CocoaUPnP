// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2016 Arcam. See LICENSE file.

#import "ONOXMLDocument+StringValueOrNil.h"

@implementation ONOXMLElement (StringValueOrNil)
- (NSString *)stringValueOrNil {
    NSString *stringValue = [self stringValue];
    if ([stringValue isEqualToString:@""]) { return nil; }
    return stringValue;
}

- (NSString *)stringForAttributeOrNil:(NSString *)attribute {
    id value = [self valueForAttribute:attribute];
    if (!value) { return nil; }
    return [NSString stringWithFormat:@"%@", value];
}
@end
