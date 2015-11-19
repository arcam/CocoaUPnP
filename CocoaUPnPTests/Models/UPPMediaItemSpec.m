// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>

SpecBegin(UPPMediaItem)

describe(@"UPPMediaItem", ^{

    __block UPPMediaItem *mediaItem;
    __block NSString *url;
    __block UPPMediaItemResource *res;

    beforeEach(^{
        url = @"http://localhost/example.png";
        mediaItem = [[UPPMediaItem alloc] init];
        mediaItem.albumTitle = @"Title";
        mediaItem.artist = @"Artist";
        mediaItem.date = @"1994";
        mediaItem.genre = @"Rock";
        mediaItem.isContainer = YES;
        mediaItem.childCount = @"12";
        mediaItem.objectClass = @"class";
        mediaItem.objectID = @"asdf";
        mediaItem.trackNumber = @"10";
        mediaItem.parentID = @"sdfg";
        mediaItem.itemTitle = @"title";
        mediaItem.albumArtURLString = url;
        mediaItem.durationInSeconds = 123;

        res = [[UPPMediaItemResource alloc] init];
        res.numberOfAudioChannels = @"2";
        res.bitrate = @"bitrate";
        res.duration = @"duration";
        res.sampleFrequency = @"sample";
        res.protocolInfo = @"protocol";
        res.itemSize = @"size";
        res.resourceURLString = @"resource";
        mediaItem.resources = @[ res ];
    });

    it(@"should conform to UPPMediaItemProtocol", ^{
        expect(mediaItem).to.conformTo(@protocol(UPPMediaItemProtocol));
    });

    describe(@"duration helper method", ^{
        beforeEach(^{
            mediaItem.resources = nil;
        });

        it(@"should return nil with no resources", ^{
            expect(mediaItem.resources).to.beNil();

            expect([mediaItem duration]).to.beNil();
        });

        it(@"should return duration with a resource", ^{
            NSString *duration = @"0:12:34.567";
            UPPMediaItemResource *resource = [[UPPMediaItemResource alloc] init];
            resource.duration = duration;
            mediaItem.resources = @[ resource ];

            expect([mediaItem duration]).to.equal(duration);
        });

        it(@"should return nil with a resource that has no duration", ^{
            UPPMediaItemResource *resource = [[UPPMediaItemResource alloc] init];
            mediaItem.resources = @[ resource ];

            expect([mediaItem duration]).to.beNil();
        });
    });

    describe(@"first resource method", ^{
        it(@"should return a resource", ^{
            expect([mediaItem firstPlayableResource]).toNot.beNil();
        });

        it(@"should not return an image", ^{
            res = [[UPPMediaItemResource alloc] init];
            res.protocolInfo = @"http-get:*:image/jpeg:DLNA.ORG_PN=JPEG_TN";
            mediaItem.resources = @[ res ];

            expect([mediaItem firstPlayableResource]).to.beNil();
        });

        it(@"should find the first non image resource", ^{
            UPPMediaItemResource *imageRes = [[UPPMediaItemResource alloc] init];
            imageRes.protocolInfo = @"http-get:*:image/jpeg:DLNA.ORG_PN=JPEG_TN";

            UPPMediaItemResource *trackRes = [[UPPMediaItemResource alloc] init];
            trackRes.protocolInfo = @"http-get:*:audio/mpeg";

            UPPMediaItemResource *track2Res = [[UPPMediaItemResource alloc] init];
            track2Res.protocolInfo = @"http-get:*:audio/mpeg";

            mediaItem.resources = @[ imageRes, trackRes, track2Res ];

            expect([mediaItem firstPlayableResource]).to.beIdenticalTo(trackRes);
        });
    });

    describe(@"NSCoding", ^{
        it(@"should conform to NSCoding", ^{
            expect(mediaItem).to.conformTo(@protocol(NSCoding));
        });

        it(@"handle archive and unarchive", ^{
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mediaItem];
            UPPMediaItem *newItem = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            expect(newItem.albumTitle).to.equal(mediaItem.albumTitle);
            expect(newItem.artist).to.equal(mediaItem.artist);
            expect(newItem.date).to.equal(mediaItem.date);
            expect(newItem.genre).to.equal(mediaItem.genre);
            expect(newItem.isContainer).to.equal(mediaItem.isContainer);
            expect(newItem.childCount).to.equal(mediaItem.childCount);
            expect(newItem.objectClass).to.equal(mediaItem.objectClass);
            expect(newItem.objectID).to.equal(mediaItem.objectID);
            expect(newItem.trackNumber).to.equal(mediaItem.trackNumber);
            expect(newItem.parentID).to.equal(mediaItem.parentID);
            expect(newItem.itemTitle).to.equal(mediaItem.itemTitle);
            expect(newItem.albumArtURLString).to.equal(mediaItem.albumArtURLString);
            expect(newItem.durationInSeconds).to.equal(mediaItem.durationInSeconds);

            expect(newItem.resources.count).to.equal(1);
            UPPMediaItemResource *newRes = [newItem.resources firstObject];
            expect(newRes.numberOfAudioChannels).to.equal(res.numberOfAudioChannels);
            expect(newRes.bitrate).to.equal(res.bitrate);
            expect(newRes.duration).to.equal(res.duration);
            expect(newRes.sampleFrequency).to.equal(res.sampleFrequency);
            expect(newRes.protocolInfo).to.equal(res.protocolInfo);
            expect(newRes.itemSize).to.equal(res.itemSize);
            expect(newRes.resourceURLString).to.equal(res.resourceURLString);
        });
    });

    describe(@"NSCopying", ^{
        it(@"should conform to NSCopying", ^{
            expect(mediaItem).to.conformTo(@protocol(NSCopying));
        });

        it(@"should implement copyWithZone", ^{
            UPPMediaItem *newItem = [mediaItem copy];
            expect(newItem).toNot.beIdenticalTo(mediaItem);
            expect(newItem.albumTitle).to.equal(mediaItem.albumTitle);
            expect(newItem.artist).to.equal(mediaItem.artist);
            expect(newItem.date).to.equal(mediaItem.date);
            expect(newItem.genre).to.equal(mediaItem.genre);
            expect(newItem.isContainer).to.equal(mediaItem.isContainer);
            expect(newItem.childCount).to.equal(mediaItem.childCount);
            expect(newItem.objectClass).to.equal(mediaItem.objectClass);
            expect(newItem.objectID).to.equal(mediaItem.objectID);
            expect(newItem.trackNumber).to.equal(mediaItem.trackNumber);
            expect(newItem.parentID).to.equal(mediaItem.parentID);
            expect(newItem.itemTitle).to.equal(mediaItem.itemTitle);
            expect(newItem.albumArtURLString).to.equal(mediaItem.albumArtURLString);
            expect(newItem.durationInSeconds).to.equal(mediaItem.durationInSeconds);

            expect(newItem.resources.count).to.equal(1);
            UPPMediaItemResource *newRes = [newItem.resources firstObject];
            expect(newRes.numberOfAudioChannels).to.equal(res.numberOfAudioChannels);
            expect(newRes.bitrate).to.equal(res.bitrate);
            expect(newRes.duration).to.equal(res.duration);
            expect(newRes.sampleFrequency).to.equal(res.sampleFrequency);
            expect(newRes.protocolInfo).to.equal(res.protocolInfo);
            expect(newRes.itemSize).to.equal(res.itemSize);
            expect(newRes.resourceURLString).to.equal(res.resourceURLString);
        });
    });
});

SpecEnd
