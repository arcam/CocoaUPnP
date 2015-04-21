// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 This class defines a UPnP service
 */
@interface UPPServiceDescription : NSObject

/**
 UPnP compliant service type. E.g.
 `urn:schemas-upnp-org:service:RenderingControl:1`
 */
@property (copy, nonatomic) NSString *serviceType;

/**
 Service identifier. E.g. `urn:upnp-org:serviceId:RenderingControl`
 */
@property (copy, nonatomic) NSString *serviceId;

/**
 Service description URL path
 */
@property (copy, nonatomic) NSString *descriptionURL;

/**
 Control URL path
 */
@property (copy, nonatomic) NSString *controlURL;

/**
 Event subscription URL path
 */
@property (copy, nonatomic) NSString *eventSubURL;

@end
