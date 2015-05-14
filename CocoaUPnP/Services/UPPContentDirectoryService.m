// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPContentDirectoryService.h"
#import "UPPMediaItemParser.h"

@implementation UPPContentDirectoryService

- (void)searchCapabilitiesWithCompletion:(void(^)(NSDictionary *response, NSError *error))completion
{
    if (!completion) { return; }
    
    [self _sendPostRequestWithParameters:nil action:@"GetSearchCapabilities" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)sortCapabilitiesWithCompletion:(void (^)(NSDictionary *, NSError *))completion
{
    if (!completion) { return; }
    
    [self _sendPostRequestWithParameters:nil action:@"GetSortCapabilities" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)systemUpdateIDWithCompletion:(void (^)(NSDictionary *, NSError *))completion
{
    if (!completion) { return; }
    
    [self _sendPostRequestWithParameters:nil action:@"GetSystemUpdateID" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

- (void)browseWithObjectID:(NSString *)objectId browseFlag:(UPPBrowseFlag)browseFlag filter:(NSString *)filter startingIndex:(NSNumber *)startingIndex requestedCount:(NSNumber *)requestedCount sortCritera:(NSString *)sortCriteria completion:(void (^)(NSDictionary *, NSError *))completion
{
    if (!completion) { return; }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (objectId) {
        [parameters setObject:objectId forKey:@"ObjectID"];
    } else {
        [parameters setObject:@0 forKey:@"ObjectID"];
    }
    
    if (browseFlag == BrowseDirectChildren) {
        [parameters setObject:@"BrowseDirectChildren" forKey:@"BrowseFlag"];
    } else {
        [parameters setObject:@"BrowseMetadata" forKey:@"BrowseFlag"];
    }
    
    [self _addValuesToParams:&parameters
                      filter:filter
               startingIndex:startingIndex
              requestedCount:requestedCount
                sortCriteria:sortCriteria];
    
    [self _sendPostRequestWithParameters:parameters action:@"Browse" completion:^(NSDictionary *responseObject, NSError *error) {
        
        if (responseObject) {
            [UPPMediaItemParser parseResults:responseObject withCompletion:^(NSDictionary *results, NSError *error) {
                completion(results, error);
            }];
            
        } else {
            completion(nil, error);
        }
    }];
}

- (void)searchWithContainerID:(NSString *)containerId searchCriteria:(NSString *)searchCriteria filter:(NSString *)filter startingIndex:(NSNumber *)startingIndex requestedCount:(NSNumber *)requestedCount sortCritera:(NSString *)sortCriteria completion:(void (^)(NSDictionary *, NSError *))completion
{
    
    if (!completion) { return; }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (containerId) {
        [parameters setObject:containerId forKey:@"ContainerID"];
    } else {
        [parameters setObject:@0 forKey:@"ContainerID"];
    }
    
    if (searchCriteria) {
        [parameters setObject:searchCriteria forKey:@"SearchCriteria"];
    } else {
        [parameters setObject:@"" forKey:@"SearchCriteria"];
    }
    
    [self _addValuesToParams:&parameters
                      filter:filter
               startingIndex:startingIndex
              requestedCount:requestedCount
                sortCriteria:sortCriteria];
    
    [self _sendPostRequestWithParameters:parameters action:@"Search" completion:^(NSDictionary *responseObject, NSError *error) {
        completion(responseObject, error);
    }];
}

#pragma mark - Private Methods

- (void)_addValuesToParams:(NSMutableDictionary **)parameters filter:(NSString *)filter startingIndex:(NSNumber *)startingIndex requestedCount:(NSNumber *)requestedCount sortCriteria:(NSString *)sortCriteria
{
    if (filter) {
        [*parameters setObject:filter forKey:@"Filter"];
    } else {
        [*parameters setObject:@"*" forKey:@"Filter"];
    }
    
    if (startingIndex) {
        [*parameters setObject:startingIndex forKey:@"StartingIndex"];
    } else {
        [*parameters setObject:@0 forKey:@"StartingIndex"];
    }
    
    if (requestedCount) {
        [*parameters setObject:requestedCount forKey:@"RequestedCount"];
    } else {
        [*parameters setObject:@20 forKey:@"RequestedCount"];
    }
    
    if (sortCriteria) {
        [*parameters setObject:sortCriteria forKey:@"SortCriteria"];
    } else {
        [*parameters setObject:@"" forKey:@"SortCriteria"];
    }
}

@end
