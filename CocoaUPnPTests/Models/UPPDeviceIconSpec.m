// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import <CocoaUPnP/CocoaUPnP.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

SpecBegin(UPPDeviceIcon)

describe(@"UPPDeviceIcon", ^{

    __block UPPDeviceIcon *icon;

    beforeEach(^{
        icon = [[UPPDeviceIcon alloc] init];
        icon.mimetype = @"mime";
        icon.width = @60;
        icon.height = @80;
        icon.depth = @24;
        icon.url = @"url";
    });

    it(@"should support setting mime type", ^{
        expect(icon.mimetype).to.equal(@"mime");
    });

    it(@"should support setting width", ^{
        expect(icon.width).to.equal(@60);
    });

    it(@"should support setting height", ^{
        expect(icon.height).to.equal(@80);
    });

    it(@"should support setting depth", ^{
        expect(icon.depth).to.equal(@24);
    });

    it(@"should support setting url", ^{
        expect(icon.url).to.equal(@"url");
    });

});

SpecEnd
