// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaItemParser.h"
#import "Ono.h"
#import "UPPMediaItem.h"
#import "UPPMediaItemResource.h"
#import "UPPError.h"
#import "ONOXMLDocument+StringValueOrNil.h"

NSString * const UPnPXMLResultsKey = @"Result";

@implementation UPPMediaItemParser

+ (void)parseResults:(NSDictionary *)results withCompletion:(void (^)(NSDictionary *results, NSError *error))completion
{
    NSParameterAssert(results);
    NSParameterAssert(completion);
    if (!results || !completion) { return; }

    NSString *resultsString = results[UPnPXMLResultsKey];

    if (!resultsString) {
        completion(nil, UPPErrorWithCode(UPPErrorCodeEmptyData));
        return;
    }

    NSError *error = nil;
    ONOXMLDocument *document = [ONOXMLDocument
                                XMLDocumentWithString:resultsString
                                encoding:NSUTF8StringEncoding error:&error];

    if (!document) {
        completion(nil, error);
        return;
    }

    NSArray *items = [self parseItemsInDocument:document];
    if (items.count > 0) {
        NSMutableDictionary *parsedResults = [results mutableCopy];
        [parsedResults setObject:items forKey:UPnPXMLResultsKey];
        completion([parsedResults copy], nil);
    } else {
        completion(nil, UPPErrorWithCode(UPPErrorCodeNoItemElementsFound));
    }
}

+ (NSArray *)parseItemsInDocument:(ONOXMLDocument *)document
{
    if (!document) { return @[]; }

    __block NSMutableArray *items = [NSMutableArray array];
    [document enumerateElementsWithXPath:@"/*[local-name() = 'DIDL-Lite']/*" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {

        UPPMediaItem *item = [[UPPMediaItem alloc] init];

        if ([[element tag] isEqualToString:@"container"]) {
            item.isContainer = YES;
            id childCount = [element valueForAttribute:@"childCount"];
            if (childCount) {
                item.childCount = [NSString stringWithFormat:@"%@",
                                   [element valueForAttribute:@"childCount"]];
            }
        }


        // Required parameters. If any of these are missing, then give up attempting to parse item.
        ONOXMLElement *objectClass = [element firstChildWithTag:@"class"];
        if (!objectClass) { return; }
        item.objectClass = [objectClass stringValue];

        ONOXMLElement *objectID = [element valueForAttribute:@"id"];
        if (!objectID) { return; }
        item.objectID = [NSString stringWithFormat:@"%@", objectID];

        ONOXMLElement *parentId = [element valueForAttribute:@"parentID"];
        if (!parentId) { return; }
        item.parentID = [NSString stringWithFormat:@"%@", parentId];

        ONOXMLElement *title = [element firstChildWithTag:@"title"];
        if (!title) { return; }
        item.itemTitle = [title stringValue];


        // Optional parameters. Ignore any missing keys.
        item.albumTitle = [[element firstChildWithTag:@"album"] stringValueOrNil];

        // Parse any <upnp:artist role> values
        NSMutableDictionary *roles = [[NSMutableDictionary alloc] init];
        for (ONOXMLElement *artist in [element childrenWithTag:@"artist"]) {
            NSString *artistValue = [artist stringValueOrNil];
            NSString *role = [artist attributes][@"role"];
            if (role && artistValue) {
                [roles setObject:artistValue forKey:role];
            } else {
                item.artist = artistValue;
            }
        }

        NSString *creator = [[element firstChildWithTag:@"creator"] stringValueOrNil];
        if (creator) {
            [roles setObject:creator forKey:@"creator"];
        }

        // Sometimes a server returns no top level <upnp:artist>, so pick the most likely
        // candidate from the parsed roles dictionary
        if (!item.artist) {
            item.artist = [self mostLikelyArtist:roles];
        }

        if (roles.count > 0) {
            item.artistRoles = [roles copy];
        }

        item.date = [[element firstChildWithTag:@"date"] stringValueOrNil];
        item.genre = [[element firstChildWithTag:@"genre"] stringValueOrNil];
        item.trackNumber = [[element firstChildWithTag:@"originalTrackNumber"] stringValueOrNil];
        item.resources = [self parseResources:[element childrenWithTag:@"res"]];

        item.artworkResources = [self artworkResources:[element childrenWithTag:@"albumArtURI"]];

        NSArray *durations = [item.resources valueForKey:@"duration"];
        [durations enumerateObjectsUsingBlock:^(NSString *duration, NSUInteger idx, BOOL *stop) {
            if (duration && ![duration isEqual:[NSNull null]]) {
                item.durationInSeconds = [self durationFromString:duration];
                *stop = YES;
            }
        }];

        [items addObject:item];
    }];

    return [items copy];
}

+ (NSArray *)parseResources:(NSArray *)res
{
    __block NSMutableArray *mutableResources;

    [res enumerateObjectsUsingBlock:^(ONOXMLElement *resource, NSUInteger idx, BOOL *stop) {
        UPPMediaItemResource *r = [[UPPMediaItemResource alloc] init];

        // Required parameters
        id protocolInfo = [resource valueForAttribute:@"protocolInfo"];
        if (!protocolInfo) { return; }
        r.protocolInfo = [NSString stringWithFormat:@"%@", protocolInfo];

        NSString *urlString = [resource stringValue];
        if ([urlString isEqualToString:@""]) { return; }
        r.resourceURLString = urlString;

        // Optional parameters
        r.numberOfAudioChannels = [resource stringForAttributeOrNil:@"nrAudioChannels"];
        r.bitrate = [resource stringForAttributeOrNil:@"bitrate"];
        r.duration = [resource stringForAttributeOrNil:@"duration"];
        r.sampleFrequency = [resource stringForAttributeOrNil:@"sampleFrequency"];
        r.itemSize = [resource stringForAttributeOrNil:@"size"];

        if (!mutableResources) {
            mutableResources = [NSMutableArray array];
        }

        [mutableResources addObject:r];
    }];

    return [mutableResources copy];
}

#pragma mark - Private

+ (NSArray *)artworkResources:(NSArray *)resources
{
    __block NSMutableArray *mutableResources = [NSMutableArray array];

    [resources enumerateObjectsUsingBlock:^(ONOXMLElement *resource, NSUInteger idx, BOOL * stop) {
        NSString *urlString = [resource stringValueOrNil];
        NSURL *url = [NSURL URLWithString:urlString];
        if (!url) { return; }
        NSString *profileID = [resource valueForAttribute:@"profileID"];
        UPPMediaItemArtwork *artwork = [[UPPMediaItemArtwork alloc] initWithURL:url
                                                                      profileId:profileID];
        [mutableResources addObject:artwork];
    }];

    return [mutableResources copy];
}

+ (NSInteger)durationFromString:(NSString *)string
{
    NSInteger seconds = 0;

    NSArray *components = [string componentsSeparatedByString:@":"];

    if ([components count] == 3) {
        // hh
        NSInteger hours = [(NSString *)components[0] integerValue];
        seconds += hours * 60 * 60;

        // mm
        NSInteger minutes = [(NSString *)components[1] integerValue];
        seconds += minutes * 60;

        // ss - actually a double
        seconds += [(NSString *)components[2] integerValue];
    }

    return seconds;
}

+ (NSString *)mostLikelyArtist:(NSDictionary *)artistRoles
{
    if (artistRoles.count == 0) {
        return nil;
    }

    if (artistRoles.count == 1) {
        return artistRoles.allValues.firstObject;
    }

    // Priority 1
    if (artistRoles[@"AlbumArtist"]) {
        return artistRoles[@"AlbumArtist"];
    }

    // Priority 2
    if (artistRoles[@"Performer"]) {
        return artistRoles[@"Performer"];
    }

    // Priority 3
    if (artistRoles[@"Composer"]) {
        return artistRoles[@"Composer"];
    }

    // Priority 4
    if (artistRoles[@"Creator"]) {
        return artistRoles[@"Creator"];
    }

    // Bail out
    return artistRoles.allValues.firstObject;
}

@end
