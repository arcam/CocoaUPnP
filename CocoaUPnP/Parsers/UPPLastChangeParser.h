// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBaseParser.h"

/**
 This classes sole responsibility is parsing a UPnP last change notification
 event and returning the results to the caller.
 */
@interface UPPLastChangeParser : UPPBaseParser

/**
 Parse a UPnP last change event.

 @param data       XML representation of the XML returned by the service.
 @param completion A block which returns a dictionary of parsed XML, or an
 error if the parsing failed.
 */
+ (void)parseData:(nonnull NSData *)data completion:(nonnull void (^)(NSDictionary * _Nullable event, NSError * _Nullable error))completion;

@end
