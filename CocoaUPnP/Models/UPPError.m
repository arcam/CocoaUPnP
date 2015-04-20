// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPError.h"

NSString * const UPPErrorDomain = @"com.arcam.cocoaupnp.error";

NSError * UPPErrorWithCode(UPPErrorCode code) {
    
    NSString *errorDescription;
    
    switch (code) {
            
        case UPPErrorCodeEmptyData:
            errorDescription = @"No data to parse";
            break;
            
        case UPPErrorCodeNoDeviceElementFound:
            errorDescription = @"No device element found in XML data";
            break;
            
        default:
            code = UPPErrorCodeGeneric;
            errorDescription = @"Unknown error";
            break;
    }

    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorDescription };
    
    return [NSError errorWithDomain:UPPErrorDomain code:code userInfo:userInfo];
}