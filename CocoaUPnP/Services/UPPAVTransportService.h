// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

@class UPPSessionManager;

/**
 This class contains all the network calls needed for the UPnP AVTransport1
 service.
 @see http://upnp.org/specs/av/UPnP-av-AVTransport-v1-Service.pdf
 */
@interface UPPAVTransportService : NSObject

/**
 The session manager instance to perform the network requests with
 */
@property (strong, nonatomic) UPPSessionManager *sessionManager;

/**
 The service's control point URL
 */
@property (copy, nonatomic) NSURL *controlURL;

/**
 Set the current transport URI
 
 @param instanceId         The instance identifier
 @param currentURI         The URI of the media item
 @param currentURIMetaData The meta data for the media item
 @param error              The error returned by the renderer, or nil if call
     was successful
 */
- (void)setAVTransportURIWithInstanceID:(NSString *)instanceId currentURI:(NSString *)currentURI currentURIMetaData:(NSString *)currentURIMetaData error:(NSError * __autoreleasing *)error;

/**
 Set the next transport URI
 
 @param instanceId      The instance identifier
 @param nextURI         The URI for the next media item
 @param nextURIMetaData The meta data for the next media item
 @param error           The error returned by the renderer, or nil if call was
     successful
 */
- (void)setNextAVTransportURIWithInstanceID:(NSString *)instanceId nextURI:(NSString *)nextURI nextURIMetaData:(NSString *)nextURIMetaData error:(NSError * __autoreleasing *)error;

@end
