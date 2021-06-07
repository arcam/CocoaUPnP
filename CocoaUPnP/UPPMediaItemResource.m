// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaItemResource.h"

@implementation UPPMediaItemResource

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.numberOfAudioChannels = [decoder decodeObjectForKey:@"numberOfAudioChannels"];
        self.bitsPerSample = [decoder decodeObjectForKey:@"bitsPerSample"];
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
    [encoder encodeObject:self.bitsPerSample forKey:@"bitsPerSample"];
    [encoder encodeObject:self.bitrate forKey:@"bitrate"];
    [encoder encodeObject:self.duration forKey:@"duration"];
    [encoder encodeObject:self.sampleFrequency forKey:@"sampleFrequency"];
    [encoder encodeObject:self.protocolInfo forKey:@"protocolInfo"];
    [encoder encodeObject:self.itemSize forKey:@"itemSize"];
    [encoder encodeObject:self.resourceURLString forKey:@"resourceURLString"];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    UPPMediaItemResource *newRes = [[[self class] alloc] init];
    newRes->_numberOfAudioChannels = [_numberOfAudioChannels copyWithZone:zone];
    newRes->_bitsPerSample = [_bitsPerSample copyWithZone:zone];
    newRes->_bitrate = [_bitrate copyWithZone:zone];
    newRes->_duration = [_duration copyWithZone:zone];
    newRes->_sampleFrequency = [_sampleFrequency copyWithZone:zone];
    newRes->_protocolInfo = [_protocolInfo copyWithZone:zone];
    newRes->_itemSize = [_itemSize copyWithZone:zone];
    newRes->_resourceURLString = [_resourceURLString copyWithZone:zone];
    return newRes;
}

@end
