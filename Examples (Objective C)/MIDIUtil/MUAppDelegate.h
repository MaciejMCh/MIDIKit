//
//  MUAppDelegate.h
//  MIDIUtil
//
//  Created by John Heaton on 4/17/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKClient.h"

@interface MUAppDelegate : UIResponder <UIApplicationDelegate, MKClientDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
