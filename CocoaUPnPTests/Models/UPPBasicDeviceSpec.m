// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>

SpecBegin(UPPBasicDevice)

describe(@"UPPBasicDevice", ^{
    __block UPPBasicDevice *device;
    __block UPPDeviceIcon *icon;
    __block UPPServiceDescription *service;

    beforeEach(^{
        device = [[UPPBasicDevice alloc] init];
        device.deviceType = @"deviceType";
        device.xmlLocation = [NSURL URLWithString:@"http://127.0.0.1/loc.xml"];
        device.baseURL = [NSURL URLWithString:@"http://127.0.0.1/"];
        device.friendlyName = @"friendlyName";
        device.manufacturer = @"manufacturer";
        device.manufacturerURL = [NSURL URLWithString:@"http://arcam.co.uk"];
        device.modelDescription = @"modelDescription";
        device.modelName = @"modelName";
        device.modelNumber = @"modelNumber";
        device.modelURL = [NSURL URLWithString:@"http://arcam.co.uk"];
        device.serialNumber = @"serialNumber";
        device.udn = @"udn";

        icon = [[UPPDeviceIcon alloc] init];
        icon.mimetype = @"image/jpg";
        icon.width = @60;
        icon.height = @100;
        icon.depth = @24;
        icon.url = @"http://127.0.0.1/image.jpg";
        device.iconList = @[ icon ];

        service = [[UPPServiceDescription alloc] init];
        service.serviceType = @"serviceType";
        service.serviceId = @"serviceId";
        service.descriptionURL = @"descriptionURL";
        service.controlURL = @"controlURL";
        service.eventSubURL = @"eventSubURL";
        device.services = @[ service ];
    });

    it(@"should support NSCoding", ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:device requiringSecureCoding:NO error:nil];
        NSError *error = nil;
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&error];
        unarchiver.requiresSecureCoding = NO;
        UPPBasicDevice *loadedDevice = [unarchiver decodeTopLevelObjectOfClass:[UPPBasicDevice class] forKey:NSKeyedArchiveRootObjectKey error:&error];
        expect(error).to.beNil();
        expect(loadedDevice.deviceType).to.equal(device.deviceType);
        expect(loadedDevice.deviceType).to.equal(device.deviceType);
        expect(loadedDevice.xmlLocation).to.equal(device.xmlLocation);
        expect(loadedDevice.baseURL).to.equal(device.baseURL);
        expect(loadedDevice.friendlyName).to.equal(device.friendlyName);
        expect(loadedDevice.manufacturer).to.equal(device.manufacturer);
        expect(loadedDevice.manufacturerURL).to.equal(device.manufacturerURL);
        expect(loadedDevice.modelDescription).to.equal(device.modelDescription);
        expect(loadedDevice.modelName).to.equal(device.modelName);
        expect(loadedDevice.modelNumber).to.equal(device.modelNumber);
        expect(loadedDevice.modelURL).to.equal(device.modelURL);
        expect(loadedDevice.serialNumber).to.equal(device.serialNumber);
        expect(loadedDevice.udn).to.equal(device.udn);

        expect(loadedDevice.iconList.count).to.equal(1);
        UPPDeviceIcon *loadedIcon = [loadedDevice.iconList firstObject];
        expect(loadedIcon.mimetype).to.equal(icon.mimetype);
        expect(loadedIcon.width).to.equal(icon.width);
        expect(loadedIcon.height).to.equal(icon.height);
        expect(loadedIcon.depth).to.equal(icon.depth);
        expect(loadedIcon.url).to.equal(icon.url);

        expect(loadedDevice.services.count).to.equal(1);
        UPPServiceDescription *loadedService = [loadedDevice.services firstObject];
        expect(loadedService.serviceType).to.equal(service.serviceType);
        expect(loadedService.serviceId).to.equal(service.serviceId);
        expect(loadedService.descriptionURL).to.equal(service.descriptionURL);
        expect(loadedService.controlURL).to.equal(service.controlURL);
        expect(loadedService.eventSubURL).to.equal(service.eventSubURL);
    });
});

SpecEnd
