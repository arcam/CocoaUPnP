// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "TestHelpers.h"

NSData *LoadDataFromXML(NSString *filename, Class aClass)
{
    NSBundle *bundle = [NSBundle bundleForClass:aClass];
    NSString *filePath = [bundle pathForResource:filename ofType:@"xml"];
    return [NSData dataWithContentsOfFile:filePath];
};
