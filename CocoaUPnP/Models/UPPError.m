
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
            errorDescription = @"Unknown error";
            break;
    }

    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : errorDescription };
    
    return [[NSError alloc] initWithDomain:UPPErrorDomain
                                      code:code
                                  userInfo:userInfo];
}