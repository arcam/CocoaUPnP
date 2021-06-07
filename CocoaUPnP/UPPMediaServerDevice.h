// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicDevice.h"

@class UPPContentDirectoryService;
@class UPPConnectionManagerService;
@class UPPAVTransportService;

/**
 This class describes a UPnP MediaServer device.
 @see http://upnp.org/specs/av/UPnP-av-MediaServer-v1-Device.pdf
 */
@interface UPPMediaServerDevice : UPPBasicDevice

/**
 Convenience initialiser

 @param urn     The device's uniform resource name
 @param baseURL The base URL to use with service calls

 @return A new `UPPMediaServerDevice`
 */
+ (instancetype)mediaServerWithURN:(NSString *)urn baseURL:(NSURL *)baseURL;

/**
 Returns the first result in `services` matching `:service:ContentDirectory:`
 */
- (UPPContentDirectoryService *)contentDirectoryService;

/**
 Returns the first result in `services` matching `:service:ConnectionManager:`
 */
- (UPPConnectionManagerService *)connectionManagerService;

/**
 Returns the first result in `services` matching `:service:AVTransport:`
 */
- (UPPAVTransportService *)avTransportService;

@end
