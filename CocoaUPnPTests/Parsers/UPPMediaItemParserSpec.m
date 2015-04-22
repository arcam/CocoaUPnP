// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "Specta.h"
#import "UPPMediaItemParser.h"
#import "UPPMediaItem.h"
#import "UPPMediaItemResource.h"
#import "UPPError.h"

SpecBegin(UPPMediaItemParser)

describe(@"UPPMediaItemParser", ^{
    
    __block UPPMediaItemParser *parser;
    
    it(@"should parse an xml document of items", ^{
        
        NSData *data = LoadDataFromXML(@"Items", [self class]);
        expect(data).toNot.beNil();
        parser = [[UPPMediaItemParser alloc] initWithXMLData:data];

        waitUntil(^(DoneCallback done) {
            
            [parser parseWithCompletion:^(NSArray *items, NSNumber *resultsReturned, NSNumber *totalResults, NSNumber *updateID, NSError *error) {
                
                expect(error).to.beNil();
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
                
                expect(resultsReturned).to.equal(2);
                expect(totalResults).to.equal(12);
                expect(updateID).to.equal(0);
                
                done();
                
            }];
            
        });
        
    });
    
    it(@"should parse an xml document of containers", ^{
        
        NSData *data = LoadDataFromXML(@"Containers", [self class]);
        expect(data).toNot.beNil();
        parser = [[UPPMediaItemParser alloc] initWithXMLData:data];
        
        waitUntil(^(DoneCallback done) {
            
            [parser parseWithCompletion:^(NSArray *items, NSNumber *resultsReturned, NSNumber *totalResults, NSNumber *updateID, NSError *error) {
                
                expect(error).to.beNil();
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
                
                expect(resultsReturned).to.equal(2);
                expect(totalResults).to.equal(307);
                expect(updateID).to.equal(810);
                
                done();
            }];
            
        });
        
    });

    it(@"should exit early with no data", ^{
        parser = [[UPPMediaItemParser alloc] initWithXMLData:nil];
        waitUntil(^(DoneCallback done) {
            [parser parseWithCompletion:^(NSArray *items, NSNumber *resultsReturned, NSNumber *totalResults, NSNumber *updateID, NSError *error) {
                expect(items).to.beNil();
                expect(resultsReturned).to.beNil();
                expect(totalResults).to.beNil();
                expect(error).toNot.beNil();
                expect(error.code).to.equal(UPPErrorCodeEmptyData);
            }];
            done();
        });
    });
});

SpecEnd
