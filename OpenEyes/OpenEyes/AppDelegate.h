//
//  AppDelegate.h
//  OpenEyes
//
//  Created by lanou3g on 15/8/3.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability *hostReach;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;

//@property (strong, nonatomic) UITabBarController *mainTabBarController;
//@property (strong, nonatomic) UINavigationController *mainNavigationController;


@end

