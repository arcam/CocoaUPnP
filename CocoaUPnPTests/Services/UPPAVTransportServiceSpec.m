// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPAVTransportService.h"
#import "UPPSessionManager.h"
#import "MockFailSessionManager.h"

SpecBegin(UPPAVTransportService)

describe(@"UPPAVTransportService", ^{
    
    __block UPPAVTransportService *service;
    __block id sessionManager;
    __block NSURL *controlURL;
    
    beforeEach(^{
        service = [[UPPAVTransportService alloc] init];
        sessionManager = OCMClassMock([UPPSessionManager class]);
        service.sessionManager = sessionManager;
        controlURL = [NSURL URLWithString:@"http://127.0.0.1/ctrl"];
        service.controlURL = controlURL;
    });
    
    describe(@"when setting current transport URI", ^{
        
        __block NSString *instanceId;
        __block NSString *currentURI;
        __block NSString *currentURIMetaData;
        __block NSError *error;
        
        beforeEach(^{
            instanceId = @"0";
            currentURI = @"currentURI";
            currentURIMetaData = @"currentURIMetaData";
            error = nil;
        });
        
        it(@"should send parameters", ^{
            NSDictionary *expectedParams = @{ @"InstanceID" : instanceId,
                                              @"CurrentURI" : currentURI,
                                              @"CurrentURIMetaData" : currentURIMetaData };
            
            [[sessionManager expect] POST:[controlURL absoluteString] parameters:[OCMArg checkWithBlock:^BOOL(NSDictionary *parameters) {
                return [parameters isEqualToDictionary:expectedParams];
            }] success:nil failure:[OCMArg any]];
            
            [service setAVTransportURIWithInstanceID:instanceId
                                          currentURI:currentURI
                                  currentURIMetaData:currentURIMetaData
                                               error:&error];
            
            [sessionManager verify];
            expect(error).to.beNil();
        });
        
        it(@"should return set an error when call fails", ^{
            service.sessionManager = [[MockFailSessionManager alloc] init];
            
            [service setAVTransportURIWithInstanceID:instanceId
                                          currentURI:currentURI
                                  currentURIMetaData:currentURIMetaData
                                               error:&error];
            
            expect(error).toNot.beNil();
            expect(error.code).to.equal(MockFailSessionErrorCode);
        });
        
    });
    
});

SpecEnd
