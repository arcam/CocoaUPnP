// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBaseParser.h"

/**
 The returned transport state
 */
typedef NS_ENUM(NSInteger, UPPTransportState){
    /**
     Undetermined state
     */
    UPPTransportStateUnknown,
    
    /**
     Stopped state
     */
    UPPTransportStateStopped,
    
    /**
     Transitioning state
     */
    UPPTransportStateTransitioning,
    
    /**
     Playing state
     */
    UPPTransportStatePlaying,
    
    /**
     Paused state
     */
    UPPTransportStatePaused,
    
    /**
     No media present
     */
    UPPTransportStateNoMediaPresent
};

/**
 Last change parser completion block
 
 @param transportState   The current transport state
 @param transportActions Available transport actions
 @param error            Parsing error
 */
typedef void(^UPPLastChangeCompletionBlock)(UPPTransportState transportState, NSString *transportActions, NSError *error);

/**
 This classes sole responsibility is parsing a UPnP last change notification 
 event and returning the results to the caller.
 */
@interface UPPLastChangeParser : UPPBaseParser

/**
 Parse the previously supplied XML data
 
 @param completion A completion block returning the current transport state,
 available transport actions, or an `NSError` object
 */
- (void)parseWithCompletion:(UPPLastChangeCompletionBlock)completion;

@end
