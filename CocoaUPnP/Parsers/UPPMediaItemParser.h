// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBaseParser.h"

extern NSString * const UPnPXMLResultsKey;

/**
 This class is solely responsible for parsing an XML string which contains an 
 array of UPnP containers or items.
 */
@interface UPPMediaItemParser : UPPBaseParser

/**
 Parse a dictionary of results obtained from a previous network call.
 
 @param results    The response object returned by the network call.
 @param completion A block which returns a dictionary of parsed XML, or an
 error if the parsing failed.
 */
+ (void)parseResults:(NSDictionary *)results withCompletion:(void (^)(NSDictionary *results, NSError *error))completion;

@end
