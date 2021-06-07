// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBaseParser.h"

@class ONOXMLDocument;

extern NSString * _Nonnull const UPnPXMLResultsKey;

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
+ (void)parseResults:(nonnull NSDictionary *)results withCompletion:(nonnull void (^)(NSDictionary * _Nullable results, NSError * _Nullable error))completion;

/**
 Parse items from an XML description.

 @param document The XML document to be parsed.

 @return An array of media items.
 */
+ (nonnull NSArray *)parseItemsInDocument:(nonnull ONOXMLDocument *)document;

@end
