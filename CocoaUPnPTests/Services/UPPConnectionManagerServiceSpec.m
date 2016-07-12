// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>
#import "NetworkTestHelpers.h"
#import "MockFailSessionManager.h"

SpecBegin(UPPConnectionManagerService)

describe(@"UPPConnectionManagerService", ^{

    __block UPPConnectionManagerService *service;
    __block id sessionManager;
    __block NSString *url;
    __block NSString *instanceId;
    __block UPPResponseBlock noCompletion;

    beforeEach(^{
        service = [[UPPConnectionManagerService alloc] init];
        service.serviceType = @"urn:schemas-upnp-org:service:ConnectionManager:1";

        sessionManager = [OCMockObject mockForClass:[UPPSessionManager class]];
        service.sessionManager = sessionManager;

        url = @"http://127.0.0.1/ctrl";
        NSURL *controlURL = [NSURL URLWithString:url];
        service.controlURL = controlURL;

        instanceId = @"0";

        // We exit early for all GET requests that do not provide a completion
        // block, so explicity create an "empty" completion block.
        noCompletion = ^(NSDictionary *d, NSError *e) {};
    });

    describe(@"when getting protocol info", ^{

        __block NSDictionary *expectedParams;

        beforeEach(^{
            expectedParams = @{ UPPSOAPActionKey: @"GetProtocolInfo",
                                UPPNameSpaceKey: service.serviceType };
        });

        it(@"should send required parameters", ^{
            ExpectGetWithParams(sessionManager, expectedParams, url);
            [service protocolInfoWithCompletion:noCompletion];
            [sessionManager verify];
        });

        it(@"should return an error if call fails", ^{
            ExpectAndReturnErrorWithParams(expectedParams, sessionManager, url);

            [service protocolInfoWithCompletion:^(NSDictionary *protocolInfo, NSError *error) {
                expect(protocolInfo).to.beNil();
                expect(error).toNot.beNil();
                expect(error.code).to.equal(UPPErrorCodeGeneric);
            }];

            [sessionManager verify];
        });
    });

    describe(@"when setting prepare for connection", ^{

        __block NSDictionary *expectedParams;
        __block NSString *remoteProtocolInfo;
        __block NSString *peerConnectionManager;
        __block NSString *peerConnectionId;
        __block NSString *direction;

        beforeEach(^{
            remoteProtocolInfo = @"remoteProtocolInfo";
            peerConnectionManager = @"peerConnectionManager";
            peerConnectionId = @"peerConnectionId";
            direction = @"direction";

            NSArray *k = @[ @"RemoteProtocolInfo",
                            @"PeerConnectionManager",
                            @"PeerConnectionID",
                            @"Direction" ];

            NSArray *v = @[ remoteProtocolInfo,
                            peerConnectionManager,
                            peerConnectionId,
                            direction ];

            UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];

            expectedParams = @{ UPPSOAPActionKey: @"PrepareForConnection",
                                UPPNameSpaceKey: service.serviceType,
                                UPPParametersKey: params };
        });

        it(@"should send required parameters", ^{
            ExpectGetWithParams(sessionManager, expectedParams, url);
            [service prepareForConnectionWithProtocolInfo:remoteProtocolInfo peerConnectionManager:peerConnectionManager peerConnectionID:peerConnectionId direction:direction completion:noCompletion];
            [sessionManager verify];
        });

        it(@"should return an error if call fails", ^{
            ExpectAndReturnErrorWithParams(expectedParams, sessionManager, url);

            [service prepareForConnectionWithProtocolInfo:remoteProtocolInfo peerConnectionManager:peerConnectionManager peerConnectionID:peerConnectionId direction:direction completion:^(NSDictionary *connectionInfo, NSError *error) {
                expect(connectionInfo).to.beNil();
                expect(error).toNot.beNil();
                expect(error.code).to.equal(UPPErrorCodeGeneric);
            }];

            [sessionManager verify];
        });
    });

    describe(@"when setting connection complete", ^{

        __block NSDictionary *expectedParams;
        __block NSString *peerConnectionId;

        beforeEach(^{
            peerConnectionId = @"peerConnectionId";

            UPPParameters *params = [UPPParameters paramsWithKey:@"ConnectionID"
                                                           value:peerConnectionId];

            expectedParams = @{ UPPSOAPActionKey: @"ConnectionComplete",
                                UPPNameSpaceKey: service.serviceType,
                                UPPParametersKey: params };
        });

        it(@"should send required parameters", ^{
            ExpectGetWithParams(sessionManager, expectedParams, url);
            [service connectionCompleteWithConnectionID:peerConnectionId success:^(BOOL success, NSError * _Nullable error) { }];
            [sessionManager verify];
        });

        it(@"should return an error if call fails", ^{
            service.sessionManager = [[MockFailSessionManager alloc] init];

            [service connectionCompleteWithConnectionID:peerConnectionId success:^(BOOL success, NSError *error) {
                expect(error).toNot.beNil();
                expect(error.code).to.equal(MockFailSessionErrorCode);
            }];
        });
    });

    describe(@"when getting current connection IDs", ^{

        __block NSDictionary *expectedParams;

        beforeEach(^{
            expectedParams = @{ UPPSOAPActionKey: @"GetCurrentConnectionIDs",
                                UPPNameSpaceKey: service.serviceType };
        });

        it(@"should send required parameters", ^{
            ExpectGetWithParams(sessionManager, expectedParams, url);
            [service currentConnectionIDsWithCompletion:noCompletion];
            [sessionManager verify];
        });
    });

    describe(@"when getting current connection info", ^{

        __block NSDictionary *expectedParams;
        __block NSString *connectionId;

        beforeEach(^{
            connectionId = @"connectionId";
            UPPParameters *params = [UPPParameters paramsWithKey:@"ConnectionID"
                                                           value:connectionId];
            expectedParams = @{ UPPSOAPActionKey: @"GetCurrentConnectionInfo",
                                UPPNameSpaceKey: service.serviceType,
                                UPPParametersKey: params };
        });

        it(@"should send required parameters", ^{
            ExpectGetWithParams(sessionManager, expectedParams, url);
            [service currentConnectionInfoWithConnectionID:connectionId completion:noCompletion];
            [sessionManager verify];
        });
    });
});

SpecEnd
