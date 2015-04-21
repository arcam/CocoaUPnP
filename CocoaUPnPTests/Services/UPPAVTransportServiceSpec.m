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
    __block NSString *instanceId;
    __block NSError *error;
    
    beforeEach(^{
        service = [[UPPAVTransportService alloc] init];
        sessionManager = OCMClassMock([UPPSessionManager class]);
        service.sessionManager = sessionManager;
        controlURL = [NSURL URLWithString:@"http://127.0.0.1/ctrl"];
        service.controlURL = controlURL;
        instanceId = @"0";
        error = nil;
    });
    
    describe(@"when setting current transport URI", ^{
        
        __block NSString *currentURI;
        __block NSString *currentURIMetaData;
        
        beforeEach(^{
            currentURI = @"currentURI";
            currentURIMetaData = @"currentURIMetaData";
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
    
    describe(@"when setting next transport URI", ^{
        
        __block NSString *nextURI;
        __block NSString *nextURIMetaData;
        
        beforeEach(^{
            nextURI = @"nextURI";
            nextURIMetaData = @"nextURIMetaData";
        });
        
        it(@"should send parameters", ^{
            NSDictionary *expectedParams = @{ @"InstanceID": instanceId,
                                              @"NextURI": nextURI,
                                              @"NextURIMetaData": nextURIMetaData };
            
            [[sessionManager expect] POST:[controlURL absoluteString] parameters:[OCMArg checkWithBlock:^BOOL(NSDictionary *parameters) {
                return [parameters isEqualToDictionary:expectedParams];
            }] success:nil failure:[OCMArg any]];
            
            [service setNextAVTransportURIWithInstanceID:instanceId
                                                 nextURI:nextURI
                                         nextURIMetaData:nextURIMetaData
                                                   error:&error];
            
            [sessionManager verify];
            expect(error).to.beNil();
        });
        
        it(@"should return set an error when call fails", ^{
            service.sessionManager = [[MockFailSessionManager alloc] init];
            
            [service setNextAVTransportURIWithInstanceID:instanceId
                                                 nextURI:nextURI
                                         nextURIMetaData:nextURIMetaData
                                                   error:&error];
            
            expect(error).toNot.beNil();
            expect(error.code).to.equal(MockFailSessionErrorCode);
        });
        
    });
});

SpecEnd
