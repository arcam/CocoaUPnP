// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPError.h"

NSString * const UPPErrorDomain = @"com.arcam.cocoaupnp.error";

NSError * UPPErrorWithCode(UPPErrorCode code)
{
    NSString *errorDescription;

    switch (code) {

        case UPPErrorCodeEmptyData:
            errorDescription = @"No data to parse";
            break;

        case UPPErrorCodeNoDeviceElementFound:
            errorDescription = @"No device element found in XML data";
            break;

        case UPPErrorCodeNoItemElementsFound:
            errorDescription = @"No item or container elements found in XML data";
            break;

        default:
            code = UPPErrorCodeGeneric;
            errorDescription = @"Unknown error";
            break;
    }

    return UPPErrorWithCodeAndDescription(code, errorDescription);
}

NSError * UPPErrorWithCodeAndDescription(NSInteger code, NSString *description)
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : description };

    return [NSError errorWithDomain:UPPErrorDomain code:code userInfo:userInfo];
}

NSError * UPPErrorWithMethodAndParam(NSString *methodName, NSString *paramName)
{
    NSString *description = [NSString stringWithFormat:@"Error calling %@: missing %@ parameter", methodName, paramName];
    return UPPErrorWithCodeAndDescription(404, description);
}