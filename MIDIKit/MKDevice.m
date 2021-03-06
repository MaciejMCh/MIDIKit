//
//  MKDevice.m
//  MIDIKit
//
//  Created by John Heaton on 3/23/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#import "MIDIKit.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-property-synthesis"
#pragma clang diagnostic ignored "-Wprotocol"

@implementation MKDevice

@dynamic iconImagePath, numberOfEntities, entities, driverDeviceEditorApp, singleRealtimeEntity;

+ (BOOL)hasUniqueID {
    return YES;
}

+ (NSUInteger)count {
    return MIDIGetNumberOfDevices();
}

+ (instancetype)atIndex:(NSUInteger)index {
    return [self withMIDIRef:MIDIGetDevice(index)];
}

- (MKDestination *)rootDestination {
    return [[self entityAtIndex:0] destinationAtIndex:0];
}

- (MKSource *)rootSource {
    return [[self entityAtIndex:0] sourceAtIndex:0];
}

- (MKEntity *)entityAtIndex:(NSUInteger)index {
    return [[MKEntity alloc] initWithMIDIRef:MIDIDeviceGetEntity(self.MIDIRef, index)];
}

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return [self entityAtIndex:index];
}

- (MKEntity *)firstEntity {
    return [self entityAtIndex:0];
}

- (NSUInteger)numberOfEntities {
    return MIDIDeviceGetNumberOfEntities(self.MIDIRef);
}

- (NSArray *)entities {
    NSUInteger num = self.numberOfEntities;
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:num];
    for(NSUInteger i=0;i<num;++i) {
        [ret addObject:[self entityAtIndex:i]];
    }
    return ret;
}

@end

#pragma clang diagnostic pop