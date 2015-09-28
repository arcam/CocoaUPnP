// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPBasicService.h"

/**
 BrowseMetadataFlag states that the properties of the object should be returned.
 */
extern NSString * const BrowseMetaDataFlag;

/**
 BrowseDirectChildrenFlag states that the direct children of the object will be
 returned in the result.
 */
extern NSString * const BrowseDirectChildren;

/**
 This class contains all the network calls needed for the UPnP [AVTransport1
 service](http://upnp.org/specs/av/UPnP-av-ContentDirectory-v1-Service.pdf).
 */
@interface UPPContentDirectoryService : UPPBasicService

/**
 Get the devices search capabilities

 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)searchCapabilitiesWithCompletion:(UPPResponseBlock)completion;

/**
 Get the devices sort capabilities

 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)sortCapabilitiesWithCompletion:(UPPResponseBlock)completion;

/**
 Get the devices system update ID

 @param completion A completion block which returns the parsed response, or an
     error if unsuccessful
 */
- (void)systemUpdateIDWithCompletion:(UPPResponseBlock)completion;


#pragma mark - Fetching Items

///-----------------------------------------------------------------------------
/// @name Fetching Items
///-----------------------------------------------------------------------------

/**
 Browse the content directory service

 @param objectId       The root object ID. A value of `0` corresponds to the
     root object of the content directory.
 @param browseFlag     The browse flag parameter.
 @param filter         The browse filter. Defaults to `*` which will return all
     properties.
 @param startingIndex  Starting index. Defaults to `0`.
 @param requestedCount Amount of objects to return. A value of `0` tells the
     service to return all entries. Defaults to `20`.
 @param sortCriteria   A comma separated list of signed property names, where
     signed means preceeded by `+` or `-` for ascending or descending order.
     Defaults to `+dc:title`.
 @param completion     A completion block which returns the parsed response, or
     an error if unsuccessful
 */
- (void)browseWithObjectID:(NSString *)objectId browseFlag:(NSString *)browseFlag filter:(NSString *)filter startingIndex:(NSNumber *)startingIndex requestedCount:(NSNumber *)requestedCount sortCritera:(NSString *)sortCriteria completion:(UPPResponseBlock)completion;

/**
 Search the content directory service

 @param containerId    The container object ID.
 @param searchCriteria The search criteria.
 @param filter         The browse filter. Defaults to `*` which will return all
     properties.
 @param startingIndex  Starting index. Defaults to `0`.
 @param requestedCount Amount of objects to return. A value of `0` tells the
     service to return all entries. Defaults to `20`.
 @param sortCriteria   A comma separated list of signed property names, where
     signed means preceeded by `+` or `-` for ascending or descending order.
     Defaults to `+dc:title`.
 @param completion     A completion block which returns the parsed response, or
     an error if unsuccessful
 */
- (void)searchWithContainerID:(NSString *)containerId searchCriteria:(NSString *)searchCriteria filter:(NSString *)filter startingIndex:(NSNumber *)startingIndex requestedCount:(NSNumber *)requestedCount sortCritera:(NSString *)sortCriteria completion:(UPPResponseBlock)completion;

@end
