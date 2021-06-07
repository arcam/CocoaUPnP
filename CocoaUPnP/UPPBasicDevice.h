// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>
#import "UPPDeviceIcon.h"

@class UPPServiceDescription;

/**
 This class defines a basic UPnP device.
 */
@interface UPPBasicDevice : NSObject <NSCoding>

/**
 UPnP device type, e.g. `urn:schemas-upnp-org:device:MediaRenderer:1`
 */
@property (copy, nonatomic, nonnull) NSString *deviceType;

/**
 Device XML location
 */
@property (copy, nonatomic, nonnull) NSURL *xmlLocation;

/**
 The base URL of the device.
 */
@property (copy, nonatomic, nonnull) NSURL *baseURL;

/**
 The device's friendly name
 */
@property (copy, nonatomic, nonnull) NSString *friendlyName;

/**
 Device manufacturer
 */
@property (copy, nonatomic, nullable) NSString *manufacturer;

/**
 Device manufacturer's URL
 */
@property (copy, nonatomic, nullable) NSURL *manufacturerURL;

/**
 Device description
 */
@property (copy, nonatomic, nullable) NSString *modelDescription;

/**
 Model name
 */
@property (copy, nonatomic, nonnull) NSString *modelName;

/**
 Model number
 */
@property (copy, nonatomic, nullable) NSString *modelNumber;

/**
 Model URL
 */
@property (copy, nonatomic, nullable) NSURL *modelURL;

/**
 Device serial number
 */
@property (copy, nonatomic, nullable) NSString *serialNumber;

/**
 Unique device number
 */
@property (copy, nonatomic, nonnull) NSString *udn;

/**
 An array of icon objects as presented by the device.
 @see UPPDeviceIcon
 */
@property (copy, nonatomic, nullable) NSArray <UPPDeviceIcon *> *iconList;

/**
 An array of service objects supported by the device. @see UPPServiceDescription
 */
@property (copy, nonatomic, nonnull) NSArray <UPPServiceDescription *> *services;

/**
 Unique service name
 *
 @return Returns a unique service name `udn::deviceType`
 */
- (nonnull NSString *)usn;

/**
 Convenience initialiser

 @param urn     The device's uniform resource name
 @param baseURL The base URL to use with service calls

 @return A new `UPPBasicDevice`
 */
+ (nonnull instancetype)deviceWithURN:(nonnull NSString *)urn baseURL:(nonnull NSURL *)baseURL;

/**
 Object initialiser

 @param urn     The device's uniform resource name
 @param baseURL The base URL to use with service calls

 @return A new `UPPBasicDevice`
 */
- (nonnull instancetype)initWithURN:(nonnull NSString *)urn baseURL:(nonnull NSURL *)baseURL;

/**
 Find the first service which matches `serviceType`

 @param serviceType The service type to search for

 @return The matching service description, or nil if no matches found
 */
- (nullable UPPServiceDescription *)serviceForType:(nonnull NSString *)serviceType;

@end
