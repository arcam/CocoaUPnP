// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBaseParser.h"

/**
 Media item parser completion block
 
 @param items           An array of `UPPMediaItem` objects
 @param resultsReturned Number of results returned in the XML
 @param totalResults    Total number of results
 @param updateID        Content directory update ID
 @param error           An `NSError` is returned in the event of parse failure
 */
typedef void(^UPPMediaItemCompletionBlock)(NSArray *items, NSNumber *resultsReturned, NSNumber *totalResults, NSNumber *updateID, NSError *error);

@interface UPPMediaItemParser : UPPBaseParser

/**
 Parse the previously supplied XML data
 
 @param completion A completion block returning either an array of
 `UPPMediaItem` objects, with some additional extra information, or an 
 `NSError` object
 */
- (void)parseWithCompletion:(UPPMediaItemCompletionBlock)completion;

@end
