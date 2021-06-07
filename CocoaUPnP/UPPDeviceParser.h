// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBaseParser.h"

@class UPPBasicDevice;

/**
 Parser completion block

 @param devices If parsing succeeds, a new `UPPBasicDevice` object is returned
 @param error   If parsing fails, an `NSError` object is returned
 */
typedef void(^CompletionBlock)(NSArray * _Nullable devices, NSError * _Nullable error);

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
- (void)parseURL:(nonnull NSURL *)url withCompletion:(nonnull CompletionBlock)completion;

@end
