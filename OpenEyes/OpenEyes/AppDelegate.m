//
//  AppDelegate.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/3.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftSortsViewController.h"
#import "ABCIntroView.h"
#import "UMSocial.h"
#import "Reachability.h"

@interface AppDelegate ()<UITabBarControllerDelegate, ABCIntroViewDelegate>

@property ABCIntroView *introView;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UMSocialData setAppKey:@"507fcab25270157b37000010"];
    // 创建一个window
    self.window = [[UIWindow alloc] init];
    _window.frame = [UIScreen mainScreen].bounds;
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    // 实例化左侧tableView
    LeftSortsViewController *leftVC = [LeftSortsViewController new];
    // 加载storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 给视图添加手势，
    self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:[storyboard instantiateInitialViewController]];
    // 设置LeftSlideVC为根视图控制器
    self.window.rootViewController = self.LeftSlideVC;
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor purpleColor]];
    
    // 设置导航视图首次启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
        self.introView = [[ABCIntroView alloc] initWithFrame:_window.frame];
        self.introView.delegate = self;
        self.introView.backgroundColor = [UIColor greenColor];
        [self.window addSubview:self.introView];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    /*
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    // 初始化Reachability类，并添加一个监测的网址。
    hostReach = [Reachability reachabilityWithHostName:@"https://www.baidu.com/"];
    // 开始监测
    [hostReach startNotifier];
    */
    
    return YES;
}

/*
#pragma mark - 监测网络情况，当网络发生改变时会调用

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前网络不可用" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        alertView = nil;
    }
}
*/


#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed{
    
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.introView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
