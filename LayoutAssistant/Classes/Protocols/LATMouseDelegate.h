//
//  LATMouseDelegate.h
//  LayoutAssistant
//
//  Created by Harshad Dange on 05/10/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LATMouseDelegate <NSObject>

@optional

- (void)view:(NSResponder *)view didDetectMouseDownEventAtPoint:(NSPoint)point;
- (void)view:(NSResponder *)view didDetectMouseUpEventAtPoint:(NSPoint)point;
- (void)mouseLocationDidChange:(NSPoint)newLocation forView:(NSResponder *)view;
- (void)view:(NSResponder *)view didDetectMouseDragFromPoint:(NSPoint)fromPoint toPoint:(NSPoint)toPoint;
- (void)selectedRect:(NSRect)rect inView:(NSResponder *)view;


@end
