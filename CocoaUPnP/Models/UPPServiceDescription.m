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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.serviceType = [decoder decodeObjectForKey:@"serviceType"];
        self.serviceId = [decoder decodeObjectForKey:@"serviceId"];
        self.descriptionURL = [decoder decodeObjectForKey:@"descriptionURL"];
        self.controlURL = [decoder decodeObjectForKey:@"controlURL"];
        self.eventSubURL = [decoder decodeObjectForKey:@"eventSubURL"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.serviceType forKey:@"serviceType"];
    [encoder encodeObject:self.serviceId forKey:@"serviceId"];
    [encoder encodeObject:self.descriptionURL forKey:@"descriptionURL"];
    [encoder encodeObject:self.controlURL forKey:@"controlURL"];
    [encoder encodeObject:self.eventSubURL forKey:@"eventSubURL"];
}

@end
