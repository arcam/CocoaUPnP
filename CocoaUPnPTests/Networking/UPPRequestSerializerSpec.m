// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPRequestSerializer.h"
#import "UPPConstants.h"

SpecBegin(UPPRequestSerializer)

describe(@"UPPRequestSerializer", ^{
    
    __block NSURL *url;
    __block NSURLRequest *request;
    __block NSString *soapAction;
    __block NSString *nameSpace;
    
    beforeEach(^{
        UPPRequestSerializer *serializer = [UPPRequestSerializer serializer];
        
        url = [NSURL URLWithString:@"http://www.google.com"];
        NSURLRequest *inRequest = [NSURLRequest requestWithURL:url];
        
        soapAction = @"Play";
        nameSpace = @"urn:schemas-upnp-org:service:AVTransport:1";
        NSDictionary *params = @{ @"InstanceID" : @"0", @"Speed" : @"1" };
        
        NSDictionary *paramWrapper = @{ UPPSOAPActionKey: soapAction,
                                        UPPNameSpaceKey: nameSpace,
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
        
        NSString *soapHeader = [NSString stringWithFormat:@"\"%@#%@\"", nameSpace, soapAction];
        expect(headers[@"SOAPACTION"]).to.equal(soapHeader);
        
        NSString *length = [NSString stringWithFormat:@"%@", @(request.HTTPBody.length)];
        expect(headers[@"Content-Length"]).to.equal(length);
        
        expect(headers[@"Content-Type"]).to.equal(@"text/xml; charset=\"utf-8\"");
    });
    
    it(@"should pass through URL", ^{
        expect(request.URL).to.equal(url);
    });
    
});

SpecEnd
