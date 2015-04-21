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
 The name space of the control point
 */
@property (copy, nonatomic) NSString *nameSpace;

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

/**
 Get media information from the service
 
 @discussion This method does not return values for PlayMedium, RecordMedium or
     WriteStatus.
 
 @param instanceId The instance identifier
 @param completion A completion block with the returned data
 */
- (void)mediaInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSNumber *numberOfTracks, NSString *duration, NSString *currentURI, NSString *currentURIMetaData, NSString *nextURI, NSString *nextURIMetaData))completion;

- (void)transportInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSString *currentTransportState, NSString *currentTransportStatus, NSString *currentSpeed))completion;

- (void)positionInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSString *track, NSString *trackDuration, NSString *trackMetaData, NSString *trackURI, NSString *relTime, NSString *absTime, NSString *relCount, NSString *absCount))completion;

- (void)deviceCapabilitiesWithInstanceID:(NSString *)instanceId completion:(void(^)(NSString *playMedia, NSString *recMedia, NSString *recQualityModes))completion;

@end
