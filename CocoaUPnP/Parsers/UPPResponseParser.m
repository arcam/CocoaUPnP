// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPResponseParser.h"
#import "Ono.h"
#import "UPPError.h"

@interface UPPResponseParser ()
@property (strong, nonatomic) NSData *data;
@end

@implementation UPPResponseParser

- (instancetype)initWithXMLData:(NSData *)data
{
    self = [super init];
    
    if (self) {
        self.data = data;
    }
    
    return self;
}

- (void)parseWithResponse:(Response)responseBlock
{
    if (!responseBlock) {
        return;
    }
    
    NSError *error = nil;
    
    if (!self.data) {
        responseBlock(nil, UPPErrorWithCode(UPPErrorCodeEmptyData));
        return;
    }
    
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:self.data error:&error];
    
    if (!document) {
        responseBlock(nil, error);
        return;
    }
    
    __block NSMutableDictionary *responseDictionary;
    
    [document enumerateElementsWithXPath:@"/s:Envelope/s:Body/*/*" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        
        if (!responseDictionary) {
            responseDictionary = [NSMutableDictionary dictionary];
        }
        
        NSString *tag = element.tag;
        NSString *value = [element stringValue];
        
        if (tag && value) {
            responseDictionary[tag] = value;
        }
        
    }];
    
    responseBlock(responseDictionary, nil);
}

@end
