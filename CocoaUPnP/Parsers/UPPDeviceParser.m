
#import "UPPDeviceParser.h"
#import "UPPBasicDevice.h"
#import "Ono.h"
#import "UPPDeviceIcon.h"
#import "UPPService.h"
#import "UPPError.h"

@interface UPPDeviceParser ()
@property (strong, nonatomic) NSData *data;
@end

@implementation UPPDeviceParser

- (instancetype)initWithXMLData:(NSData *)data
{
    self = [super init];
    
    if (self) {
        self.data = data;
    }
    
    return self;
}

- (void)parseWithCompletion:(CompletionBlock)completion
{
    if (!completion) {
        return;
    }
    
    if (!self.data) {
        completion(nil, UPPErrorWithCode(UPPErrorCodeEmptyData));
        return;
    }
    
    NSError *error = nil;
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:self.data error:&error];
    
    if (!document) {
        completion(nil, error);
        return;
    }
    
    __block UPPBasicDevice *device;
    
    [document enumerateElementsWithXPath:@"//*[name()='device']" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        device = [[UPPBasicDevice alloc] init];
        [self parseElement:element intoDevice:device];
        [self parseIcons:[element firstChildWithTag:@"iconList"] intoDevice:device];
        [self parseServices:[element firstChildWithTag:@"serviceList"] intoDevice:device];
    }];
    
    if (!device) {
        completion(nil, UPPErrorWithCode(UPPErrorCodeNoDeviceElementFound));
        return;
    }
    
    completion(device, nil);
}

#pragma mark - Private Methods

- (void)parseElement:(ONOXMLElement *)element intoDevice:(UPPBasicDevice *)device
{
    device.deviceType = [[element firstChildWithTag:@"deviceType"] stringValue];
    device.friendlyName = [[element firstChildWithTag:@"friendlyName"] stringValue];
    device.manufacturer = [[element firstChildWithTag:@"manufacturer"] stringValue];
    device.modelDescription = [[element firstChildWithTag:@"modelDescription"] stringValue];
    device.modelName = [[element firstChildWithTag:@"modelName"] stringValue];
    device.modelNumber = [[element firstChildWithTag:@"modelNumber"] stringValue];
    device.serialNumber = [[element firstChildWithTag:@"serialNumber"] stringValue];
    device.udn = [[element firstChildWithTag:@"UDN"] stringValue];
    
    NSString *url = [[element firstChildWithTag:@"manufacturerURL"] stringValue];
    device.manufacturerURL = [NSURL URLWithString:url];
    url = [[element firstChildWithTag:@"modelURL"] stringValue];
    device.modelURL = [NSURL URLWithString:url];
}

- (void)parseIcons:(ONOXMLElement *)iconList intoDevice:(UPPBasicDevice *)device
{
    NSMutableArray *icons = [NSMutableArray array];
    [iconList.children enumerateObjectsUsingBlock:^(ONOXMLElement *iconElement, NSUInteger idx, BOOL *stop) {
        UPPDeviceIcon *icon = [[UPPDeviceIcon alloc] init];
        icon.mimetype = [[iconElement firstChildWithTag:@"mimetype"] stringValue];
        icon.width = [[iconElement firstChildWithTag:@"width"] numberValue];
        icon.height = [[iconElement firstChildWithTag:@"height"] numberValue];
        icon.depth = [[iconElement firstChildWithTag:@"depth"] numberValue];
        icon.url = [[iconElement firstChildWithTag:@"url"] stringValue];
        [icons addObject:icon];
    }];
    
    if (icons.count > 0) {
        device.iconList = [icons copy];
    }
}

- (void)parseServices:(ONOXMLElement *)serviceList intoDevice:(UPPBasicDevice *)device
{
    NSMutableArray *services = [NSMutableArray array];
    [serviceList.children enumerateObjectsUsingBlock:^(ONOXMLElement *serviceElement, NSUInteger idx, BOOL *stop) {
        UPPService *service = [[UPPService alloc] init];
        service.serviceType = [[serviceElement firstChildWithTag:@"serviceType"] stringValue];
        service.serviceId = [[serviceElement firstChildWithTag:@"serviceId"] stringValue];
        service.descriptionURL = [[serviceElement firstChildWithTag:@"SCPDURL"] stringValue];
        service.controlURL = [[serviceElement firstChildWithTag:@"controlURL"] stringValue];
        service.eventSubURL = [[serviceElement firstChildWithTag:@"eventSubURL"] stringValue];
        [services addObject:service];
    }];
    
    if (services.count > 0) {
        device.services = [services copy];
    }
}

@end
