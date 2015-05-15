// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 A category simplifying added percent encoded XML text to a mutable string.
 */
@interface NSMutableString (xmlNode)

/**
 Appends a percent encoded XML node to self. For example:
 `[mString upp_appendValue:@"bar" forKey:@"foo"];` appends
 `&lt;foo&gt;bar&lt;/foo&gt;`

 @param value The value to append.
 @param key   The key to append.
 */
- (void)upp_appendValue:(NSString *)value forKey:(NSString *)key;

/**
 Appends a percent encoded XML attribute to self. For example;

 @param value     The XML value.
 @param attribute The XML attribute title.
 */
- (void)upp_appendValue:(NSString *)value forAttribute:(NSString *)attribute;

@end
