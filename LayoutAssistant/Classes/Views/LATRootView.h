//
//  LATRootView.h
//  LayoutAssistant
//
//  Created by Harshad Dange on 05/10/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LATMouseDelegate.h"

@interface LATRootView : NSView

@property (weak, nonatomic) id <LATMouseDelegate> delegate;

@end
