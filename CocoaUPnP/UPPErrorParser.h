// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 This class has a single responsibility: parse a UPnP error XML document into an
 `NSError` object
 */
@interface UPPErrorParser : NSObject

/**
 Parse UPnP error response into an `NSError`

 @param data An `NSData` representation of an error document

 @return Returns an `NSError` with the `<errorCode>` and `<errorDescription>` in
 the localised description.
 */
+ (nonnull NSError *)parseErrorXML:(nonnull NSData *)data;

@end
