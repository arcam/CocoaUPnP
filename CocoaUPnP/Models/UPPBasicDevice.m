// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicDevice.h"
#import "UPPServiceDescription.h"

@implementation UPPBasicDevice

- (NSString *)usn
{
    return [NSString stringWithFormat:@"%@::%@", self.udn, self.deviceType];
}

- (UPPServiceDescription *)serviceForType:(NSString *)serviceType
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"serviceType contains %@", serviceType];
    NSArray *filtered = [self.services filteredArrayUsingPredicate:predicate];

    if (filtered.count == 0) {
        return nil;
    }

    return [filtered firstObject];
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, friendlyName: %@, udn: %@>",
            NSStringFromClass([self class]), self, self.friendlyName, self.udn];
}

@end
