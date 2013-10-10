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
    CGRect convertedRect = NSRectToCGRect(self.bounds);
    
    CGRect ellipseRect = CGRectMake(self.bounds.origin.x + floorf(self.bounds.size.width * 0.125f), floorf(self.bounds.size.height * 0.125f), floorf(self.bounds.size.width - floorf(self.bounds.size.width * 0.25f)), floorf(self.bounds.size.height - self.bounds.size.height * 0.25f));
    
    
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
