// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Foundation/Foundation.h>

/**
 *  Load test XML data files
 *
 *  @param NSString Filename without file extension
 *  @param Class    The current class
 *
 *  @return Returns `NSData` with contents of file
 */
NSData *(^LoadDataFromXML)(NSString *, Class);
