// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2016 Arcam. See LICENSE file.

#import <Ono/Ono.h>

@interface ONOXMLElement (StringValueOrNil)
- (NSString *)stringValueOrNil;
- (NSString *)stringForAttributeOrNil:(NSString *)attribute;
@end
