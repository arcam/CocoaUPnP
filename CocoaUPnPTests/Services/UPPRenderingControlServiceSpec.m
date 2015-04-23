// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPRenderingControlService.h"
#import "UPPConstants.h"
#import "UPPSessionManager.h"
#import "NetworkTestHelpers.h"

SpecBegin(UPPRenderingControlService)

describe(@"UPPRenderingControlService", ^{
    
    __block UPPRenderingControlService *service;
    __block id sessionManager;
    __block NSString *url;
    __block NSString *instanceId;
    
    beforeEach(^{
        service = [[UPPRenderingControlService alloc] init];
        service.nameSpace = @"urn:schemas-upnp-org:service:RenderingControl:1";
        
        sessionManager = [OCMockObject mockForClass:[UPPSessionManager class]];
        service.sessionManager = sessionManager;
        
        url = @"http://127.0.0.1/ctrl";
        NSURL *controlURL = [NSURL URLWithString:url];
        service.controlURL = controlURL;
        
        instanceId = @"0";
    });
    
    describe(@"when getting mute", ^{
        
        __block NSDictionary *expectedParams;
        __block NSString *channel;
        
        beforeEach(^{
            channel = @"Master";
            NSDictionary *params = @{ @"InstanceID": instanceId,
                                      @"Channel": channel };
            
            expectedParams = @{ UPPSOAPActionKey: @"GetMute",
                                UPPNameSpaceKey: service.nameSpace,
                                UPPParametersKey: params };
        });
        
        it(@"should send required parameters", ^{
            VerifyGetPostWithParams(expectedParams, sessionManager, url);
            
            [service muteWithInstanceID:instanceId channel:channel completion:^(NSDictionary *response, NSError *error) {
                expect(response).toNot.beNil();
                expect(error).to.beNil();
            }];
            
            [sessionManager verify];
        });
        
        it(@"should send required parameters with convenience call", ^{
            VerifyGetPostWithParams(expectedParams, sessionManager, url);
            
            [service muteWithInstanceID:instanceId completion:^(NSDictionary *response, NSError *error) {
                expect(response).toNot.beNil();
                expect(error).to.beNil();
            }];
            
            [sessionManager verify];
        });
    });
});

SpecEnd
