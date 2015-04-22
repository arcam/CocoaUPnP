// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 This class defines a basic UPnP device.
 */
@interface UPPBasicDevice : NSObject

/**
 UPnP device type, e.g. `urn:schemas-upnp-org:device:MediaRenderer:1`
 */
@property (copy, nonatomic) NSString *deviceType;

/**
 Device XML location
 */
@property (copy, nonatomic) NSURL *xmlLocation;

/**
 The base URL of the device.
 */
@property (copy, nonatomic) NSURL *baseURL;

/**
 The device's friendly name
 */
@property (copy, nonatomic) NSString *friendlyName;

/**
 Device manufacturer
 */
@property (copy, nonatomic) NSString *manufacturer;

/**
 Device manufacturer's URL
 */
@property (copy, nonatomic) NSURL *manufacturerURL;

/**
 Device description
 */
@property (copy, nonatomic) NSString *modelDescription;

/**
 Model name
 */
@property (copy, nonatomic) NSString *modelName;

/**
 Model number
 */
@property (copy, nonatomic) NSString *modelNumber;

/**
 Model URL
 */
@property (copy, nonatomic) NSURL *modelURL;

/**
 Device serial number
 */
@property (copy, nonatomic) NSString *serialNumber;

/**
 Unique device number
 */
@property (copy, nonatomic) NSString *udn;

/**
 An array of icon objects as presented by the device.
 @see UPPDeviceIcon
 */
@property (copy, nonatomic) NSArray *iconList;

/**
 An array of service objects supported by the device. @see UPPServiceDescription
 */
@property (copy, nonatomic) NSArray *services;

/**
 Unique service name
 *
 @return Returns a unique service name `udn::deviceType`
 */
- (NSString *)usn;

@end
