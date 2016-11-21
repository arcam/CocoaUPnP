// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>

SpecBegin(UPPMediaItemArtwork)

describe(@"UPPMediaItemArtwork", ^{

    __block UPPMediaItemArtwork *artwork;
    __block NSString *profileId = @"JPEG_MED";
    __block NSString *url = @"http://127.0.0.1/image.jpg";

    beforeEach(^{
        artwork = [[UPPMediaItemArtwork alloc] init];
        artwork.profileId = profileId;
        artwork.url = [NSURL URLWithString:url];
    });

    it(@"should allow setting profile ID", ^{
        expect(artwork.profileId).to.equal(profileId);
    });

    it(@"should allow setting url", ^{
        expect(artwork.url).to.equal([NSURL URLWithString:url]);
    });

    it(@"should use custom initialiser", ^{
        artwork = [[UPPMediaItemArtwork alloc] initWithURL:[NSURL URLWithString:url] profileId:profileId];
        expect(artwork.profileId).to.equal(profileId);
        expect(artwork.url).to.equal([NSURL URLWithString:url]);
    });

    describe(@"NSCopying", ^{
        it(@"should conform to NSCopying", ^{
            expect(artwork).to.conformTo(@protocol(NSCopying));
        });

        it(@"should implement copyWithZone", ^{
            UPPMediaItemArtwork *newArtwork = [artwork copy];
            expect(newArtwork).toNot.beIdenticalTo(artwork);
            expect(newArtwork.url).to.equal(artwork.url);
            expect(newArtwork.profileId).to.equal(artwork.profileId);
        });
    });
});

SpecEnd
