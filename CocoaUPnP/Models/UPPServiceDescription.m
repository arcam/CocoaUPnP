// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPServiceDescription.h"

@implementation UPPServiceDescription

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:
            @"<%@: %p, serviceType: %@, serviceId: %@, descriptionURL: %@,"
                           @"controlURL: %@, eventSubURL: %@>",
            NSStringFromClass([self class]), self, self.serviceId,
            self.descriptionURL, self.descriptionURL, self.controlURL,
            self.eventSubURL];
}

@end
