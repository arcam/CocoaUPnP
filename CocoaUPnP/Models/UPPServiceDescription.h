// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 This class defines a UPnP service
 */
@interface UPPServiceDescription : NSObject <NSCoding>

/**
 UPnP compliant service type. E.g.
 `urn:schemas-upnp-org:service:RenderingControl:1`
 */
@property (copy, nonatomic, nonnull) NSString *serviceType;

/**
 Service identifier. E.g. `urn:upnp-org:serviceId:RenderingControl`
 */
@property (copy, nonatomic, nonnull) NSString *serviceId;

/**
 Service description URL path
 */
@property (copy, nonatomic, nonnull) NSString *descriptionURL;

/**
 Control URL path
 */
@property (copy, nonatomic, nonnull) NSString *controlURL;

/**
 Event subscription URL path
 */
@property (copy, nonatomic, nonnull) NSString *eventSubURL;

@end
