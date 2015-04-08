#import "UPPMediaItem.h"

SpecBegin(UPPMediaItem)

describe(@"UPPMediaItem", ^{
    
    __block UPPMediaItem *mediaItem;
    __block NSString *url;
    
    beforeEach(^{
        mediaItem = [[UPPMediaItem alloc] init];
        url = @"http://localhost/example.png";
    });
    
    it(@"should conform to UPPMediaItemProtocol", ^{
        expect(mediaItem).to.conformTo(@protocol(UPPMediaItemProtocol));
    });
    
    it(@"should allow setting an album title", ^{
        NSString *string = @"Title";
        mediaItem.albumTitle = string;
        expect(mediaItem.albumTitle).to.equal(string);
    });
    
    it(@"should allow setting an artist", ^{
        NSString *string = @"Artist";
        mediaItem.artist = string;
        expect(mediaItem.artist).to.equal(string);
    });
    
    it(@"should allow setting number of audio channels", ^{
        NSString *string = @"2";
        mediaItem.numberOfAudioChannels = string;
        expect(mediaItem.numberOfAudioChannels).to.equal(string);
    });
   
    it(@"should allow setting bitrate", ^{
        NSString *string = @"40000";
        mediaItem.bitrate = string;
        expect(mediaItem.bitrate).to.equal(string);
    });
    
    it(@"should allow setting date", ^{
        NSString *string = @"1994";
        mediaItem.date = string;
        expect(mediaItem.date).to.equal(string);
    });
    
    it(@"should allow setting duration", ^{
        NSString *string = @"00:01:37";
        mediaItem.duration = string;
        expect(mediaItem.duration).to.equal(string);
    });
    
    it(@"should allow setting sample frequency", ^{
        NSString *string = @"44100";
        mediaItem.sampleFrequency = string;
        expect(mediaItem.sampleFrequency).to.equal(string);
    });
    
    it(@"should allow setting genre", ^{
        NSString *string = @"Rock";
        mediaItem.genre = string;
        expect(mediaItem.genre).to.equal(string);
    });
    
    it(@"should return an icon URL", ^{
        mediaItem.iconURLString = url;
        expect(mediaItem.iconURL.absoluteString).to.equal(url);
    });
    
    it(@"should state if it is a container", ^{
        mediaItem.isContainer = YES;
        expect(mediaItem.isContainer).to.equal(YES);
    });
    
    it(@"should allow object class", ^{
        NSString *string = @"class";
        mediaItem.objectClass = string;
        expect(mediaItem.objectClass).to.equal(string);
    });
    
    it(@"should allow setting object identifier", ^{
        NSString *string = @"asdf";
        mediaItem.objectID = string;
        expect(mediaItem.objectID).to.equal(string);
    });
    
    it(@"should allow setting track number", ^{
        NSString *string = @"10";
        mediaItem.trackNumber = string;
        expect(mediaItem.trackNumber).to.equal(string);
    });
    
    it(@"should allow setting parent identifier", ^{
        NSString *string = @"sdfg";
        mediaItem.parentID = string;
        expect(mediaItem.parentID).to.equal(string);
    });
    
    it(@"should allow setting protocol info", ^{
        NSString *string = @"protocol";
        mediaItem.protocolInfo = string;
        expect(mediaItem.protocolInfo).to.equal(string);
    });
    
    it(@"should allow setting a number of resources", ^{
        NSString *string = @"resource";
        NSArray *resources = @[ string, string ];
        mediaItem.resources = resources;
        expect(mediaItem.resources).to.equal(resources);
    });
    
    it(@"should allow setting item size", ^{
        NSString *string = @"24000000";
        mediaItem.itemSize = string;
        expect(mediaItem.itemSize).to.equal(string);
    });
    
    it(@"should allow setting item title", ^{
        NSString *string = @"title";
        mediaItem.itemTitle = string;
        expect(mediaItem.itemTitle).to.equal(string);
    });

    it(@"should return an album art URL", ^{
        mediaItem.albumArtURLString = url;
        expect(mediaItem.albumArtURL.absoluteString).to.equal(url);
    });
    
    it(@"should return a resource URL", ^{
        mediaItem.resourceURLString = url;
        expect(mediaItem.resourceURL.absoluteString).to.equal(url);
    });
    
});

SpecEnd
