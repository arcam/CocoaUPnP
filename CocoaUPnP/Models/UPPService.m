
#import "UPPService.h"

@implementation UPPService

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
