// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaItemResource.h"

@implementation UPPMediaItemResource

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.numberOfAudioChannels = [decoder decodeObjectForKey:@"numberOfAudioChannels"];
        self.bitrate = [decoder decodeObjectForKey:@"bitrate"];
        self.duration = [decoder decodeObjectForKey:@"duration"];
        self.sampleFrequency = [decoder decodeObjectForKey:@"sampleFrequency"];
        self.protocolInfo = [decoder decodeObjectForKey:@"protocolInfo"];
        self.itemSize = [decoder decodeObjectForKey:@"itemSize"];
        self.resourceURLString = [decoder decodeObjectForKey:@"resourceURLString"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.numberOfAudioChannels forKey:@"numberOfAudioChannels"];
    [encoder encodeObject:self.bitrate forKey:@"bitrate"];
    [encoder encodeObject:self.duration forKey:@"duration"];
    [encoder encodeObject:self.sampleFrequency forKey:@"sampleFrequency"];
    [encoder encodeObject:self.protocolInfo forKey:@"protocolInfo"];
    [encoder encodeObject:self.itemSize forKey:@"itemSize"];
    [encoder encodeObject:self.resourceURLString forKey:@"resourceURLString"];
}

@end
