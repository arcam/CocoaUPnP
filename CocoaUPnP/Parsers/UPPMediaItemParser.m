// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPMediaItemParser.h"
#import "Ono.h"
#import "UPPMediaItem.h"
#import "UPPMediaItemResource.h"
#import "UPPError.h"

NSString * const UPnPXMLResultsKey = @"Result";

@implementation UPPMediaItemParser

+ (void)parseResults:(NSDictionary *)results withCompletion:(void (^)(NSDictionary *results, NSError *error))completion
{
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
    if (items) {
        NSMutableDictionary *parsedResults = [results mutableCopy];
        [parsedResults setObject:items forKey:UPnPXMLResultsKey];
        completion([parsedResults copy], nil);
    } else {
        completion(nil, UPPErrorWithCode(UPPErrorCodeNoItemElementsFound));
    }
}

+ (NSArray *)parseItemsInDocument:(ONOXMLDocument *)document
{
    __block NSMutableArray *items;
    [document enumerateElementsWithXPath:@"/*[local-name() = 'DIDL-Lite']/*" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {

        UPPMediaItem *item = [[UPPMediaItem alloc] init];

        if ([[element tag] isEqualToString:@"container"]) {
            item.isContainer = YES;
            item.childCount = [element valueForAttribute:@"childCount"];
        }

        item.albumTitle = [[element firstChildWithTag:@"album"] stringValue];
        item.artist = [[element firstChildWithTag:@"artist"] stringValue];
        item.date = [[element firstChildWithTag:@"date"] stringValue];
        item.genre = [[element firstChildWithTag:@"genre"] stringValue];
        item.objectClass = [[element firstChildWithTag:@"class"] stringValue];
        item.trackNumber = [[element firstChildWithTag:@"originalTrackNumber"] stringValue];
        item.albumArtURLString = [[element firstChildWithTag:@"albumArtURI"] stringValue];
        item.itemTitle = [[element firstChildWithTag:@"title"] stringValue];
        item.parentID = [element valueForAttribute:@"parentID"];
        item.objectID = [element valueForAttribute:@"id"];
        item.resources = [self parseResources:[element childrenWithTag:@"res"]];

        NSArray *durations = [item.resources valueForKey:@"duration"];
        [durations enumerateObjectsUsingBlock:^(NSString *duration, NSUInteger idx, BOOL *stop) {
            if (duration && ![duration isEqual:[NSNull null]]) {
                item.durationInSeconds = [self durationFromString:duration];
                *stop = YES;
            }
        }];

        if (!items) {
            items = [NSMutableArray array];
        }

        [items addObject:item];
    }];

    return [items copy];
}

+ (NSArray *)parseResources:(NSArray *)res
{
    __block NSMutableArray *mutableResources;

    [res enumerateObjectsUsingBlock:^(ONOXMLElement *resource, NSUInteger idx, BOOL *stop) {
        UPPMediaItemResource *r = [[UPPMediaItemResource alloc] init];
        r.numberOfAudioChannels = [resource valueForAttribute:@"nrAudioChannels"];
        r.bitrate = [resource valueForAttribute:@"bitrate"];
        r.duration = [resource valueForAttribute:@"duration"];
        r.sampleFrequency = [resource valueForAttribute:@"sampleFrequency"];
        r.protocolInfo = [resource valueForAttribute:@"protocolInfo"];
        r.itemSize = [resource valueForAttribute:@"size"];
        r.resourceURLString = [resource stringValue];

        if (!mutableResources) {
            mutableResources = [NSMutableArray array];
        }

        [mutableResources addObject:r];
    }];

    return [mutableResources copy];
}

#pragma mark - Private

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

@end
