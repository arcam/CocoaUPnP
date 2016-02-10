// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>

SpecBegin(UPPBasicService)

describe(@"UPPBasicService", ^{
    __block UPPBasicService *service;
    __block NSURL *baseURL;
    __block UPPServiceDescription *description;
    __block NSString *uniqueDeviceName;

    beforeEach(^{
        baseURL = [NSURL URLWithString:@"http://127.0.0.1"];
        description = [[UPPServiceDescription alloc] init];
        description.serviceType = @"urn:asdf:asdf:1";
        description.controlURL = @"/service/ctrl";
        description.eventSubURL = @"/service/sub";
        uniqueDeviceName = @"udn:example";

        uniqueDeviceName = @"udn:abcd:1234";
        service = [UPPBasicService serviceWithBaseURL:baseURL
                                          description:description
                                     uniqueDeviceName:uniqueDeviceName];
    });

    it(@"should return a populated basic service", ^{
        NSString *controlURL = @"http://127.0.0.1/service/ctrl";
        expect(service.controlURL.absoluteString).to.equal(controlURL);

        NSString *subscriptionURL = @"http://127.0.0.1/service/sub";
        expect(service.eventSubscriptionURL.absoluteString).to.equal(subscriptionURL);

        expect(service.serviceType).to.equal(description.serviceType);

        NSString *usn = [NSString stringWithFormat:@"%@::%@",
                         uniqueDeviceName, description.serviceType];
        expect([service uniqueServiceName]).to.equal(usn);
    });
});

SpecEnd
