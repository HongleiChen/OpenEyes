//
//  TBController.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "TBController.h"
#import "AppDelegate.h"
#import "OtherViewController.h"

#define kIsLogined @"login"
@interface TBController ()
- (IBAction)rightBarButton:(UIBarButtonItem *)sender;

@end

@implementation TBController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 修改导航条透明度
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置汉堡按钮点击效果
- (IBAction)humgerButton:(UIBarButtonItem *)sender {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed) {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}


- (IBAction)rightBarButton:(UIBarButtonItem *)sender
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kIsLogined]) {
        // 提示用户登陆
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请您登陆后操作" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherViewController *otherVC = [storyboard instantiateViewControllerWithIdentifier:@"OtherVC"];
        UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:otherVC];
        
        [self presentViewController:NVC animated:YES completion:nil];
    }
}
@end
