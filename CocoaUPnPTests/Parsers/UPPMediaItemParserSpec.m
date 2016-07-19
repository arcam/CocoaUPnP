// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <CocoaUPnP/CocoaUPnP.h>
#import <Ono/Ono.h>
#import "TestHelpers.h"

SpecBegin(UPPMediaItemParser)

describe(@"UPPMediaItemParser", ^{
    it(@"should parse an xml document of items", ^{
        NSData *data = LoadDataFromXML(@"Items", [self class]);
        expect(data).toNot.beNil();

        NSString *result = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];

        NSDictionary *results = @{ @"NumberReturned": @2,
                                   @"TotalMatches": @12,
                                   @"UpdateID": @0,
                                   @"Result": result };

        waitUntil(^(DoneCallback done) {
            [UPPMediaItemParser parseResults:results withCompletion:^(NSDictionary *results, NSError *error) {

                expect(error).to.beNil();
                NSArray *items = results[UPnPXMLResultsKey];
                expect(items).toNot.beNil();
                expect(items.count).to.equal(2);

                UPPMediaItem *item = [items firstObject];
                expect(item).toNot.beNil();
                expect(item.albumTitle).to.equal(@"Bloodstone & Diamonds");
                expect(item.artist).to.equal(@"Machine Head");
                expect(item.date).to.equal(@"2014-01-01");
                expect(item.genre).to.equal(@"Metal");
                expect(item.isContainer).to.equal(NO);
                expect(item.objectClass).to.equal(@"object.item.audioItem.musicTrack");
                expect(item.objectID).to.equal(@"29$34537$34555$@34555");
                expect(item.trackNumber).to.equal(@"1");
                expect(item.parentID).to.equal(@"29$34537$34555");
                expect(item.itemTitle).to.equal(@"Now We Die");
                expect(item.albumArtURLString).to.equal(@"http://127.0.0.1/art.jpg");

                expect(item.resources.count).to.equal(1);
                UPPMediaItemResource *resource = [item.resources firstObject];
                expect(resource).toNot.beNil();
                expect(resource.numberOfAudioChannels).to.equal(@"2");
                expect(resource.bitrate).to.equal(@"128875");
                expect(resource.duration).to.equal(@"0:07:10.000");
                expect(resource.sampleFrequency).to.equal(@"44100");
                expect(resource.protocolInfo).to.equal(@"http-get:*:audio/x-flac:*");
                expect(resource.itemSize).to.equal(@"55867243");
                expect(resource.resourceURLString).to.equal(@"http://10.54.6.186:50002/m/NDLNA/34555.flac");

                expect([item duration]).to.equal(@"0:07:10.000");
                expect([item durationInSeconds]).to.equal(430);

                expect(results[@"NumberReturned"]).to.equal(2);
                expect(results[@"TotalMatches"]).to.equal(12);
                expect(results[@"UpdateID"]).to.equal(0);

                done();

            }];
        });
    });

    it(@"should parse an xml document of containers", ^{
        NSData *data = LoadDataFromXML(@"Containers", [self class]);
        expect(data).toNot.beNil();

        NSString *result = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];

        NSDictionary *results = @{ @"NumberReturned": @2,
                                   @"TotalMatches": @307,
                                   @"UpdateID": @810,
                                   @"Result": result };

        waitUntil(^(DoneCallback done) {
            [UPPMediaItemParser parseResults:results withCompletion:^(NSDictionary *results, NSError *error) {

                expect(error).to.beNil();

                NSArray *items = results[UPnPXMLResultsKey];
                expect(items.count).to.equal(2);

                UPPMediaItem *item = [items firstObject];
                expect(item.isContainer).to.equal(YES);
                expect(item.objectID).to.equal(@"1$7$110");
                expect(item.parentID).to.equal(@"1$7");
                expect(item.childCount).to.equal(@"9");
                expect(item.itemTitle).to.equal(@"Above the Weeping World");
                expect(item.objectClass).to.equal(@"object.container.album.musicAlbum");
                expect(item.genre).to.equal(@"Death Metal");
                expect(item.artist).to.equal(@"Insomnium");
                expect(item.albumArtURLString).to.equal(@"http://127.0.0.1/799-4032.jpg");

                expect(results[@"NumberReturned"]).to.equal(2);
                expect(results[@"TotalMatches"]).to.equal(307);
                expect(results[@"UpdateID"]).to.equal(810);

                done();
            }];
        });
    });

    describe(@"when an error occurs", ^{
        it(@"should set empty data error", ^{
            waitUntil(^(DoneCallback done) {
                [UPPMediaItemParser parseResults:@{} withCompletion:^(NSDictionary *results, NSError *error) {
                    expect(results).to.beNil();
                    expect(error).toNot.beNil();
                    expect(error.code).to.equal(UPPErrorCodeEmptyData);

                    done();
                }];
            });
        });

        it(@"should set no item error", ^{
            waitUntil(^(DoneCallback done) {
                NSString *brokenResults = @"<DIDL-Lite></DIDL-Lite>";
                NSDictionary *results = @{ @"Result": brokenResults };

                [UPPMediaItemParser parseResults:results withCompletion:^(NSDictionary *results, NSError *error) {
                    expect(results).to.beNil();
                    expect(error).toNot.beNil();
                    expect(error.code).to.equal(UPPErrorCodeNoItemElementsFound);

                    done();
                }];
            });
        });
    });
});

SpecEnd
