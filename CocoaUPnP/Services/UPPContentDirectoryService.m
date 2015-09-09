// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPContentDirectoryService.h"
#import "UPPMediaItemParser.h"
#import "UPPParameters.h"

NSString * const BrowseMetaDataFlag = @"BrowseMetadata";
NSString * const BrowseDirectChildren = @"BrowseDirectChildren";
NSString * const UPPCDSObjectIDKey = @"ObjectID";
NSString * const UPPCDSBrowseFlagKey = @"BrowseFlag";
NSString * const UPPCDSContainerIDKey = @"ContainerID";
NSString * const UPPCDSSearchCriteriaKey = @"SearchCriteria";
NSString * const UPPCDSFilterKey = @"Filter";
NSString * const UPPCDSStartingIndexKey = @"StartingIndex";
NSString * const UPPCDSRequestedCountKey = @"RequestedCount";
NSString * const UPPCDSSortCriteriaKey = @"SortCriteria";

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

- (void)browseWithObjectID:(NSString *)objectId browseFlag:(NSString *)browseFlag filter:(NSString *)filter startingIndex:(NSNumber *)startingIndex requestedCount:(NSNumber *)requestedCount sortCritera:(NSString *)sortCriteria completion:(void (^)(NSDictionary *, NSError *))completion
{
    if (!completion) { return; }

    NSArray *k = @[ UPPCDSObjectIDKey,
                    UPPCDSBrowseFlagKey,
                    UPPCDSFilterKey,
                    UPPCDSStartingIndexKey,
                    UPPCDSRequestedCountKey,
                    UPPCDSSortCriteriaKey ];

    NSArray *v = @[ [self valueOrDefault:objectId forKey:UPPCDSObjectIDKey],
                    [self valueOrDefault:browseFlag forKey:UPPCDSBrowseFlagKey],
                    [self valueOrDefault:filter forKey:UPPCDSFilterKey],
                    [self valueOrDefault:startingIndex forKey:UPPCDSStartingIndexKey],
                    [self valueOrDefault:requestedCount forKey:UPPCDSRequestedCountKey],
                    [self valueOrDefault:sortCriteria forKey:UPPCDSSortCriteriaKey] ];

    UPPParameters *params = [UPPParameters paramsWithKeys:k
                                                   values:v];

    [self _sendPostRequestWithParameters:params action:@"Browse" completion:^(NSDictionary *responseObject, NSError *error) {

        if (responseObject) {
            [UPPMediaItemParser parseResults:responseObject withCompletion:^(NSDictionary *results, NSError *error) {
                completion(results, error);
            }];

        } else {
            completion(nil, error);
        }
    }];
}

- (id)valueOrDefault:(id)value forKey:(NSString *)key
{
    if (value) {
        return value;
    }

    return [self defaultValues][key] ?: @"";
}

- (NSDictionary *)defaultValues
{
    return @{ UPPCDSObjectIDKey: @"0",
              UPPCDSBrowseFlagKey: BrowseMetaDataFlag,
              UPPCDSFilterKey: @"*",
              UPPCDSStartingIndexKey: @0,
              UPPCDSRequestedCountKey: @20,
              UPPCDSSortCriteriaKey: @"",
              UPPCDSContainerIDKey: @"0" };
}

- (void)searchWithContainerID:(NSString *)containerId searchCriteria:(NSString *)searchCriteria filter:(NSString *)filter startingIndex:(NSNumber *)startingIndex requestedCount:(NSNumber *)requestedCount sortCritera:(NSString *)sortCriteria completion:(void (^)(NSDictionary *, NSError *))completion
{

    if (!completion) { return; }

    NSArray *keys = @[ UPPCDSContainerIDKey,
                       UPPCDSSearchCriteriaKey,
                       UPPCDSFilterKey,
                       UPPCDSStartingIndexKey,
                       UPPCDSRequestedCountKey,
                       UPPCDSSortCriteriaKey ];

    NSArray *values = @[ [self valueOrDefault:containerId forKey:UPPCDSContainerIDKey],
                         [self valueOrDefault:searchCriteria forKey:UPPCDSSearchCriteriaKey],
                         [self valueOrDefault:filter forKey:UPPCDSFilterKey],
                         [self valueOrDefault:startingIndex forKey:UPPCDSStartingIndexKey],
                         [self valueOrDefault:requestedCount forKey:UPPCDSRequestedCountKey],
                         [self valueOrDefault:sortCriteria forKey:UPPCDSSortCriteriaKey] ];

    UPPParameters *params = [UPPParameters paramsWithKeys:keys values:values];

    [self _sendPostRequestWithParameters:params action:@"Search" completion:^(NSDictionary *responseObject, NSError *error) {
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
