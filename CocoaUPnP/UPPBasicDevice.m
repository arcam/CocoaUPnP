// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicDevice.h"
#import "UPPServiceDescription.h"

@implementation UPPBasicDevice

+ (instancetype)deviceWithURN:(nonnull NSString *)urn baseURL:(nonnull NSURL *)baseURL
{
    return [[[self class] alloc] initWithURN:urn baseURL:baseURL];
}

- (instancetype)initWithURN:(nonnull NSString *)urn baseURL:(nonnull NSURL *)baseURL
{
    self = [super init];
    if (!self) { return nil; }

    self.deviceType = urn;
    self.baseURL = baseURL;
    return self;
}

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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.deviceType = [decoder decodeObjectForKey:@"deviceType"];
        self.xmlLocation = [decoder decodeObjectForKey:@"xmlLocation"];
        self.baseURL = [decoder decodeObjectForKey:@"baseURL"];
        self.friendlyName = [decoder decodeObjectForKey:@"friendlyName"];
        self.manufacturer = [decoder decodeObjectForKey:@"manufacturer"];
        self.manufacturerURL = [decoder decodeObjectForKey:@"manufacturerURL"];
        self.modelDescription = [decoder decodeObjectForKey:@"modelDescription"];
        self.modelName = [decoder decodeObjectForKey:@"modelName"];
        self.modelNumber = [decoder decodeObjectForKey:@"modelNumber"];
        self.modelURL = [decoder decodeObjectForKey:@"modelURL"];
        self.serialNumber = [decoder decodeObjectForKey:@"serialNumber"];
        self.udn = [decoder decodeObjectForKey:@"udn"];
        self.iconList = [decoder decodeObjectForKey:@"iconList"];
        self.services = [decoder decodeObjectForKey:@"services"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.deviceType forKey:@"deviceType"];
    [encoder encodeObject:self.xmlLocation forKey:@"xmlLocation"];
    [encoder encodeObject:self.baseURL forKey:@"baseURL"];
    [encoder encodeObject:self.friendlyName forKey:@"friendlyName"];
    [encoder encodeObject:self.manufacturer forKey:@"manufacturer"];
    [encoder encodeObject:self.manufacturerURL forKey:@"manufacturerURL"];
    [encoder encodeObject:self.modelDescription forKey:@"modelDescription"];
    [encoder encodeObject:self.modelName forKey:@"modelName"];
    [encoder encodeObject:self.modelNumber forKey:@"modelNumber"];
    [encoder encodeObject:self.modelURL forKey:@"modelURL"];
    [encoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [encoder encodeObject:self.udn forKey:@"udn"];
    [encoder encodeObject:self.iconList forKey:@"iconList"];
    [encoder encodeObject:self.services forKey:@"services"];
}

@end
