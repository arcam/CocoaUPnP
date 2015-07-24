// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicService.h"

/**
 This class contains all the network calls needed for the UPnP [AVTransport1
 service](http://upnp.org/specs/av/UPnP-av-ConnectionManager-v1-Service.pdf).
 */
@interface UPPConnectionManagerService : UPPBasicService

/**
 Get the protocol-related information that the ConnectionManager supports

 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)protocolInfoWithCompletion:(void(^)(NSDictionary *protocolInfo, NSError *error))completion;

/**
 Tell device to prepare to connect to the network. See 2.4.2 of the service
 template document

 @param protocolInfo          The protocol info that should be used to transfer
     the content
 @param peerConnectionManager The connection manager
 @param peerConnectionId      The connection identifier
 @param completion            A completion block which returns the parsed
     information, or an error if unsuccessful
 */
- (void)prepareForConnectionWithProtocolInfo:(NSString *)protocolInfo peerConnectionManager:(NSString *)peerConnectionManager peerConnectionID:(NSString *)peerConnectionId completion:(void(^)(NSDictionary *connectionInfo, NSError *error))completion;

/**
 Inform the device that connection is complete. See 2.4.3 of the service template
 document

 @param connectionId The connection identifier
 @param success      An optional block which returns the success state of the
 call, along with an error object if the call was unsuccessful.

 */
- (void)connectionCompleteWithConnectionID:(NSString *)connectionId success:(void(^)(BOOL success, NSError *error))successBlock;

/**
 Get current connection IDs. See 2.4.4 of the service template

 @param completion A completion block which returns the parsed information, or
     an error if unsuccessful
 */
- (void)currentConnectionIDsWithCompletion:(void(^)(NSDictionary *response, NSError *error))completion;

/**
 Get current connection info. See 2.4.4 of the service template

 @param connectionId The connection identifier
 @param completion   A completion block which returns the parsed information, or
     an error if unsuccessful
 */
- (void)currentConnectionInfoWithConnectionID:(NSString *)connectionId completion:(void(^)(NSDictionary *response, NSError *error))completion;

@end
