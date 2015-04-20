// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicDevice.h"

@implementation UPPBasicDevice

- (NSString *)usn
{
    return [NSString stringWithFormat:@"%@::%@", self.udn, self.deviceType];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, friendlyName: %@, udn: %@>",
            NSStringFromClass([self class]), self, self.friendlyName, self.udn];
}

@end
