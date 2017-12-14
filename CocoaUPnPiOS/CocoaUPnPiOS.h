//
//  CocoaUPnPiOS.h
//  CocoaUPnPiOS
//
//  Created by Daniel K. Poulsen on 14/12/2017.
//  Copyright © 2017 cambridgeaudio. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for CocoaUPnPiOS.
FOUNDATION_EXPORT double CocoaUPnPiOSVersionNumber;

//! Project version string for CocoaUPnPiOS.
FOUNDATION_EXPORT const unsigned char CocoaUPnPiOSVersionString[];

// Events
#import "UPPEventServer.h"
#import "UPPEventSubscription.h"
#import "UPPEventSubscriptionManager.h"

// Helpers
#import "NSArray+firstObjectMatchingPredicate.h"
#import "NSMutableString+xmlNode.h"
#import "UPPMetadataHelper.h"

// Models
#import "UPPBasicDevice.h"
#import "UPPConstants.h"
#import "UPPDeviceIcon.h"
#import "UPPError.h"
#import "UPPMediaItem.h"
#import "UPPMediaItemArtwork.h"
#import "UPPMediaItemResource.h"
#import "UPPMediaRendererDevice.h"
#import "UPPMediaServerDevice.h"
#import "UPPParameters.h"
#import "UPPServiceDescription.h"

// Networking
#import "UPPDiscovery.h"
#import "UPPRequestSerializer.h"
#import "UPPResponseSerializer.h"
#import "UPPSessionManager.h"

// Parsing
#import "UPPBaseParser.h"
#import "UPPDeviceParser.h"
#import "UPPErrorParser.h"
#import "UPPLastChangeParser.h"
#import "UPPMediaItemParser.h"
#import "UPPResponseParser.h"

// Protocols
#import "UPPMediaItemProtocol.h"

// Services
#import "UPPAVTransportService.h"
#import "UPPBasicService.h"
#import "UPPConnectionManagerService.h"
#import "UPPContentDirectoryService.h"
#import "UPPRenderingControlService.h"
