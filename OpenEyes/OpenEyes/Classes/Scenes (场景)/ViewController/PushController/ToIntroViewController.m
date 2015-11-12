//
//  ToIntroViewController.m
//  Demo
//
//  Created by lanou3g on 15/7/15.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "ToIntroViewController.h"
#import "ABCIntroView.h"
#import "LeftSortsViewController.h"

@interface ToIntroViewController ()<ABCIntroViewDelegate>
@property ABCIntroView *introView;
@end

@implementation ToIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
    self.introView.delegate = self;
    self.introView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.introView];
    
}

#pragma mark 实现代理方法
- (void)onDoneButtonPressed{

//    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.introView.alpha = 0;
//    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
