#import "NSString+UPPSearchHeaderStrings.h"

SpecBegin(NSString_UPPSearchHeaderStrings)

NSString * (^headerWithSearchTerm) (NSString *) = ^NSString* (NSString *st)
{
    return [NSString stringWithFormat:
            @"M-SEARCH * HTTP/1.1\r\n"
            "HOST: 239.255.255.250:1900\r\n"
            "MAN: \"ssdp:discover\"\r\n"
            "MX: 3\r\n"
            "ST: %@\r\n\r\n", st];
};

describe(@"NSString+UPPSearchHeaderStrings", ^{
    
    it(@"should return a header for searching all devices", ^{
        NSString *st = @"ssdp:all";
        NSString *expected = headerWithSearchTerm(st);
        expect([NSString upp_searchHeaderAllDevices]).to.equal(expected);
    });
    
    it(@"should return a header for searching media servers", ^{
        NSString *st = @"urn:schemas-upnp-org:device:MediaServer:1";
        NSString *expected = headerWithSearchTerm(st);
        expect([NSString upp_searchHeaderMediaServer]).to.equal(expected);
    });
    
    it(@"should return a header for searching media renderers", ^{
        NSString *st = @"urn:schemas-upnp-org:device:MediaRenderer:1";
        NSString *expected = headerWithSearchTerm(st);
        expect([NSString upp_searchHeaderMediaRenderer]).to.equal(expected);
    });
    
    it(@"should return a header for searching connection managers", ^{
        NSString *st = @"urn:schemas-upnp-org:service:ConnectionManager:1";
        NSString *expected = headerWithSearchTerm(st);
        expect([NSString upp_searchHeaderConnectionManager]).to.equal(expected);
    });
    
    it(@"should return a header for searching content directories", ^{
        NSString *st = @"urn:schemas-upnp-org:service:ContentDirectory:1";
        NSString *expected = headerWithSearchTerm(st);
        expect([NSString upp_searchHeaderContentDirectory]).to.equal(expected);
    });
    
    it(@"should return a header for searching av transports", ^{
        NSString *st = @"urn:schemas-upnp-org:service:AVTransport:1";
        NSString *expected = headerWithSearchTerm(st);
        expect([NSString upp_searchHeaderAVTransport]).to.equal(expected);
    });
    
});

SpecEnd
