// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPConnectionManagerService.h"
#import "UPPSessionManager.h"
#import "UPPConstants.h"

@implementation UPPConnectionManagerService

- (void)protocolInfoWithCompletion:(void(^)(NSDictionary *protocolInfo, NSError *error))completion
{
    if (!completion) { return; }
    
    [self _sendPostRequestWithParameters:nil action:@"GetProtocolInfo" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)prepareForConnectionWithProtocolInfo:(NSString *)protocolInfo peerConnectionManager:(NSString *)peerConnectionManager peerConnectionID:(NSString *)peerConnectionId completion:(void(^)(NSDictionary *connectionInfo, NSError *error))completion
{
    if (!completion) { return; }
    
    NSDictionary *parameters = @{ @"RemoteProtocolInfo": protocolInfo,
                                  @"PeerConnectionManager": peerConnectionManager,
                                  @"PeerConnectionID": peerConnectionId };
    
    [self _sendPostRequestWithParameters:parameters action:@"PrepareForConnection" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)connectionCompleteWithConnectionID:(NSString *)connectionId error:(NSError *__autoreleasing *)error
{
    NSDictionary *parameters = @{ @"ConnectionID": connectionId };
    
    [self _sendPostRequestWithInstanceID:nil action:@"ConnectionComplete" parameters:parameters error:error];
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
    
    NSDictionary *parameters = @{ @"ConnectionID": connectionId };
    
    [self _sendPostRequestWithParameters:parameters action:@"GetCurrentConnectionInfo" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

@end
