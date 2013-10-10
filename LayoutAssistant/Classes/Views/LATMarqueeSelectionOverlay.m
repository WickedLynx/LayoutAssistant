//
//  LATMarqueeSelectionOverlay.m
//  LayoutAssistant
//
//  Created by Harshad Dange on 07/10/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "LATMarqueeSelectionOverlay.h"

@implementation LATMarqueeSelectionOverlay

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
    return NO;
}

- (BOOL)acceptsFirstResponder {
    return NO;
}

- (BOOL)acceptsTouchEvents {
    return NO;
}


- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    CGRect convertedRect = NSRectToCGRect(self.bounds);
    
    CGContextRef currentContext = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextAddRect(currentContext, convertedRect);
    CGContextSetFillColorWithColor(currentContext, CGColorCreateGenericRGB(0.639, 0.745, 0.925, 0.400));
    CGContextSetStrokeColorWithColor(currentContext, CGColorCreateGenericRGB(0.639, 0.745, 0.925, 0.700));
    
    CGContextSetLineWidth(currentContext, 2.0f);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}

@end
