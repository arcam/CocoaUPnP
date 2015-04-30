// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBaseParser.h"

@class UPPBasicDevice;

/**
 Parser completion block
 
 @param device If parsing succeeds, a new `UPPBasicDevice` object is returned
 
 @param error  If parsing fails, an `NSError` object is returned
 */
typedef void(^CompletionBlock)(UPPBasicDevice *device, NSError *error);

/**
 This class defines an object whose sole responsibility is to parse a device
 description XML document into a `UPPDevice` object. @see UPPDevice
 */
@interface UPPDeviceParser : UPPBaseParser

+ (void)parseURL:(NSURL *)url withCompletion:(CompletionBlock)completion;

/**
 Parse the previously supplied XML data
 
 @param completion A completion block returning either a `UPPDevice` object
 or an `NSError` object
 */
- (void)parseWithCompletion:(CompletionBlock)completion;

@end
