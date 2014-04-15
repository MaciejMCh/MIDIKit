//
//  MKVirtualSource.m
//  MIDIKit
//
//  Created by John Heaton on 4/11/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#import "MIDIKit.h"
#import "MKPrivate.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-property-synthesis"
#pragma clang diagnostic ignored "-Wprotocol"

@implementation MKVirtualSource

@synthesize client=_client;

static NSMapTable *_MKVirtualSourceNameMap = nil;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _MKVirtualSourceNameMap = [NSMapTable strongToWeakObjectsMapTable];
    });
}

+ (BOOL)hasUniqueID {
    return YES;
}

+ (instancetype)virtualSourceWithName:(NSString *)name client:(MKClient *)client {
    return [[self alloc] initWithName:name client:client];
}

- (instancetype)initWithName:(NSString *)name client:(MKClient *)client {
    MIDIEndpointRef e;
    MKVirtualSource *ret;

    if((ret = [_MKVirtualSourceNameMap objectForKey:name]) != nil) return self = ret;
    if(!client.valid) return nil;
    if([MIDIKit evalOSStatus:MIDISourceCreate(client.MIDIRef, (__bridge CFStringRef)(name), &e) name:@"Creating a virtual source"] != 0)
        return nil;
    if(!(self = [super initWithMIDIRef:e])) return nil;

    [_MKVirtualSourceNameMap setObject:self forKey:name];
    _receiveQueue = [NSOperationQueue new];
    
    self.client = client;
    [self.client.virtualSources addObject:self];
    
    return self;
}

- (instancetype)receivedData:(NSData *)data {
    [self.receiveQueue addOperationWithBlock:^{
        MIDIPacketList *list = MKPacketListFromData(data);
        if([MIDIKit evalOSStatus:MIDIReceived(self.MIDIRef, list) name:@"Virtual receive"] != 0) {
            // TODO: handle error
        }

        free(list);
    }];

    return self;
}

@end

#pragma clang diagnostic pop