// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>
#import "NetworkTestHelpers.h"

SpecBegin(UPPContentDirectoryService)

describe(@"UPPContentDirectoryService", ^{

    __block UPPContentDirectoryService *service;
    __block id sessionManager;
    __block NSString *url;
    __block UPPResponseBlock noCompletion;

    beforeEach(^{
        service = [[UPPContentDirectoryService alloc] init];
        service.serviceType = @"urn:schemas-upnp-org:service:ContentDirectory:1";

        sessionManager = [OCMockObject mockForClass:[UPPSessionManager class]];
        service.sessionManager = sessionManager;

        url = @"http://127.0.0.1/ctrl";
        NSURL *controlURL = [NSURL URLWithString:url];
        service.controlURL = controlURL;

        // We exit early for all GET requests that do not provide a completion
        // block, so explicity create an "empty" completion block.
        noCompletion = ^(NSDictionary *d, NSError *e) {};
    });

    describe(@"when getting search capabilities", ^{
        it(@"should send required parameters", ^{
            NSDictionary *params = @{ UPPSOAPActionKey: @"GetSearchCapabilities",
                                      UPPNameSpaceKey: service.serviceType };

            ExpectGetWithParams(sessionManager, params, url);
            [service searchCapabilitiesWithCompletion:noCompletion];
            [sessionManager verify];
        });
    });

    describe(@"when getting sort capabilities", ^{
        it(@"should send required parameters", ^{
            NSDictionary *params = @{ UPPSOAPActionKey: @"GetSortCapabilities",
                                      UPPNameSpaceKey: service.serviceType };

            ExpectGetWithParams(sessionManager, params, url);
            [service sortCapabilitiesWithCompletion:noCompletion];
            [sessionManager verify];
        });
    });

    describe(@"when getting system update id", ^{
        it(@"should send required parameters", ^{
            NSDictionary *params = @{ UPPSOAPActionKey: @"GetSystemUpdateID",
                                      UPPNameSpaceKey: service.serviceType };

            ExpectGetWithParams(sessionManager, params, url);
            [service systemUpdateIDWithCompletion:noCompletion];
            [sessionManager verify];
        });
    });

    describe(@"when browsing directory", ^{
        __block NSArray *keys;

        beforeEach(^{
            keys = @[ @"ObjectID",
                      @"BrowseFlag",
                      @"Filter",
                      @"StartingIndex",
                      @"RequestedCount",
                      @"SortCriteria" ];
        });

        it(@"should send required parameters", ^{
            NSString *objectID = @"0";
            NSString *browseFlag = @"BrowseDirectChildren";
            NSString *filter = @"*";
            NSNumber *startingIndex = @0;
            NSNumber *requestedCount = @20;
            NSString *sortCriteria = @"+dc:title,+upnp:originalTrackNumber";

            NSArray *v = @[ objectID,
                            browseFlag,
                            filter,
                            startingIndex,
                            requestedCount,
                            sortCriteria ];

            UPPParameters *params = [UPPParameters paramsWithKeys:keys values:v];


            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Browse",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service browseWithObjectID:objectID browseFlag:BrowseDirectChildren filter:filter startingIndex:startingIndex requestedCount:requestedCount sortCritera:sortCriteria completion:noCompletion];

            [sessionManager verify];
        });

        it(@"should set sane defaults", ^{
            NSArray *v = @[ @"0", @"BrowseMetadata", @"*", @0, @20, @"" ];
            UPPParameters *params = [UPPParameters paramsWithKeys:keys values:v];
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Browse",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service browseWithObjectID:nil browseFlag:nil filter:nil startingIndex:nil requestedCount:nil sortCritera:nil completion:noCompletion];

            [sessionManager verify];
        });
    });

    describe(@"when searching directory", ^{
        __block NSArray *keys;

        beforeEach(^{
            keys = @[ @"ContainerID",
                      @"SearchCriteria",
                      @"Filter",
                      @"StartingIndex",
                      @"RequestedCount",
                      @"SortCriteria" ];
        });
        it(@"should send required parameters", ^{
            NSString *containerID = @"1$5";
            NSString *searchCriteria = @"(upnp:class derivedfrom \"object.item.audioItem.musicTrack\")";
            NSString *filter = @"+dc:creator";
            NSNumber *startingIndex = @42;
            NSNumber *requestedCount = @8;
            NSString *sortCriteria = @"+dc:title";

            NSArray *v = @[ containerID,
                            searchCriteria,
                            filter,
                            startingIndex,
                            requestedCount,
                            sortCriteria ];

            UPPParameters *params = [UPPParameters paramsWithKeys:keys values:v];

            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Search",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service searchWithContainerID:containerID searchCriteria:searchCriteria filter:filter startingIndex:startingIndex requestedCount:requestedCount sortCritera:sortCriteria completion:^(NSDictionary *response, NSError *error) {
                expect(response).toNot.beNil();
                expect(error).to.beNil();
            }];

            [sessionManager verify];
        });

        it(@"should set sane defaults", ^{
            NSArray *v = @[ @"0", @"", @"*", @0, @20, @"" ];

            UPPParameters *params = [UPPParameters paramsWithKeys:keys values:v];
            NSDictionary *expectedParams = @{ UPPSOAPActionKey: @"Search",
                                              UPPNameSpaceKey: service.serviceType,
                                              UPPParametersKey: params };

            ExpectGetWithParams(sessionManager, expectedParams, url);

            [service searchWithContainerID:nil searchCriteria:nil filter:nil startingIndex:nil requestedCount:nil sortCritera:nil completion:^(NSDictionary *response, NSError *error) { }];

            [sessionManager verify];
        });
    });
});

SpecEnd
