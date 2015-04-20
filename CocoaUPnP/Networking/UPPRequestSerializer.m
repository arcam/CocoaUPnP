// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPRequestSerializer.h"

@implementation UPPRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]
                                           initWithURL:request.URL];
    
    NSMutableString *body = [NSMutableString string];
    
    NSString *bodyText =
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    @"<s:Envelope s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\""
    @" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
    @"<s:Body>";
    [body appendString:bodyText];
    [body appendFormat:@"<u:%@ xmlns:u=\"%@\">", _soapAction, _nameSpace];
    [body appendString:[self upp_stringForParameters:parameters]];
    [body appendFormat:@"</u:%@>", _soapAction];
    [body appendString:@"</s:Body></s:Envelope>"];
    
    [mutableRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *action = [NSString stringWithFormat:@"\"%@#%@\"", _nameSpace, _soapAction];
    [mutableRequest setValue:action forHTTPHeaderField:@"SOAPACTION"];
    
    NSString *length = [NSString stringWithFormat:@"%@", @(body.length)];
    [mutableRequest setValue:length forHTTPHeaderField:@"Content-Length"];
    
    [mutableRequest setValue:@"text/xml; charset=\"utf-8\""
          forHTTPHeaderField:@"Content-Type"];
    
    return [mutableRequest copy];
}

- (NSString *)upp_stringForParameters:(NSDictionary *)parameters
{
    NSArray *keys;
    
    // NSDictionary is not guaranteed to return keys in order, so we need to sort
    // them for running the unit tests.
    if (NSClassFromString(@"XCTest") != nil) {
        keys = [[parameters allKeys]
                sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    // ... But in production, sorting doesn't matter so just pull them in as is.
    else {
        keys = [parameters allKeys];
    }
    
    NSMutableString *string = [NSMutableString string];
    
    for (id key in keys) {
        [string appendFormat:@"<%@>%@</%@>", key, parameters[key], key];
    }
    
    return [string copy];
}

@end
