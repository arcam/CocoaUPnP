// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 Parser completion block
 
 @param response The SOAP response as an `NSDictionary`
 @param error    An optional `NSError` which is returned in the event of parse 
                 failure
 */
typedef void(^Response)(NSDictionary *response, NSError *error);

/**
 This class is responsible for the initial parsing of SOAP responses
 */
@interface UPPResponseParser : NSObject

/**
 Initialise a new parser object
 
 @param data A data representation of an XML device document
 
 @return Returns a new parser instance
 */
- (instancetype)initWithXMLData:(NSData *)data;

/**
 Parse the previously supplied XML data
 
 @param completion A completion block returning either a `UPPDevice` object
 or an `NSError` object
 */
- (void)parseWithResponse:(Response)responseBlock;

@end
