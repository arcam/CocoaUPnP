// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPErrorParser.h"
#import "UPPError.h"
#import "Ono.h"

@implementation UPPErrorParser

+ (NSError *)parseErrorXML:(NSData *)data
{
    NSParameterAssert(data);
    if (!data) { return nil; }

    NSError *error;
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:data
                                                             error:&error];

    if (!document) {
        return error;
    }

    ONOXMLElement *element = [document firstChildWithXPath:@"//*[name()='UPnPError']"];
    NSString *errorCode = [[element firstChildWithTag:@"errorCode"] stringValue];
    NSString *errorDescription = [[element firstChildWithTag:@"errorDescription"] stringValue];
    NSString *description = [NSString stringWithFormat:@"%@ - %@", errorCode, errorDescription];

    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : description };
    error = [[NSError alloc] initWithDomain:UPPErrorDomain
                                       code:UPPErrorCodeUPnPErrorReturned
                                   userInfo:userInfo];
    return error;
}

@end
