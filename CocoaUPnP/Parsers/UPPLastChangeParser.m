// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPLastChangeParser.h"
#import "Ono.h"
#import "UPPError.h"
#import "UPPMediaItemParser.h"

@implementation UPPLastChangeParser

+ (void)parseData:(NSData *)data completion:(void (^)(NSDictionary *event, NSError *error))completion;
{
    NSParameterAssert(completion);
    if (!completion) { return; }

    if (!data) {
        completion(nil, UPPErrorWithCode(UPPErrorCodeEmptyData));
        return;
    }

    NSError *error = nil;
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:data error:&error];

    if (!document) {
        completion(nil, error);
    }

    ONOXMLElement *element = [document firstChildWithXPath:@"/e:propertyset/e:property/LastChange"];
    __block NSMutableDictionary *responseDictionary = [NSMutableDictionary dictionary];

    ONOXMLDocument *lastChange = [ONOXMLDocument XMLDocumentWithString:[element stringValue] encoding:NSUTF8StringEncoding error:nil];

    NSString *namespace = @"urn:schemas-upnp-org:metadata-1-0/AVT/";
    [lastChange definePrefix:@"a" forDefaultNamespace:namespace];

    [lastChange enumerateElementsWithXPath:@"//a:Event/a:InstanceID/*" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSString *tag = element.tag;
        NSString *value = [element valueForAttribute:@"val"];

        if ([tag rangeOfString:@"MetaData"].location != NSNotFound) {
            ONOXMLDocument *metadata = [ONOXMLDocument XMLDocumentWithString:value encoding:NSUTF8StringEncoding error:nil];
            NSArray *items = [UPPMediaItemParser parseItemsInDocument:metadata];

            if (items.count > 0) {
                responseDictionary[tag] = [items firstObject];
            }
        } else {
            if (value.length == 0) {
                value = [element stringValue];
            }
            
            if (tag && value) {
                responseDictionary[tag] = value;
            }
        }
    }];

    completion([responseDictionary copy], nil);
}

@end
