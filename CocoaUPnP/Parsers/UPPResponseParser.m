// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPResponseParser.h"
#import "Ono.h"
#import "UPPError.h"
#import "UPPMediaItemParser.h"

@implementation UPPResponseParser

- (void)parseWithResponse:(Response)responseBlock
{
    NSParameterAssert(responseBlock);
    if (!responseBlock) { return; }

    NSError *error = nil;

    if (![self data]) {
        responseBlock(nil, UPPErrorWithCode(UPPErrorCodeEmptyData));
        return;
    }

    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:self.data error:&error];

    if (!document) {
        responseBlock(nil, error);
        return;
    }

    __block NSMutableDictionary *responseDictionary;

    [document enumerateElementsWithXPath:@"/*[local-name() = 'Envelope']/*[local-name() = 'Body']/*/*" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {

        if (!responseDictionary) {
            responseDictionary = [NSMutableDictionary dictionary];
        }

        NSString *tag = element.tag;
        NSString *value = [element stringValue];

        if (tag && value) {
            if ([tag rangeOfString:@"MetaData"].location != NSNotFound) {
                ONOXMLDocument *metadata = [ONOXMLDocument XMLDocumentWithString:value encoding:NSUTF8StringEncoding error:nil];
                NSArray *items = [UPPMediaItemParser parseItemsInDocument:metadata];

                if (items.count > 0) {
                    responseDictionary[tag] = [items firstObject];
                }
            } else {
                responseDictionary[tag] = value;
            }
        }

    }];

    responseBlock(responseDictionary, nil);
}

@end
