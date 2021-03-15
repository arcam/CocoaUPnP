// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>
#import "TestHelpers.h"

static UPPMediaItem * CreateMediaItem() {
    UPPMediaItem *item = [[UPPMediaItem alloc] init];
    item.objectID = @"22$01$01";
    item.parentID = @"22$01";
    item.itemTitle = @"Title";
    item.objectClass = @"object.item.audioItem.musicTrack";
    item.date = @"1977";
    item.albumTitle = @"Album";
    item.artist = @"Artist";
    item.genre = @"Rock & Roll";
    item.trackNumber = @"1";
    item.albumArtURLString = @"http://127.0.0.1/artwork_tn.jpg";

    UPPMediaItemResource *res1 = [[UPPMediaItemResource alloc] init];
    res1.protocolInfo = @"http-get:*:audio/mpeg:*";
    res1.itemSize = @"11032595";
    res1.bitrate = @"40000";
    res1.duration = @"0:04:33.000";
    res1.numberOfAudioChannels = @"2";
    res1.sampleFrequency = @"44100";
    res1.resourceURLString = @"http://127.0.0.1/res.mp3";

    UPPMediaItemResource *res2 = [[UPPMediaItemResource alloc] init];
    res2.protocolInfo = @"http-get:*:audio/x-flac:*";
    res2.itemSize = @"25325776";
    res2.bitrate = @"131875";
    res2.duration = @"0:03:10.000";
    res2.numberOfAudioChannels = @"2";
    res2.sampleFrequency = @"44100";
    res2.bitsPerSample = @"16";
    res2.resourceURLString = @"http://127.0.0.1/res.flac";

    item.resources = @[ res1, res2 ];

    return item;
};

SpecBegin(UPPMetadataHelper)

describe(@"UPPMetadataHelper", ^{
    it(@"should return metadata for an item", ^{
        UPPMediaItem *item = CreateMediaItem();
        NSData *xml = LoadDataFromXML(@"FullMetadata", [self class]);
        NSString *expected = [[NSString alloc] initWithData:xml
                                                   encoding:NSUTF8StringEncoding];
        // Tests fail when you don't trim new lines space from the XML.
        expected = [expected stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];

        NSString *metadata = UPPMetadataForItem(item);

        expect(metadata).toNot.beNil();
        expect(metadata).to.equal(expected);
    });
});

SpecEnd
