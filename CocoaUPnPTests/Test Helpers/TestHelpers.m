// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "TestHelpers.h"

NSData *(^LoadDataFromXML)(NSString *, Class) = ^NSData *(NSString *fileName, Class class)
{
    NSBundle *bundle = [NSBundle bundleForClass:class];
    NSString *filePath = [bundle pathForResource:fileName ofType:@"xml"];
    return [NSData dataWithContentsOfFile:filePath];
};
