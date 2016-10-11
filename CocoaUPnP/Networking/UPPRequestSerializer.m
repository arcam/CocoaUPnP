// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPRequestSerializer.h"
#import "UPPConstants.h"
#import "UPPParameters.h"

@implementation UPPRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing *)error
{
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]
                                           initWithURL:request.URL];
    mutableRequest.HTTPMethod = request.HTTPMethod;

    NSString *soapAction = parameters[UPPSOAPActionKey];
    NSString *nameSpace = parameters[UPPNameSpaceKey];

    NSMutableString *body = [NSMutableString string];

    NSString *bodyText =
    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    @"<s:Envelope s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\""
    @" xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
    @"<s:Body>";
    [body appendString:bodyText];
    [body appendFormat:@"<u:%@ xmlns:u=\"%@\">", soapAction, nameSpace];
    [body appendString:[self upp_stringForParameters:parameters[UPPParametersKey]]];
    [body appendFormat:@"</u:%@>", soapAction];
    [body appendString:@"</s:Body></s:Envelope>"];

    [mutableRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *action = [NSString stringWithFormat:@"\"%@#%@\"", nameSpace, soapAction];
    [mutableRequest setValue:action forHTTPHeaderField:@"SOAPACTION"];

    NSString *length = [NSString stringWithFormat:@"%@", @(body.length)];
    [mutableRequest setValue:length forHTTPHeaderField:@"Content-Length"];

    [mutableRequest setValue:@"text/xml; charset=\"utf-8\""
          forHTTPHeaderField:@"Content-Type"];

    return [mutableRequest copy];
}

- (NSString *)upp_stringForParameters:(UPPParameters *)parameters
{
    NSMutableString *string = [NSMutableString string];

    [parameters enumerateKeysAndValuesUsingBlock:^(id key, id value, NSUInteger idx, BOOL *stop) {
        if ([value isKindOfClass:[NSString class]]) {
            NSString *v = value;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"&(?!(lt|gt|apos|quot))(amp;)?" options:NSRegularExpressionCaseInsensitive error:nil];
            v = [regex stringByReplacingMatchesInString:v options:0 range:NSMakeRange(0, [v length]) withTemplate:@"&amp;"];
            v = [v stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
            v = [v stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
            v = [v stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
            v = [v stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
            [string appendFormat:@"<%@>%@</%@>", key, v, key];
        }
        else {
            [string appendFormat:@"<%@>%@</%@>", key, value, key];
        }
    }];

    return [string copy];
}

@end
