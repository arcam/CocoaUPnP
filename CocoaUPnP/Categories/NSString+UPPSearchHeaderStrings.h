#import <Foundation/Foundation.h>

/**
 *  This category returns a UPnP compliant M-SEARCH HTTP header string
 */
@interface NSString (UPPSearchHeaderStrings)

/**
 *  Search header for all UPnP devices
 *
 *  @return A string representation of a UPnP search header for searching all
 *          UPnP devices
 */
+ (NSString *)upp_searchHeaderAllDevices;

/**
 *  Search header for all UPnP Media Server devices
 *
 *  @return A string representation of a UPnP search header for searching all
 *          devices conforming to `urn:schemas-upnp-org:device:MediaServer:1`
 */
+ (NSString *)upp_searchHeaderMediaServer;

/**
 *  Search header for all UPnP Media Renderer devices
 *
 *  @return A string representation of a UPnP search header for searching all
 *          devices conforming to `urn:schemas-upnp-org:device:MediaRenderer:1`
 */
+ (NSString *)upp_searchHeaderMediaRenderer;

/**
 *  Search header for all UPnP Connection Manager services
 *
 *  @return A string representation of a UPnP search header for searching all
 *          services conforming to `urn:schemas-upnp-org:device:ConnectionManager:1`
 */
+ (NSString *)upp_searchHeaderConnectionManager;

/**
 *  Search header for all UPnP Content Directory services
 *
 *  @return A string representation of a UPnP search header for searching all
 *          services conforming to `urn:schemas-upnp-org:device:ContentDirectory:1`
 */
+ (NSString *)upp_searchHeaderContentDirectory;

/**
 *  Search header for all UPnP AV Transport sevices
 *
 *  @return A string representation of a UPnP search header for searching all
 *          services conforming to `urn:schemas-upnp-org:device:AVTransport:1`
 */
+ (NSString *)upp_searchHeaderAVTransport;

@end
