//
//  MKJavaScriptContext.h
//  MIDIKit
//
//  Created by John Heaton on 4/11/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "MKJavaScriptModule.h"

#pragma mark - -JavaScript Context-

// This is a JSContext subclass that can be created
// in the following ways:
//
// [MKJavaScriptContext new]
// [[MKJavaScriptContext alloc] init]
// [[MKJavaScriptContext alloc] initWithVirtualMachine:myVM]
//
// It is automatically set up with constructors for all MIDIKit classes

@interface MKJavaScriptContext : JSContext

- (JSValue *)evaluateScriptAtPath:(NSString *)path;
- (BOOL)loadNativeModuleAtPath:(NSString *)path;
- (JSValue *)loadNativeModule:(Class<MKJavaScriptModule>)module;

@end
