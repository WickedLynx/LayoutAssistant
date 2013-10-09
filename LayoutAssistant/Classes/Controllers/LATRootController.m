//
//  LATRootController.m
//  LayoutAssistant
//
//  Created by Harshad Dange on 05/10/2013.
//  Copyright (c) 2013 Laughing Buddha Software. All rights reserved.
//

#import "LATRootController.h"
#import "LATRootView.h"
#import "LATMouseDelegate.h"
#import "LATOriginView.h"
#import "LATMarqueeSelectionOverlay.h"

typedef NS_ENUM(NSUInteger, RCState) {
    RCStateInitial = 0,
    RCStateImageChosen,
    RCStateOriginSet,
    RCStateSelect
};

@interface LATRootController () <LATMouseDelegate> {
    
    CGFloat _backgroundImageViewDeltaY;
    CGFloat _backgroundImageViewDeltaX;
    RCState _interactionState;
    NSPoint _origin;
    NSPoint _convertedOrigin;
    float _scale;
    NSRect _selectedRect;
}

@property (weak, nonatomic) LATOriginView *originView;
@property (weak, nonatomic) LATMarqueeSelectionOverlay *selectionOverlay;

- (void)updateCoordinateLabelWithXCoordinate:(CGFloat)xCoordinate yCoordinate:(CGFloat)yCoordinate;
- (void)updateCoordinateLabelWithRect:(NSRect)rect;
- (CGPoint)invertedCGPoint:(CGPoint)point forView:(NSView *)view;
- (NSRect)invertedRect:(NSRect)rect;
- (int)maxAllowedWidth;
- (int)maxAllowedHeight;
- (void)copySnippetToPasteBoardForCurrentRect;

@end

@implementation LATRootController

#pragma mark - Lifecycle

- (void)awakeFromNib {
    
    _interactionState = RCStateInitial;
    
    NSWindow *mainWindow = [[NSApplication sharedApplication] windows][0];
    CGRect windowFrame = mainWindow.frame;
    
    CGRect imageViewFrame = self.backgroundImageView.frame;
    
    _backgroundImageViewDeltaX = windowFrame.size.width - imageViewFrame.size.width;
    _backgroundImageViewDeltaY = windowFrame.size.height - imageViewFrame.size.height;
    
    [_rootView setDelegate:self];
    
    _scale = 1.0f;
}

- (void)dealloc {
    if (_rootView != nil) {
        
        [_rootView setDelegate:nil];
    }
}


#pragma mark - Actions

- (IBAction)imageDropped:(id)sender {
    
    NSImage *image = self.backgroundImageView.image;
    
    NSWindow *keyWindow = [[[NSApplication sharedApplication] windows] objectAtIndex:0];
    
    NSRect keyWindowTargetFrame = keyWindow.frame;
    
    if (image.size.width > image.size.height) {
        
        _scale = (float)[self maxAllowedWidth] / image.size.width;
        
        if ((_scale * image.size.height) > [self maxAllowedHeight]) {
            
            _scale = (float)[self maxAllowedHeight] / image.size.height;
        }
    } else {
        
        _scale = (float)[self maxAllowedHeight] / image.size.height;
        
        if ((_scale * image.size.width) > [self maxAllowedWidth]) {
            
            _scale = (float)[self maxAllowedWidth] / image.size.width;
        }
    }
    
    keyWindowTargetFrame.size.width = (image.size.width * _scale) + _backgroundImageViewDeltaX;
    keyWindowTargetFrame.size.height = (image.size.height * _scale) + _backgroundImageViewDeltaY;
    
    [keyWindow setFrame:keyWindowTargetFrame display:YES animate:YES];
    
    [self.backgroundImageView setEditable:NO];
    [self.backgroundImageView setEnabled:NO];
    
    _interactionState = RCStateImageChosen;

}

- (IBAction)clickRestart:(id)sender {
    
    [self.backgroundImageView setImage:nil];
    [self.backgroundImageView setEnabled:YES];
    [self.backgroundImageView setEditable:YES];
    [self.originView setHidden:YES];
    
    _interactionState = RCStateInitial;
}

- (IBAction)clickSetOrigin:(id)sender {
    
    if (_interactionState >= RCStateImageChosen) {
        
        _interactionState = RCStateImageChosen;
        [self.originView setHidden:NO];
        [self.originView setFrameOrigin:NSMakePoint(self.backgroundImageView.frame.origin.x, self.backgroundImageView.frame.origin.y + self.backgroundImageView.frame.size.height)];
        
        
        [[[[NSApplication sharedApplication] windows] objectAtIndex:0] setAcceptsMouseMovedEvents:YES];
    }
    

    
}

#pragma mark - Priavate methods

- (LATOriginView *)originView {
    
    if (_originView == nil) {
        
        LATOriginView *anOriginView = [[LATOriginView alloc] initWithFrame:NSMakeRect(20, 70, 30, 30)];
        [self.rootView addSubview:anOriginView];
        [anOriginView setHidden:YES];
        [self setOriginView:anOriginView];
        
        [_originView.layer setShouldRasterize:YES];
    }
    
    return _originView;
}

- (LATMarqueeSelectionOverlay *)selectionOverlay {
    
    if (_selectionOverlay == nil) {
        
        LATMarqueeSelectionOverlay *selectionOverlay = [[LATMarqueeSelectionOverlay alloc] initWithFrame:NSZeroRect];
        [self.rootView addSubview:selectionOverlay];
        [selectionOverlay setHidden:YES];
        [self setSelectionOverlay:selectionOverlay];
    }
    
    return _selectionOverlay;
}

- (CGPoint)invertedCGPoint:(CGPoint)point forView:(NSView *)view {
    
    CGPoint pointToReturn = point;
    pointToReturn.y = view.frame.size.height - point.y;
    
    return pointToReturn;
}

- (NSRect)invertedRect:(NSRect)rect {
    
    NSRect invertedRect = rect;
    
    invertedRect.origin.y = (_origin.y - rect.size.height - rect.origin.y);
    invertedRect.origin.x = (rect.origin.x - _origin.x);
    
    return invertedRect;
}

- (void)updateCoordinateLabelWithXCoordinate:(CGFloat)xCoordinate yCoordinate:(CGFloat)yCoordinate {
    
    [self.coordinateField setStringValue:[NSString stringWithFormat:@"X: %.2f, Y: %.2f", xCoordinate / _scale, yCoordinate / _scale]];
}

- (void)updateCoordinateLabelWithRect:(NSRect)rect {
    NSRect scaledRect = NSMakeRect(rect.origin.x / _scale, rect.origin.y / _scale, rect.size.width / _scale, rect.size.height / _scale);
    _selectedRect = NSIntegralRectWithOptions(scaledRect, NSAlignAllEdgesOutward | NSAlignRectFlipped);
    [self.coordinateField setStringValue:[NSString stringWithFormat:@"X: %.2f, Y: %.2f, W: %.2f, H: %.2f", _selectedRect.origin.x, _selectedRect.origin.y, _selectedRect.size.width, _selectedRect.size.height]];
}

- (int)maxAllowedHeight {
    return (int)([[NSScreen mainScreen] frame].size.height * 0.7f);
}

- (int)maxAllowedWidth {
    return (int)([[NSScreen mainScreen] frame].size.width * 0.7f);
}

- (void)copySnippetToPasteBoardForCurrentRect {
    
    NSString *snippet = [NSString stringWithFormat:@"CGRectMake(%d.0f, %d.0f, %d.0f, %d.0f)", (int)_selectedRect.origin.x, (int)_selectedRect.origin.y, (int)_selectedRect.size.width, (int)_selectedRect.size.height];
    
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:@[NSPasteboardTypeString] owner:self];
    [pasteBoard setString:snippet forType:NSPasteboardTypeString];


}

#pragma mark - LATMouseDelegate methods

- (void)view:(NSResponder *)view didDetectMouseDownEventAtPoint:(NSPoint)point {

    if (_interactionState == RCStateImageChosen) {
        
        [[[[NSApplication sharedApplication] windows] objectAtIndex:0] setAcceptsMouseMovedEvents:NO];
        _interactionState = RCStateOriginSet;
        
        
    }
    else if (_interactionState == RCStateOriginSet) {
        
        [self.selectionOverlay setFrame:NSZeroRect];
        [self.selectionOverlay setHidden:NO];
        _interactionState = RCStateSelect;
        
    }
}

- (void)selectedRect:(NSRect)rect inView:(NSResponder *)view {
    
    if (_interactionState == RCStateSelect) {

        [self.selectionOverlay setFrame:rect];
        NSRect convertedRect = [self.rootView convertRect:rect toView:self.backgroundImageView];
        [self updateCoordinateLabelWithRect:[self invertedRect:convertedRect]];
    }
}

- (void)mouseLocationDidChange:(NSPoint)newLocation forView:(NSResponder *)view {
    
    NSPoint centerPoint = NSMakePoint((newLocation.x - floorf(self.originView.frame.size.width / 2)), (newLocation.y - floorf(self.originView.frame.size.height / 2)));

    [self.originView setFrameOrigin:centerPoint];
    
    [self.originView setHidden:!NSContainsRect(self.rootView.frame, self.originView.frame)];
    
    if ([view isKindOfClass:[NSView class]]) {

        NSView *fromView = (NSView *)view;
        NSPoint convertedPoint = [fromView convertPoint:newLocation toView:self.backgroundImageView];
        _origin = convertedPoint;
        CGPoint convertedCGPoint = [self invertedCGPoint:NSPointToCGPoint(convertedPoint) forView:self.backgroundImageView];
        [self updateCoordinateLabelWithXCoordinate:convertedCGPoint.x yCoordinate:convertedCGPoint.y];
    }
}

- (void)view:(NSResponder *)view didDetectMouseUpEventAtPoint:(NSPoint)point {
    
    if (_interactionState == RCStateSelect) {
        
        _interactionState = RCStateOriginSet;
        [self copySnippetToPasteBoardForCurrentRect];
    }
}

@end
