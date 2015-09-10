// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPConnectionManagerService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"
#import "UPPParameters.h"

@implementation UPPConnectionManagerService

- (void)protocolInfoWithCompletion:(void(^)(NSDictionary *protocolInfo, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:nil action:@"GetProtocolInfo" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)prepareForConnectionWithProtocolInfo:(NSString *)protocolInfo peerConnectionManager:(NSString *)peerConnectionManager peerConnectionID:(NSString *)peerConnectionId direction:(NSString *)direction completion:(void(^)(NSDictionary *connectionInfo, NSError *error))completion
{
    if (!completion) { return; }

    NSArray *k = @[ @"RemoteProtocolInfo",
                    @"PeerConnectionManager",
                    @"PeerConnectionID",
                    @"Direction" ];

    NSArray *v = @[ protocolInfo,
                    peerConnectionManager,
                    peerConnectionId,
                    direction ];

    UPPParameters *params = [UPPParameters paramsWithKeys:k values:v];

    [self _sendPostRequestWithParameters:params action:@"PrepareForConnection" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)connectionCompleteWithConnectionID:(NSString *)connectionId success:(void(^)(BOOL success, NSError *error))successBlock;
{
    UPPParameters *params = [UPPParameters paramsWithKey:@"ConnectionID"
                                                   value:connectionId];

    [self _sendPostRequestWithParameters:params
                                  action:@"ConnectionComplete"
                                 success:successBlock];
}

- (void)currentConnectionIDsWithCompletion:(void(^)(NSDictionary *response, NSError *error))completion
{
    if (!completion) { return; }

    [self _sendPostRequestWithParameters:nil action:@"GetCurrentConnectionIDs" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)currentConnectionInfoWithConnectionID:(NSString *)connectionId completion:(void(^)(NSDictionary *response, NSError *error))completion
{
    if (!completion) { return; }

    UPPParameters *params = [UPPParameters paramsWithKey:@"ConnectionID" value:connectionId];

    [self _sendPostRequestWithParameters:params action:@"GetCurrentConnectionInfo" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

@end
