// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPResponseSerializer.h"
#import "UPPResponseParser.h"
#import "UPPErrorParser.h"

@implementation UPPResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    if ([(NSHTTPURLResponse *)response statusCode] > 200) {
        *error = [UPPErrorParser parseErrorXML:data];
        return nil;
    }

    __block NSDictionary *resp;
    UPPResponseParser *parser = [[UPPResponseParser alloc] initWithXMLData:data];
    [parser parseWithResponse:^(NSDictionary *response, NSError *error) {
        resp = response;
    }];

    return resp;
}

@end
