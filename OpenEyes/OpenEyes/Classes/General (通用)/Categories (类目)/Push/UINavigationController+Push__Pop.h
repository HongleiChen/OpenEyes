//
//  UINavigationController+Push__Pop.h
//  OpenEyes
//
//  Created by lanou3g on 15/8/5.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Push__Pop)

- (void)pushViewController: (UIViewController*)controller
    animatedWithTransition: (UIViewAnimationTransition)transition;

- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition;
@end
