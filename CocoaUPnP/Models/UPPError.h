
#import <Foundation/Foundation.h>

/**
 This class defines a helper method to quickly create error objects.
 */
extern NSString * const UPPErrorDomain;

/**
 Error codes
 */
typedef NS_ENUM(NSInteger, UPPErrorCode){
    /**
     Error code when a parser's data object is `nil`
     */
    UPPErrorCodeEmptyData,
    
    /**
     The XML provided does not have a `<device>` tag
     */
    UPPErrorCodeNoDeviceElementFound,
    
    /**
     A network call to a UPnP device returned an error
     */
    UPPErrorCodeUPnPErrorReturned
};

/**
 Create an `NSError` object from a `UPPErrorCode`
 
 @param code The `UPPErrorCode` for the error
 
 @return Returns an `NSError` object
 */
NSError * UPPErrorWithCode(UPPErrorCode code);
