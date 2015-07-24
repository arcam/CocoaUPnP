// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPConnectionManagerService.h"
#import "UPPSessionManager.h"
#import "NetworkTestHelpers.h"
#import "UPPConstants.h"
#import "UPPError.h"
#import "MockFailSessionManager.h"

SpecBegin(UPPConnectionManagerService)

describe(@"UPPConnectionManagerService", ^{

    __block UPPConnectionManagerService *service;
    __block id sessionManager;
    __block NSString *url;
    __block NSString *instanceId;

    beforeEach(^{
        service = [[UPPConnectionManagerService alloc] init];
        service.serviceType = @"urn:schemas-upnp-org:service:ConnectionManager:1";

        sessionManager = OCMClassMock([UPPSessionManager class]);
        service.sessionManager = sessionManager;

        url = @"http://127.0.0.1/ctrl";
        NSURL *controlURL = [NSURL URLWithString:url];
        service.controlURL = controlURL;

        instanceId = @"0";
    });

    describe(@"when getting protocol info", ^{

        __block NSDictionary *expectedParams;

        beforeEach(^{
            expectedParams = @{ UPPSOAPActionKey: @"GetProtocolInfo",
                                UPPNameSpaceKey: service.serviceType };
        });

        it(@"should send required parameters", ^{
            VerifyGetPostWithParams(expectedParams, sessionManager, url);

            [service protocolInfoWithCompletion:^(NSDictionary *protocolInfo, NSError *error) {
                expect(protocolInfo[@"Hello"]).to.equal(@"World");
                expect(error).to.beNil();
            }];

            [sessionManager verify];
        });

        it(@"should return an error if call fails", ^{
            VerifyFailedGetPostWithParams(expectedParams, sessionManager, url);

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

        beforeEach(^{
            remoteProtocolInfo = @"remoteProtocolInfo";
            peerConnectionManager = @"peerConnectionManager";
            peerConnectionId = @"peerConnectionId";

            NSDictionary *params = @{ @"RemoteProtocolInfo": remoteProtocolInfo,
                                      @"PeerConnectionManager": peerConnectionManager,
                                      @"PeerConnectionID": peerConnectionId };

            expectedParams = @{ UPPSOAPActionKey: @"PrepareForConnection",
                                UPPNameSpaceKey: service.serviceType,
                                UPPParametersKey: params };
        });

        it(@"should send required parameters", ^{
            VerifyGetPostWithParams(expectedParams, sessionManager, url);

            [service prepareForConnectionWithProtocolInfo:remoteProtocolInfo peerConnectionManager:peerConnectionManager peerConnectionID:peerConnectionId completion:^(NSDictionary *connectionInfo, NSError *error) {
                expect(connectionInfo[@"Hello"]).to.equal(@"World");
                expect(error).to.beNil();
            }];

            [sessionManager verify];
        });

        it(@"should return an error if call fails", ^{
            VerifyFailedGetPostWithParams(expectedParams, sessionManager, url);

            [service prepareForConnectionWithProtocolInfo:remoteProtocolInfo peerConnectionManager:peerConnectionManager peerConnectionID:peerConnectionId completion:^(NSDictionary *connectionInfo, NSError *error) {
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

            NSDictionary *params = @{ @"ConnectionID": peerConnectionId };

            expectedParams = @{ UPPSOAPActionKey: @"ConnectionComplete",
                                UPPNameSpaceKey: service.serviceType,
                                UPPParametersKey: params };
        });

        it(@"should send required parameters", ^{
            VerifyPostWithParams(expectedParams, sessionManager, url);

            [service connectionCompleteWithConnectionID:peerConnectionId success:nil];

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
            VerifyGetPostWithParams(expectedParams, sessionManager, url);

            [service currentConnectionIDsWithCompletion:^(NSDictionary *response, NSError *error) {
                expect(response[@"Hello"]).to.equal(@"World");
                expect(error).to.beNil();
            }];

            [sessionManager verify];
        });
    });

    describe(@"when getting current connection info", ^{

        __block NSDictionary *expectedParams;
        __block NSString *connectionId;

        beforeEach(^{
            connectionId = @"connectionId";
            NSDictionary *params = @{ @"ConnectionID": connectionId };
            expectedParams = @{ UPPSOAPActionKey: @"GetCurrentConnectionInfo",
                                UPPNameSpaceKey: service.serviceType,
                                UPPParametersKey: params };
        });

        it(@"should send required parameters", ^{
            VerifyGetPostWithParams(expectedParams, sessionManager, url);

            [service currentConnectionInfoWithConnectionID:connectionId completion:^(NSDictionary *response, NSError *error) {
                expect(response[@"Hello"]).to.equal(@"World");
                expect(error).to.beNil();
            }];

            [sessionManager verify];
        });
    });
});

SpecEnd
