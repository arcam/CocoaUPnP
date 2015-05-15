// CocoaUPnP by A&R Cambridge Ltd, http://www.arcam.co.uk
// Copyright 2015 Arcam. See LICENSE file.

#import "UPPLastChangeParser.h"
#import "Ono.h"
#import "UPPError.h"

@implementation UPPLastChangeParser

- (void)parseWithCompletion:(UPPLastChangeCompletionBlock)completion
{
    if (!completion) {
        return;
    }

    UPPTransportState state = UPPTransportStateUnknown;

    if (![self data]) {
        completion(state, nil, UPPErrorWithCode(UPPErrorCodeEmptyData));
        return;
    }

    NSError *error = nil;
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:self.data error:&error];

    if (!document) {
        completion(UPPTransportStateUnknown, nil, error);
    }

    ONOXMLElement *element = [document firstChildWithXPath:@"//*[name()='InstanceID']"];

    NSString *transportState = [[element firstChildWithTag:@"TransportState"]
                                valueForAttribute:@"val"];
    state = [self transportStateForString:transportState];

    NSString *transportActions = [[element firstChildWithTag:@"CurrentTransportActions"]
                                  valueForAttribute:@"val"];

    completion(state, transportActions, nil);
}

#pragma mark - Private Methods

- (UPPTransportState)transportStateForString:(NSString *)string
{
    if ([string isEqualToString:@"STOPPED"]) {
        return UPPTransportStateStopped;
    } else if ([string isEqualToString:@"TRANSITIONING"]) {
        return UPPTransportStateTransitioning;
    } else if ([string isEqualToString:@"PLAYING"]) {
        return UPPTransportStatePlaying;
    } else if ([string isEqualToString:@"PAUSED_PLAYBACK"]) {
        return UPPTransportStatePaused;
    } else if ([string isEqualToString:@"NO_MEDIA_PRESENT"]) {
        return UPPTransportStateNoMediaPresent;
    } else {
        return UPPTransportStateUnknown;
    }
}

@end
