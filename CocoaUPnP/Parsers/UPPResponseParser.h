// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBaseParser.h"

/**
 Parser completion block

 @param response The SOAP response as an `NSDictionary`
 @param error    An optional `NSError` which is returned in the event of parse
                 failure
 */
typedef void(^Response)(NSDictionary * _Nullable response, NSError * _Nullable error);

/**
 This class is responsible for the initial parsing of SOAP responses
 */
@interface UPPResponseParser : UPPBaseParser

/**
 Parse the previously supplied XML data

 @param responseBlock A completion block returning either a `UPPDevice` object
 or an `NSError` object
 */
- (void)parseWithResponse:(nonnull Response)responseBlock;

@end
