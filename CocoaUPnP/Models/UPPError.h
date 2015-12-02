// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 This class defines a helper method to quickly create error objects.
 */
extern NSString * const UPPErrorDomain;

/**
 Error codes
 */
typedef NS_ENUM(NSInteger, UPPErrorCode) {
    /**
     A generic error code
     */
    UPPErrorCodeGeneric,

    /**
     A network call to a UPnP device returned an error
     */
    UPPErrorCodeUPnPErrorReturned,

    /**
     Error code when a parser's data object is `nil`
     */
    UPPErrorCodeEmptyData,

    /**
     The XML provided does not have a `<device>` tag
     */
    UPPErrorCodeNoDeviceElementFound,

    /**
     The XML provided contains no `<item>` or `<container>` tags
     */
    UPPErrorCodeNoItemElementsFound
};

/**
 Create an `NSError` object from a `UPPErrorCode`

 @param code The `UPPErrorCode` for the error

 @return Returns an `NSError` object
 */
NSError * UPPErrorWithCode(UPPErrorCode code);

/**
 Create a generic `NSError` object from a code and description

 @param code        The error code
 @param description The error localised description

 @return A new `NSError` object with code and description populated
 */
NSError * UPPErrorWithCodeAndDescription(NSInteger code, NSString *description);

/**
 Create an `NSError` object to inform developers of a missing parameter from a
 network call.
*/
NSError * UPPErrorWithMethodAndParam(NSString *methodName, NSString *paramName);