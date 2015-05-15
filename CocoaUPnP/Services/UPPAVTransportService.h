// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicService.h"

/**
 This class contains all the network calls needed for the UPnP [AVTransport1
 service](http://upnp.org/specs/av/UPnP-av-AVTransport-v1-Service.pdf).
 */
@interface UPPAVTransportService : UPPBasicService

#pragma mark - Transport URI Methods

///-----------------------------------------------------------------------------
/// @name Transport URI Methods
///-----------------------------------------------------------------------------

/**
 Set the current transport URI

 @param currentURI         The URI of the media item
 @param currentURIMetaData The meta data for the media item
 @param instanceId         The instance identifier
 @param error              The error returned by the renderer, or nil if call
     was successful
 */
- (void)setAVTransportURI:(NSString *)currentURI currentURIMetaData:(NSString *)currentURIMetaData instanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error;

/**
 Set the next transport URI

 @param nextURI         The URI for the next media item
 @param nextURIMetaData The meta data for the next media item
 @param instanceId      The instance identifier
 @param error           The error returned by the renderer, or nil if call was
     successful
 */
- (void)setNextAVTransportURI:(NSString *)nextURI nextURIMetaData:(NSString *)nextURIMetaData instanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error;


#pragma mark - Getting Information

///-----------------------------------------------------------------------------
/// @name Getting Information
///-----------------------------------------------------------------------------

/**
 Get media information from the service

 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)mediaInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *mediaInfo, NSError *error))completion;

/**
 Get transport information from the service

 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)transportInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *transportInfo, NSError *error))completion;

/**
 Get position information from the service

 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)positionInfoWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *positionInfo,  NSError *error))completion;

/**
 Get device capabilities from the service

 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)deviceCapabilitiesWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *deviceCapabilities, NSError *error))completion;

/**
 Get tranport settings from the service

 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)transportSettingsWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *transportSettings, NSError *error))completion;

/**
 Get tranport actions from the service

 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)transportActionsWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *transportActions, NSError *error))completion;


#pragma mark - General Transport Controls

///-----------------------------------------------------------------------------
/// @name General Transport Controls
///-----------------------------------------------------------------------------

/**
 Send stop command

 @param instanceId The instance identifier
 @param error      The error returned by the renderer, or nil if call was
     successful
 */
- (void)stopWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error;

/**
 Send play command, with speed set to `1`

 @param instanceId The instance identifier
 @param error      The error returned by the renderer, or nil if call was
     successful
 */
- (void)playWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error;

/**
 Send play command with a speed setting

 @param instanceId The instance identifier
 @param speed      Playback speed
 @param error      The error returned by the renderer, or nil if call was
     successful
 */
- (void)playWithInstanceID:(NSString *)instanceId speed:(NSString *)speed error:(NSError * __autoreleasing *)error;

/**
 Send pause command

 @param instanceId The instance identifier
 @param error      The error returned by the renderer, or nil if call was
     successful
 */
- (void)pauseWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error;

/**
 Send record command

 @param instanceId The instance identifier
 @param error      The error returned by the renderer, or nil if call was
     successful
 */
- (void)recordWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error;

/**
 Seek to time

 @param instanceId The instance identifier
 @param unit       The seek mode
 @param target     The time to seek to
 @param error      The error returned by the renderer, or nil if call was
     successful
 */
- (void)setSeekWithInstanceID:(NSString *)instanceId unit:(NSString *)unit target:(NSString *)target error:(NSError * __autoreleasing *)error;

/**
 Send next command

 @param instanceId The instance identifier
 @param error      The error returned by the renderer, or nil if call was
     successful
 */
- (void)nextWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error;

/**
 Send previous command

 @param instanceId The instance identifier
 @param error      The error returned by the renderer, or nil if call was
     successful
 */
- (void)previousWithInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error;


#pragma mark - Mode Setting

///-----------------------------------------------------------------------------
/// @name Mode Setting
///-----------------------------------------------------------------------------

/**
 Set play mode

 @param newPlayMode The new play mode
 @param instanceId  The instance identifier
 @param error       The error returned by the renderer, or nil if call was
     successful
 */
- (void)setPlayMode:(NSString *)newPlayMode withInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error;

/**
 Set record mode

 @param newRecordMode The new record mode
 @param instanceId  The instance identifier
 @param error       The error returned by the renderer, or nil if call was
     successful
 */
- (void)setRecordMode:(NSString *)newRecordMode withInstanceID:(NSString *)instanceId error:(NSError * __autoreleasing *)error;

@end
