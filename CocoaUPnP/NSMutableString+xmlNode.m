// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "NSMutableString+xmlNode.h"

static NSString * XMLSafeString (NSString *s) {
    if (!s) { return nil; }
    // The following line is a workaround for a crash I've seen in the field.
    // This should not be needed, as when a media item is parsed, it sets track
    // number as a string. Setting value to an `NSNumber` in your code will
    // raise a compiler warning, but there's no harm in this line for protecting
    // against runtime crashes.
    if ([s isKindOfClass:[NSNumber class]]) { return [(NSNumber *)s stringValue]; }
    s = [s stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;amp;"];
    s = [s stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    s = [s stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    s = [s stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];

    return s;
}

@implementation NSMutableString (xmlNode)

- (void)upp_appendValue:(NSString *)value forKey:(NSString *)key
{
    if (!value || !key) { return; }

    NSString *safeString = XMLSafeString(value);
    if (!safeString) { return; }
    [self appendFormat:@"&lt;%@&gt;%@&lt;/%@&gt;", key, safeString, key];
}

- (void)upp_appendValue:(NSString *)value forAttribute:(NSString *)attribute
{
    if (!value || !attribute) { return; }
    NSString *safeString = XMLSafeString(value);
    if (!safeString) { return; }
    [self appendFormat:@" %@=\"%@\"", attribute, safeString];
}

@end
