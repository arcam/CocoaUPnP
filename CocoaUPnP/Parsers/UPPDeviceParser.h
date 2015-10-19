// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBaseParser.h"

@class UPPBasicDevice;

/**
 Parser completion block

 @param device If parsing succeeds, a new `UPPBasicDevice` object is returned

 @param error  If parsing fails, an `NSError` object is returned
 */
typedef void(^CompletionBlock)(NSArray *devices, NSError *error);

/**
 This class defines an object whose sole responsibility is to parse a device
 description XML document into a `UPPDevice` object. @see UPPDevice
 */
@interface UPPDeviceParser : UPPBaseParser

/**
 Download and parse a device's XML description

 @param url        The URL for the XML description file
 @param completion A completion block returning either a `UPPDevice` object
 or an `NSError` object
 */
+ (void)parseURL:(NSURL *)url withCompletion:(CompletionBlock)completion;

@end
