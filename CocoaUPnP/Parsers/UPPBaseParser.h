// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 This class describes shared functionality between parser classes.
 */
@interface UPPBaseParser : NSObject

/**
 Initialise a new parser object

 @param data A data representation of an XML device document

 @return Returns a new parser instance
 */
- (nonnull instancetype)initWithXMLData:(nonnull NSData *)data;

/**
 Get the data that was passed in during initialisation

 @return Returns the parser objects current data
 */
- (nonnull NSData *)data;

@end
