//
//  MKVirtualDestination.m
//  MIDIKit
//
//  Created by John Heaton on 4/11/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#import "MKVirtualDestination.h"

@implementation MKVirtualDestination

@synthesize client=_client;

static void _MKVirtualDestinationReadProc(const MIDIPacketList *pktlist, void *readProcRefCon, void *srcConnRefCon) {
    MKVirtualDestination *self = (__bridge MKVirtualDestination *)(readProcRefCon);
    
    
}

- (instancetype)initWithName:(NSString *)name client:(MKClient *)client {
    if(!client.valid || !(self = [super init])) return nil;
    
    if(MIDIDestinationCreate(client.MIDIRef, (__bridge CFStringRef)(name), _MKVirtualDestinationReadProc, (__bridge void *)(self), &_MIDIRef) != 0)
        return nil;
    
    self.client = client;
    [self.client.virtualSources addObject:self];
    
    return self;
}

@end
