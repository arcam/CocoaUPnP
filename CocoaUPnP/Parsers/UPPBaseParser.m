// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBaseParser.h"

@interface UPPBaseParser ()
@property (strong, nonatomic) NSData *xmlData;
@end

@implementation UPPBaseParser

- (instancetype)initWithXMLData:(NSData *)data
{
    self = [super init];

    if (self) {
        self.xmlData = data;
    }

    return self;
}

- (NSData *)data
{
    return self.xmlData;
}

@end
