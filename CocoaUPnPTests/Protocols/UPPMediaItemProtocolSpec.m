// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaItemProtocol.h"

SpecBegin(UPPMediaItemProtocol)

describe(@"UPPMediaItemProtocol", ^{
    
    __block id <UPPMediaItemProtocol> item;
    
    beforeEach(^{
        item = OCMProtocolMock(@protocol(UPPMediaItemProtocol));
    });
    
    it(@"should respond to -[albumTitle]", ^{
        expect(item).to.respondTo(@selector(albumTitle));
    });
    
    it(@"should respond to -[artist]", ^{
        expect(item).to.respondTo(@selector(artist));
    });
    
    it(@"should respond to -[date]", ^{
        expect(item).to.respondTo(@selector(date));
    });
    
    it(@"should respond to -[genre]", ^{
        expect(item).to.respondTo(@selector(genre));
    });
    
    it(@"should respond to -[isContainer]", ^{
        expect(item).to.respondTo(@selector(isContainer));
    });
    
    it(@"should respond to -[objectClass]", ^{
        expect(item).to.respondTo(@selector(objectClass));
    });
    
    it(@"should respond to -[objectID]", ^{
        expect(item).to.respondTo(@selector(objectID));
    });
    
    it(@"should respond to -[trackNumber]", ^{
        expect(item).to.respondTo(@selector(trackNumber));
    });
    
    it(@"should respond to -[parentID]", ^{
        expect(item).to.respondTo(@selector(parentID));
    });
    
    it(@"should respond to -[resources]", ^{
        expect(item).to.respondTo(@selector(resources));
    });
    
    it(@"should respond to -[itemTitle]", ^{
        expect(item).to.respondTo(@selector(itemTitle));
    });
    
    it(@"should respond to -[albumArtURL]", ^{
        expect(item).to.respondTo(@selector(albumArtURL));
    });
    
});

SpecEnd
