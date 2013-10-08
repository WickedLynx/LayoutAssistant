//
//  LATOriginView.m
//  LayoutAssistant
//
//  Created by Harshad Dange on 05/10/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "LATOriginView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@implementation LATOriginView

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
//    CGRect convertedRect = CGRectMake(0, dirtyRect.size.height, dirtyRect.size.width, dirtyRect.size.height);
    CGRect convertedRect = NSRectToCGRect(dirtyRect);
    
    CGRect ellipseRect = CGRectMake(dirtyRect.origin.x + floorf(dirtyRect.size.width * 0.125f), floorf(dirtyRect.size.height * 0.125f), floorf(dirtyRect.size.width - floorf(dirtyRect.size.width * 0.25f)), floorf(dirtyRect.size.height - dirtyRect.size.height * 0.25f));
    
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    CGContextSetFillColorWithColor(context, [[NSColor colorWithCalibratedRed:0.0f green:0.9f blue:0.3f alpha:0.5f] CGColor]);
    CGContextSetStrokeColorWithColor(context, [[NSColor colorWithCalibratedRed:0.0f green:0.9f blue:0.3f alpha:1.0f] CGColor]);
    
    CGContextAddEllipseInRect(context, ellipseRect);
    CGContextFillEllipseInRect(context, ellipseRect);
    CGContextStrokeEllipseInRect(context, ellipseRect);
    
    CGContextSetStrokeColorWithColor(context, [[NSColor colorWithCalibratedRed:0.9f green:0.1f blue:0.1f alpha:1.0f] CGColor]);
    CGContextSetLineWidth(context, 2.0f);
    CGContextMoveToPoint(context, CGRectGetMidX(convertedRect), CGRectGetMinY(convertedRect));
    CGContextAddLineToPoint(context, CGRectGetMidX(convertedRect), CGRectGetMaxY(convertedRect));
    CGContextMoveToPoint(context, 0, CGRectGetMidY(convertedRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(convertedRect), CGRectGetMidY(convertedRect));
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextFlush(context);
    
    
    
    
}

@end
