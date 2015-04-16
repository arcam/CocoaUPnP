
#import "UPPMediaItemParser.h"
#import "Ono.h"
#import "UPPMediaItem.h"
#import "UPPMediaItemResource.h"

@interface UPPMediaItemParser ()
@property (strong, nonatomic) NSData *data;
@end

@implementation UPPMediaItemParser

- (instancetype)initWithXMLData:(NSData *)data
{
    self = [super init];
    
    if (self) {
        self.data = data;
    }
    
    return self;
}

- (void)parseWithCompletion:(UPPMediaItemCompletionBlock)completion
{
    if (!completion) {
        return;
    }
    
    NSError *error = nil;
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:self.data error:&error];
    
    if (!document) {
        completion(nil, nil, nil, nil, error);
        return;
    }
    
    NSNumber *resultsReturned = [[document firstChildWithXPath:@"//NumberReturned"] numberValue];
    NSNumber *totalResults = [[document firstChildWithXPath:@"//TotalMatches"] numberValue];
    NSNumber *updateID = [[document firstChildWithXPath:@"//UpdateID"] numberValue];
    
    NSString *results = [[document firstChildWithXPath:@"/u:BrowseResponse/Result"] stringValue];
    
    // The UPnP spec allows embedding XML in XML (!), as a result the inner XML
    // is declared using percent escaped characters. This is rediculous as it
    // means we have to separately parse it.
    //
    // Seriously. Why did you do this, XML forum?
    //
    NSData *newData = [results dataUsingEncoding:NSUTF8StringEncoding];
    ONOXMLDocument *didl = [ONOXMLDocument XMLDocumentWithData:newData error:&error];
    
    [didl definePrefix:@"didl" forDefaultNamespace:@"urn:schemas-upnp-org:metadata-1-0/DIDL-Lite/"];
    
    __block NSMutableArray *items;
    [didl enumerateElementsWithXPath:@"/didl:DIDL-Lite/*" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        
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
        
        __block NSMutableArray *resources;
        NSArray *res = [element childrenWithTag:@"res"];
        [res enumerateObjectsUsingBlock:^(ONOXMLElement *resource, NSUInteger idx, BOOL *stop) {
            
            UPPMediaItemResource *r = [[UPPMediaItemResource alloc] init];
            r.numberOfAudioChannels = [resource valueForAttribute:@"nrAudioChannels"];
            r.bitrate = [resource valueForAttribute:@"bitrate"];
            r.duration = [resource valueForAttribute:@"duration"];
            r.sampleFrequency = [resource valueForAttribute:@"sampleFrequency"];
            r.protocolInfo = [resource valueForAttribute:@"protocolInfo"];
            r.itemSize = [resource valueForAttribute:@"size"];
            r.resourceURLString = [resource stringValue];
            
            if (!resources) {
                resources = [NSMutableArray array];
            }
            
            [resources addObject:r];
        }];
        
        item.resources = resources;
        
        if (!items) {
            items = [NSMutableArray array];
        }
        
        [items addObject:item];
        
    }];
    
    completion(items, resultsReturned, totalResults, updateID, error);
}

@end
