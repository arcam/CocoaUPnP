// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <AFNetworking/AFNetworking.h>
#import "TestHelpers.h"

SpecBegin(UPPRequestSerializer)

describe(@"UPPRequestSerializer", ^{

    __block NSURL *url;
    __block NSURLRequest *request;
    __block NSString *soapAction;
    __block NSString *serviceType;
    __block NSMutableURLRequest *mutableRequest;

    beforeEach(^{
        UPPRequestSerializer *serializer = [UPPRequestSerializer serializer];

        url = [NSURL URLWithString:@"http://www.google.com"];
        mutableRequest = [NSMutableURLRequest requestWithURL:url];
        mutableRequest.HTTPMethod = @"POST";
        NSURLRequest *inRequest = [mutableRequest copy];

        soapAction = @"Play";
        serviceType = @"urn:schemas-upnp-org:service:AVTransport:1";
        NSArray *keys = @[ @"InstanceID", @"Speed" ];
        NSArray *values = @[ @"0", @"1" ];
        UPPParameters *params = [UPPParameters paramsWithKeys:keys
                                                       values:values];

        NSDictionary *paramWrapper = @{ UPPSOAPActionKey: soapAction,
                                        UPPNameSpaceKey: serviceType,
                                        UPPParametersKey: params };
        NSError *error = nil;
        request = [serializer requestBySerializingRequest:inRequest
                                           withParameters:paramWrapper
                                                    error:&error];
    });

    it(@"should serialize SOAP body", ^{
        NSData *data = LoadDataFromXML(@"PlayRequest", [self class]);
        NSString *expected = [[NSString alloc]
                              initWithData:data encoding:NSUTF8StringEncoding];


        NSString *body = [[NSString alloc] initWithData:request.HTTPBody
                                               encoding:NSUTF8StringEncoding];

        expect(body).to.equal(expected);
    });

    it(@"should set required HTTP headers", ^{
        NSDictionary *headers = request.allHTTPHeaderFields;

        NSString *soapHeader = [NSString stringWithFormat:@"\"%@#%@\"", serviceType, soapAction];
        expect(headers[@"SOAPACTION"]).to.equal(soapHeader);

        NSString *length = [NSString stringWithFormat:@"%@", @(request.HTTPBody.length)];
        expect(headers[@"Content-Length"]).to.equal(length);

        expect(headers[@"Content-Type"]).to.equal(@"text/xml; charset=\"utf-8\"");
    });

    it(@"should pass through URL", ^{
        expect(request.URL).to.equal(url);
    });

    it(@"should set http method to POST", ^{
        expect(request.HTTPMethod).to.equal(@"POST");
    });

    it(@"should set http method to GET", ^{
        mutableRequest.HTTPMethod = @"GET";

        request = [[UPPRequestSerializer serializer] requestBySerializingRequest:[mutableRequest copy] withParameters:nil error:nil];
        expect(request.HTTPMethod).to.equal(@"GET");
    });
});

SpecEnd
