//
//  MKVirtualSource.h
//  MIDIKit
//
//  Created by John Heaton on 4/11/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#import "MKEndpoint.h"
#import "MKClient.h"

// A virtual source is a client-created endpoint that
// is visible to other MIDI clients as a source that they can
// connect to an input port and receive data with, just as they
// would with a normal source.

@interface MKVirtualSource : MKEndpoint <MKClientDependentInstaniation>

+ (instancetype)virtualSourceWithName:(NSString *)name client:(MKClient *)client;
- (instancetype)initWithName:(NSString *)name client:(MKClient *)client;

// Virtually sends data to this source.
- (void)receivedData:(NSData *)data;

@end
