#import "NSString+UPPSearchHeaderStrings.h"

@implementation NSString (UPPSearchHeaderStrings)

+ (NSString *)upp_searchHeaderAllDevices
{
    return [self upp_searchHeaderWithSearchTarget:@"ssdp:all"];
}

+ (NSString *)upp_searchHeaderMediaServer
{
    NSString *type = @"urn:schemas-upnp-org:device:MediaServer:1";
    return [self upp_searchHeaderWithSearchTarget:type];
}

+ (NSString *)upp_searchHeaderMediaRenderer
{
    NSString *type = @"urn:schemas-upnp-org:device:MediaRenderer:1";
    return [self upp_searchHeaderWithSearchTarget:type];
}

+ (NSString *)upp_searchHeaderConnectionManager
{
    NSString *type = @"urn:schemas-upnp-org:service:ConnectionManager:1";
    return [self upp_searchHeaderWithSearchTarget:type];
}

+ (NSString *)upp_searchHeaderContentDirectory
{
    NSString *type = @"urn:schemas-upnp-org:service:ContentDirectory:1";
    return [self upp_searchHeaderWithSearchTarget:type];
}

+ (NSString *)upp_searchHeaderAVTransport
{
    NSString *type = @"urn:schemas-upnp-org:service:AVTransport:1";
    return [self upp_searchHeaderWithSearchTarget:type];
}

#pragma mark - Private Methods

+ (NSString *)upp_searchHeaderWithSearchTarget:(NSString *)searchTarget
{
    return [NSString stringWithFormat:
            @"M-SEARCH * HTTP/1.1\r\n"
            "HOST: 239.255.255.250:1900\r\n"
            "MAN: \"ssdp:discover\"\r\n"
            "MX: 3\r\n"
            "ST: %@\r\n\r\n", searchTarget];
}

@end
