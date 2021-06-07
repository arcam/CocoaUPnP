// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMetadataHelper.h"
#import "UPPMediaItem.h"
#import "NSMutableString+xmlNode.h"
#import "UPPMediaItemResource.h"

NSString * UPPMetadataForItem (UPPMediaItem *item) {
    NSMutableString *metadata = [NSMutableString string];

    [metadata appendString:@"&lt;?xml version=\"1.0\"?&gt;&lt;DIDL-Lite xmlns=\"urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:upnp=\"urn:schemas-upnp-org:metadata-1-0/upnp/\" xmlns:dlna=\"urn:schemas-dlna-org:metadata-1-0/\"&gt;"];

    NSString *objectID = [NSString stringWithFormat:@"%@", item.objectID];
    NSString *parentID = [NSString stringWithFormat:@"%@", item.parentID];
    [metadata appendString:@"&lt;item "];
    [metadata appendFormat:@"id=\"%@\" ", [objectID stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;amp;"] ?: @"1"];
    [metadata appendFormat:@"parentID=\"%@\" ", [parentID stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;amp;"] ?: @"1"];
    [metadata appendString:@"restricted=\"1\"&gt;"];
    [metadata upp_appendValue:item.itemTitle forKey:@"dc:title"];
    [metadata upp_appendValue:item.objectClass forKey:@"upnp:class"];
    [metadata upp_appendValue:item.date forKey:@"dc:date"];
    [metadata upp_appendValue:item.albumTitle forKey:@"upnp:album"];
    [metadata upp_appendValue:item.artist forKey:@"upnp:artist"];
    [metadata upp_appendValue:item.artist forKey:@"dc:creator"];
    [metadata upp_appendValue:item.genre forKey:@"upnp:genre"];
    [metadata upp_appendValue:item.trackNumber forKey:@"upnp:originalTrackNumber"];
    [metadata upp_appendValue:item.albumArtURLString forKey:@"upnp:albumArtURI"];

    for (UPPMediaItemResource *res in item.resources) {
        [metadata appendString:@"&lt;res"];
        [metadata upp_appendValue:res.protocolInfo forAttribute:@"protocolInfo"];
        [metadata upp_appendValue:res.itemSize forAttribute:@"size"];
        [metadata upp_appendValue:res.bitrate forAttribute:@"bitrate"];
        [metadata upp_appendValue:res.duration forAttribute:@"duration"];
        [metadata upp_appendValue:res.numberOfAudioChannels forAttribute:@"nrAudioChannels"];
        [metadata upp_appendValue:res.sampleFrequency forAttribute:@"sampleFrequency"];
        [metadata upp_appendValue:res.bitsPerSample forAttribute:@"bitsPerSample"];
        [metadata appendFormat:@"&gt;%@&lt;/res&gt;", res.resourceURLString];
    }

    [metadata appendString:@"&lt;/item&gt;&lt;/DIDL-Lite&gt;"];

    return [metadata copy];
}
