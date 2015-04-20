// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "AFURLRequestSerialization.h"

/**
 This class serves as a base class for serialising SOAP requests
 */
@interface UPPRequestSerializer : AFHTTPRequestSerializer

/**
 The SOAP action title, e.g. Play, Browse, etc
 */
@property (copy, nonatomic) NSString *soapAction;

/**
 The request namespace, which is usually the service type making the request.
 E.g. `urn:schemas-upnp-org:service:AVTransport:1`
 */
@property (copy, nonatomic) NSString *nameSpace;

@end
