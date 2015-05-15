// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicService.h"

/**
 This class contains all the network calls needed for the UPnP [AVTransport1
 service](http://upnp.org/specs/av/UPnP-av-RenderingControl-v1-Service.pdf).
 */
@interface UPPRenderingControlService : UPPBasicService

#pragma mark - Mute Status

///-----------------------------------------------------------------------------
/// @name Mute Status
///-----------------------------------------------------------------------------

/**
 Get mute status for a specific channel

 @param instanceId The instance identifier
 @param channel    The channel to retrieve mute status for. Defaults to `Master`.
 @param completion A completion block which returns the parsed response, or an
 */
- (void)muteWithInstanceID:(NSString *)instanceId channel:(NSString *)channel completion:(void(^)(NSDictionary *response, NSError *error))completion;

/**
 Set mute status for a specific channel

 @param mute       Set to `YES` to mute, or `NO` to un-mute
 @param instanceId The instance identifier
 @param channel    The channel to retrieve mute status for. Defaults to `Master`.
 @param error      The error returned by the renderer, or nil if call was
     successful
 */
- (void)setMute:(BOOL)mute withInstanceID:(NSString *)instanceId channel:(NSString *)channel error:(NSError * __autoreleasing *)error;


#pragma mark - Volume

///-----------------------------------------------------------------------------
/// @name Volume
///-----------------------------------------------------------------------------

/**
 Get volume for a specific channel

 @param instanceId The instance identifier
 @param channel    The channel to retrieve volume status for. Defaults to
     `Master`.
 @param completion A completion block which returns the parsed response, or an
 */
- (void)volumeWithInstanceID:(NSString *)instanceId channel:(NSString *)channel completion:(void(^)(NSDictionary *response, NSError *error))completion;

/**
 Set volume for a specific channel

 @param volume     The volume value to send
 @param instanceId The instance identifier
 @param channel    The channel to retrieve volume status for. Defaults to
     `Master`.
 @param error      The error returned by the renderer, or nil if call was
     successful
 */
- (void)setVolume:(NSNumber *)volume withInstanceID:(NSString *)instanceId channel:(NSString *)channel error:(NSError *__autoreleasing *)error;

@end
