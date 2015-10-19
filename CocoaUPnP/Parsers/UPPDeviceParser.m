// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPDeviceParser.h"
#import "UPPBasicDevice.h"
#import "Ono.h"
#import "UPPDeviceIcon.h"
#import "UPPServiceDescription.h"
#import "UPPError.h"
#import "AFHTTPSessionManager.h"
#import "UPPRequestSerializer.h"
#import "UPPMediaRendererDevice.h"
#import "UPPMediaServerDevice.h"

@implementation UPPDeviceParser

+ (void)parseURL:(NSURL *)url withCompletion:(CompletionBlock)completion
{
    if (!completion) {
        return;
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url.absoluteString parameters:nil success:^(NSURLSessionDataTask *task, NSData *data) {
        UPPDeviceParser *parser = [[UPPDeviceParser alloc] initWithXMLData:data];
        [parser parseWithBaseURL:url completion:^(NSArray *devices, NSError *error) {
            completion(devices, error);
        }];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

#pragma mark - Private Methods

- (void)parseWithBaseURL:(NSURL *)baseURL completion:(CompletionBlock)completion
{
    if (!completion) {
        return;
    }

    if (self.data.length == 0) {
        completion(nil, UPPErrorWithCode(UPPErrorCodeEmptyData));
        return;
    }

    NSError *error = nil;
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:self.data error:&error];

    if (!document) {
        completion(nil, error);
        return;
    }

    __block NSMutableArray *devices;

    [document.rootElement enumerateElementsWithXPath:@"//*[name()='device']" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSString *deviceType = [[element firstChildWithTag:@"deviceType"] stringValue];

        UPPBasicDevice *device;

        if ([deviceType rangeOfString:@":MediaRenderer:"].location != NSNotFound) {
            device = [UPPMediaRendererDevice mediaRendererWithURN:deviceType
                                                          baseURL:baseURL];
        } else if ([deviceType rangeOfString:@":MediaServer:"].location != NSNotFound) {
            device = [UPPMediaServerDevice mediaServerWithURN:deviceType
                                                      baseURL:baseURL];
        }
        [self parseElement:element intoDevice:device];
        [self parseIcons:[element firstChildWithTag:@"iconList"] intoDevice:device];
        [self parseServices:[element firstChildWithTag:@"serviceList"] intoDevice:device];

        if (!device) {
            return;
        }

        if (!devices) {
            devices = [NSMutableArray array];
        }

        [devices addObject:device];
    }];

    if (!devices) {
        completion(nil, UPPErrorWithCode(UPPErrorCodeNoDeviceElementFound));
        return;
    }

    completion([devices copy], nil);
}

- (void)parseElement:(ONOXMLElement *)element intoDevice:(UPPBasicDevice *)device
{
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
        UPPServiceDescription *service = [[UPPServiceDescription alloc] init];
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
