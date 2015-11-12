//
//  UINavigationController+Push__Pop.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/5.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "UINavigationController+Push__Pop.h"

@implementation UINavigationController (Push__Pop)
- (void)pushAnimationDidStop {
}

- (void)pushViewController: (UIViewController*)controller
    animatedWithTransition: (UIViewAnimationTransition)transition {
    [self pushViewController:controller animated:NO];
    
    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:TT_FLIP_TRANSITION_DURATION];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}

- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
    UIViewController* poppedController = [self popViewControllerAnimated:NO];
    
    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:TT_FLIP_TRANSITION_DURATION];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
    
    return poppedController;
}
@end
