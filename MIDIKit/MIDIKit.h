//
//  MIDIKit.h
//  MIDIKit
//
//  Created by John Heaton on 4/13/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#import "MKClient.h"
#import "MKConnection.h"
#import "MKDevice.h"
#import "MKEndpoint.h"
#import "MKEntity.h"
#import "MKInputPort.h"
#import "MKMessage.h"
#import "MKObject.h"
#import "MKOutputPort.h"
#import "MKThruConnection.h"
#import "MKVirtualDestination.h"
#import "MKVirtualSource.h"
#import "MKSource.h"
#import "MKDestination.h"

#define kMIDIKitVersionMajor 0
#define kMIDIKitVersionMinor 2
#define kMIDIKitVersionPatch 1

// Use to put constructors for all MIDIKit classes into a JavaScript context
extern void MKInstallIntoContext(JSContext *c);

// -------------------
// Global settings
extern BOOL MKSettingDescriptionsIncludeProperties; // default: NO

// ------------------------------------------------------------------
// Convenience class methods for setting GLOBAL framework settings
// in the JavaScript world. You may use it as-is in Objective-C,
// however, note that it is only changing the global variables above
// directly, which you can do for the same effect.
//
// DO NOT INSTANTIATE THIS CLASS -- it will do no good
@protocol MIDIKitJS <JSExport>

JSExportAs(showProperties, + (BOOL)setDescriptionsIncludeProperties:(BOOL)val);
+ (BOOL)descriptionsIncludeProperties;

@end

@interface MIDIKit : NSObject <MIDIKitJS>
@end