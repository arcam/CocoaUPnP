// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicService.h"

/**
 This class contains all the network calls needed for the UPnP [AVTransport1
 service](http://upnp.org/specs/av/UPnP-av-RenderingControl-v1-Service.pdf).
 */
@interface UPPRenderingControlService : UPPBasicService

#pragma mark - Mute Status

///------------------
/// @name Mute Status
///------------------

/**
 Get mute status for Master channel
 
 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
 */
- (void)muteWithInstanceID:(NSString *)instanceId completion:(void(^)(NSDictionary *response, NSError *error))completion;

/**
 Get mute status for a specific channel
 
 @param instanceId The instance identifier
 @param channel    The channel to retrieve mute status for
 @param completion A completion block which returns the parsed response, or an
 */
- (void)muteWithInstanceID:(NSString *)instanceId channel:(NSString *)channel completion:(void(^)(NSDictionary *response, NSError *error))completion;

/**
 Set mute status for Master channel
 
 @param instanceId The instance identifier
 @param mute       Set to `YES` to mute, or `NO` to un-mute
 @param error      The error returned by the renderer, or nil if call was 
     successful
 */
- (void)setMuteWithInstanceID:(NSString *)instanceId mute:(BOOL)mute error:(NSError *__autoreleasing *)error;

/**
 Set mute status for a specific channel
 
 @param instanceId The instance identifier
 @param mute       Set to `YES` to mute, or `NO` to un-mute
 @param channel    The channel to retrieve mute status for
 @param error      The error returned by the renderer, or nil if call was 
     successful
 */
- (void)setMuteWithInstanceID:(NSString *)instanceId channel:(NSString *)channel mute:(BOOL)mute error:(NSError * __autoreleasing *)error;

@end
