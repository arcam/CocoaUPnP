// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

@interface UPPBaseParser : NSObject

/**
 Initialise a new parser object
 
 @param data A data representation of an XML device document
 
 @return Returns a new parser instance
 */
- (instancetype)initWithXMLData:(NSData *)data;

/**
 Get the data that was passed in during initialisation
 
 @return Returns the parser objects current data
 */
- (NSData *)data;

@end
