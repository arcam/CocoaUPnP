// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicDevice.h"
#import "UPPBasicService.h"

@implementation UPPBasicDevice

- (NSString *)usn
{
    return [NSString stringWithFormat:@"%@::%@", self.udn, self.deviceType];
}

- (NSURL *)controlURLForService:(UPPBasicService *)service
{
    if (!service.controlURL) {
        return nil;
    }
    NSString *component = service.controlURL.absoluteString;
    return [self.baseURL URLByAppendingPathComponent:component];
}

- (UPPBasicService *)serviceForNameSpace:(NSString *)nameSpace
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nameSpace contains %@", nameSpace];
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
