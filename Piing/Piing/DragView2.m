//
//  DragView2.m
//  DragViewDemo
//
//  Created by Arthur Knopper on 1/13/13.
//  Copyright (c) 2013 Arthur Knopper. All rights reserved.
//

#import "DragView2.h"

@implementation DragView2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(detectPan:)];
//        self.gestureRecognizers = @[panRecognizer];
        
        // randomize view color
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        
        self.backgroundColor = color;
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Promote the touched view
    //[self.superview bringSubviewToFront:self];
    
    // Remember original location
    lastLocation = self.center;
    
//    UITouch *touch = [[event allTouches] anyObject];
//    lastLocation = [touch locationInView:self];
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self];
    CGPoint previousLocation = [aTouch previousLocationInView:self];
    
    self.frame = CGRectOffset(self.frame, 0, (location.y - previousLocation.y));
    
    if ([self.delegate respondsToSelector:@selector(touchesDidChangeToView:WithLocation:AndPreviousLocation:)])
    {
        [self.delegate touchesDidChangeToView:self WithLocation:location AndPreviousLocation:previousLocation];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self];
    CGPoint previousLocation = [aTouch previousLocationInView:self];
    
    self.frame = CGRectOffset(self.frame, 0, (location.y - previousLocation.y));
    
    if ([self.delegate respondsToSelector:@selector(touchesDidEndToView:WithLocation:AndPreviousLocation:)])
    {
        [self.delegate touchesDidEndToView:self WithLocation:location AndPreviousLocation:previousLocation];
    }
}

- (void) detectPan:(UIPanGestureRecognizer *) uiPanGestureRecognizer
{
    CGPoint translation = [uiPanGestureRecognizer translationInView:self.superview];
    
    if(uiPanGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(touchesDidEndToView:WithLocation:AndPreviousLocation:)])
        {
            //[self.delegate touchesDidEndToView:self WithLocation:lastLocation AndPreviousLocation:<#(CGPoint)#>];
        }
    }
    else if(uiPanGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
//        if (lastLocation.y > 0)
//        {
//            self.center = CGPointMake(screen_width/2, lastLocation.y + translation.y);
//        }
        
        self.center = CGPointMake(screen_width/2, lastLocation.y + translation.y);
        
        if ([self.delegate respondsToSelector:@selector(touchesDidChangeToView:WithTranslation:)])
        {
            //[self.delegate touchesDidChangeToView:self WithTranslation:translation];
        }
        
        //NSLog(@"%f", translation.y);
    }
    else
    {
        //self.center = CGPointMake(screen_width/2, lastLocation.y + translation.y);
    }
    
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return NO;
//}


@end
