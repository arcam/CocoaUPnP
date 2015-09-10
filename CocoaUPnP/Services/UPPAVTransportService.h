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
 @param success            An optional block which returns the success state of
 the call, along with an error object if the call was unsuccessful.

 */
- (void)setAVTransportURI:(NSString *)currentURI currentURIMetaData:(NSString *)currentURIMetaData instanceID:(NSString *)instanceId success:(UPPSuccessBlock)successBlock;

/**
 Set the next transport URI

 @param nextURI         The URI for the next media item
 @param nextURIMetaData The meta data for the next media item
 @param instanceId      The instance identifier
 @param success         An optional block which returns the success state of the
 call, along with an error object if the call was unsuccessful.
 */
- (void)setNextAVTransportURI:(NSString *)nextURI nextURIMetaData:(NSString *)nextURIMetaData instanceID:(NSString *)instanceId success:(UPPSuccessBlock)successBlock;


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
- (void)mediaInfoWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion;

/**
 Get transport information from the service

 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)transportInfoWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion;

/**
 Get position information from the service

 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)positionInfoWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion;

/**
 Get device capabilities from the service

 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)deviceCapabilitiesWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion;

/**
 Get tranport settings from the service

 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)transportSettingsWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion;

/**
 Get tranport actions from the service

 @param instanceId The instance identifier
 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)transportActionsWithInstanceID:(NSString *)instanceId completion:(UPPResponseBlock)completion;


#pragma mark - General Transport Controls

///-----------------------------------------------------------------------------
/// @name General Transport Controls
///-----------------------------------------------------------------------------

/**
 Send stop command

 @param instanceId The instance identifier
 @param success    An optional block which returns the success state of the call,
 along with an error object if the call was unsuccessful.

 */
- (void)stopWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)successBlock;

/**
 Send play command, with speed set to `1`

 @param instanceId The instance identifier
 @param success    An optional block which returns the success state of the call,
 along with an error object if the call was unsuccessful.
*/
- (void)playWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)successBlock;

/**
 Send play command with a speed setting

 @param instanceId The instance identifier
 @param speed      Playback speed
 @param success    An optional block which returns the success state of the call,
 along with an error object if the call was unsuccessful.
 */
- (void)playWithInstanceID:(NSString *)instanceId speed:(NSString *)speed success:(UPPSuccessBlock)successBlock;

/**
 Send pause command

 @param instanceId The instance identifier
 @param success    An optional block which returns the success state of the call,
 along with an error object if the call was unsuccessful.
 */
- (void)pauseWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)successBlock;

/**
 Send record command

 @param instanceId The instance identifier
 @param success    An optional block which returns the success state of the call,
 along with an error object if the call was unsuccessful.
 */
- (void)recordWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)successBlock;

/**
 Seek to time

 @param instanceId The instance identifier
 @param unit       The seek mode
 @param target     The time to seek to
 @param success    An optional block which returns the success state of the call,
 along with an error object if the call was unsuccessful.
 */
- (void)setSeekWithInstanceID:(NSString *)instanceId unit:(NSString *)unit target:(NSString *)target success:(UPPSuccessBlock)successBlock;

/**
 Send next command

 @param instanceId The instance identifier
 @param success    An optional block which returns the success state of the call,
 along with an error object if the call was unsuccessful.
 */
- (void)nextWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)successBlock;

/**
 Send previous command

 @param instanceId The instance identifier
 @param success    An optional block which returns the success state of the call,
 along with an error object if the call was unsuccessful.
 */
- (void)previousWithInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)successBlock;


#pragma mark - Mode Setting

///-----------------------------------------------------------------------------
/// @name Mode Setting
///-----------------------------------------------------------------------------

/**
 Set play mode

 @param newPlayMode The new play mode
 @param instanceId  The instance identifier
 @param success     An optional block which returns the success state of the call,
 along with an error object if the call was unsuccessful.
 */
- (void)setPlayMode:(NSString *)newPlayMode withInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)successBlock;

/**
 Set record mode

 @param newRecordMode The new record mode
 @param instanceId    The instance identifier
 @param success       An optional block which returns the success state of the
     call, along with an error object if the call was unsuccessful.
 */
- (void)setRecordMode:(NSString *)newRecordMode withInstanceID:(NSString *)instanceId success:(UPPSuccessBlock)successBlock;

@end
