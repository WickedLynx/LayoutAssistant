//
//  LATRootController.h
//  LayoutAssistant
//
//  Created by Harshad Dange on 05/10/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LATRootView;

@interface LATRootController : NSObject

@property (weak) IBOutlet NSImageView *backgroundImageView;
@property (weak) IBOutlet LATRootView *rootView;
@property (weak) IBOutlet NSTextField *coordinateField;

- (IBAction)imageDropped:(id)sender;
- (IBAction)clickRestart:(id)sender;
- (IBAction)clickSetOrigin:(id)sender;
- (IBAction)clickScaling:(id)sender;

@end
