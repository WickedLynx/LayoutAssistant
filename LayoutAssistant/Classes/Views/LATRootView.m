//
//  LATRootView.m
//  LayoutAssistant
//
//  Created by Harshad Dange on 05/10/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "LATRootView.h"

@interface LATRootView () {
    
    NSPoint _dragStartPoint;
    NSPoint _moveStartPoint;
}

@end

@implementation LATRootView


#pragma mark - Mouse Events

- (void)mouseUp:(NSEvent *)theEvent {

    if ([self.delegate respondsToSelector:@selector(view:didDetectMouseUpEventAtPoint:)]) {
        
        [self.delegate view:self didDetectMouseUpEventAtPoint:[theEvent locationInWindow]];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    
    _dragStartPoint = [theEvent locationInWindow];
    
    if ([self.delegate respondsToSelector:@selector(view:didDetectMouseDownEventAtPoint:)]) {
        
        [self.delegate view:self didDetectMouseDownEventAtPoint:_dragStartPoint];
    }
}


- (void)mouseMoved:(NSEvent *)theEvent {
    
    if ([self.delegate respondsToSelector:@selector(mouseLocationDidChange:forView:)]) {
        
        [self.delegate mouseLocationDidChange:[theEvent locationInWindow] forView:self];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent {
    if ([self.delegate respondsToSelector:@selector(view:didDetectMouseDragFromPoint:toPoint:)]) {
        
        [self.delegate view:self didDetectMouseDragFromPoint:_dragStartPoint toPoint:[theEvent locationInWindow]];
    }
    
    if ([self.delegate respondsToSelector:@selector(selectedRect:inView:)]) {
        
        NSPoint lastDragPoint = [theEvent locationInWindow];
        
        CGFloat originX = 0.0f;
        CGFloat width = 0.0f;
        if (lastDragPoint.x > _dragStartPoint.x) {
            width = lastDragPoint.x - _dragStartPoint.x;
            originX = _dragStartPoint.x;
        } else {
            width = _dragStartPoint.x - lastDragPoint.x;
            originX = lastDragPoint.x;
        }
        
        CGFloat originY = 0.0f;
        CGFloat height = 0.0f;
        if (lastDragPoint.y > _dragStartPoint.y) {
            height = lastDragPoint.y - _dragStartPoint.y;
            originY = _dragStartPoint.y;
        } else {
            height = _dragStartPoint.y - lastDragPoint.y;
            originY = lastDragPoint.y;
        }
        
        
        NSRect rectToReturn = NSMakeRect(originX, originY, width, height);
        
        [self.delegate selectedRect:rectToReturn inView:self];
    }
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
    return YES;
}


@end
