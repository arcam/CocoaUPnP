// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "NSMutableString+xmlNode.h"

static NSString * XMLSafeString (NSString *s) {
    if (!s) { return nil; }
    s = [s stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;amp;"];
    s = [s stringByReplacingOccurrencesOfString:@"<" withString:@"&amp;lt;"];
    s = [s stringByReplacingOccurrencesOfString:@">" withString:@"&amp;gt;"];
    s = [s stringByReplacingOccurrencesOfString:@"'" withString:@"&amp;apos;"];
    s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@"&amp;quot;"];
    
    return s;
}

@implementation NSMutableString (xmlNode)

- (void)upp_appendValue:(NSString *)value forKey:(NSString *)key
{
    if (!value || !key) { return; }
    [self appendFormat:@"&lt;%@&gt;%@&lt;/%@&gt;", key, XMLSafeString(value), key];
}

- (void)upp_appendValue:(NSString *)value forAttribute:(NSString *)attribute
{
    if (!value || !attribute) { return; }
    [self appendFormat:@" %@=\"%@\"", attribute, XMLSafeString(value)];
}

@end
