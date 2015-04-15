
#import "UPPDeviceParser.h"
#import "UPPBasicDevice.h"
#import "UPPDeviceIcon.h"
#import "UPPService.h"
#import "UPPError.h"

SpecBegin(UPPDeviceParser)

NSData *(^LoadDataFromXML)(NSString *) = ^NSData *(NSString *fileName)
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:fileName ofType:@"xml"];
    return [NSData dataWithContentsOfFile:filePath];
};

describe(@"UPPDeviceParser", ^{
    
    __block UPPDeviceParser *parser;
    
    it(@"should parse device xml", ^{
        NSData *data = LoadDataFromXML(@"Device");
        parser = [[UPPDeviceParser alloc] initWithXMLData:data];
        
        waitUntil(^(DoneCallback done) {
            
            [parser parseWithCompletion:^(UPPBasicDevice *device, NSError *error) {
                
                expect(error).to.beNil();
                
                expect(device).toNot.beNil();
                expect(device.deviceType).to.equal(@"urn:schemas-upnp-org:device:MediaRenderer:1");
                expect(device.friendlyName).to.equal(@"Paul");
                expect(device.manufacturer).to.equal(@"ARCAM");
                expect(device.manufacturerURL.absoluteString).to.equal(@"http://www.arcam.co.uk");
                expect(device.modelDescription).to.equal(@"A description");
                expect(device.modelName).to.equal(@"model");
                expect(device.modelNumber).to.equal(@"123");
                expect(device.modelURL.absoluteString).to.equal(@"http://www.arcam.co.uk");
                expect(device.serialNumber).to.equal(@"123456789012");
                expect(device.udn).to.equal(@"uuid:5f9ec1b3-ed59-1900-4530-123456789012");
                expect(device.usn).to.equal(@"uuid:5f9ec1b3-ed59-1900-4530-123456789012::urn:schemas-upnp-org:device:MediaRenderer:1");
                
                // Icons
                NSArray *iconList = device.iconList;
                expect(iconList.count).to.equal(2);
                UPPDeviceIcon *icon = [iconList firstObject];
                expect(icon.mimetype).to.equal(@"image/jpeg");
                expect(icon.width).to.equal(48);
                expect(icon.height).to.equal(48);
                expect(icon.depth).to.equal(24);
                expect(icon.url).to.equal(@"/icon_small.jpg");
                
                // Services
                NSArray *services = device.services;
                expect(services.count).to.equal(3);
                UPPService *service = [services firstObject];
                expect(service.serviceType).to.equal(@"urn:schemas-upnp-org:service:RenderingControl:1");
                expect(service.serviceId).to.equal(@"urn:upnp-org:serviceId:RenderingControl");
                expect(service.descriptionURL).to.equal(@"/RenderingControl/desc.xml");
                expect(service.controlURL).to.equal(@"/RenderingControl/ctrl");
                expect(service.eventSubURL).to.equal(@"/RenderingControl/evt");
                
                done();
                
            }];
            
        });
        
    });
    
    it(@"should return an error when no device found", ^{
        NSData *data = LoadDataFromXML(@"Empty");
        parser = [[UPPDeviceParser alloc] initWithXMLData:data];
        
        waitUntil(^(DoneCallback done) {
            
            [parser parseWithCompletion:^(UPPBasicDevice *device, NSError *error) {
                expect(device).to.beNil();
                expect(error).toNot.beNil();
                expect(error.code).to.equal(UPPErrorCodeNoDeviceElementFound);
            }];
            
            done();
            
        });
        
    });
    
    it(@"should exit early with no data", ^{
        parser = [[UPPDeviceParser alloc] initWithXMLData:nil];
        
        waitUntil(^(DoneCallback done) {
            
            [parser parseWithCompletion:^(UPPBasicDevice *device, NSError *error) {
                expect(device).to.beNil();
                expect(error).toNot.beNil();
                expect(error.code).to.equal(UPPErrorCodeEmptyData);
            }];
            
            done();
            
        });
        
    });
    
});

SpecEnd
