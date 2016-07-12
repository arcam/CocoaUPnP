// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicDevice.h"

@class UPPRenderingControlService;
@class UPPConnectionManagerService;
@class UPPAVTransportService;

/**
 This class describes a UPnP MediaRenderer device.
 @see http://upnp.org/specs/av/UPnP-av-MediaServer-v1-Device.pdf
 */
@interface UPPMediaRendererDevice : UPPBasicDevice

/**
 Convenience initialiser

 @param urn     The device's uniform resource name
 @param baseURL The base URL to use with service calls

 @return A new `UPPMediaServerDevice`
 */
+ (nullable instancetype)mediaRendererWithURN:(nonnull NSString *)urn baseURL:(nonnull NSURL *)baseURL;

/**
 Returns the first result in `services` matching `:service:RenderingControl:`
 */
- (nullable UPPRenderingControlService *)renderingControlService;

/**
 Returns the first result in `services` matching `:service:ConnectionManager:`
 */
- (nullable UPPConnectionManagerService *)connectionManagerService;

/**
 Returns the first result in `services` matching `:service:AVTransport:`
 */
- (nullable UPPAVTransportService *)avTransportService;

@end
