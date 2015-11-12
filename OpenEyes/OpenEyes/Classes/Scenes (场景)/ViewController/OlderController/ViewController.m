//
//  ViewController.m
//  KrVideoPlayerPlus
//
//  Created by JiaHaiyang on 15/6/19.
//  Copyright (c) 2015年 JiaHaiyang. All rights reserved.
//

#import "ViewController.h"
#import "KrVideoPlayerController.h"
#import "Video.h"

@interface ViewController ()
@property (nonatomic, strong) KrVideoPlayerController  *videoController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题位置的图片
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"眼睛"]];
    self.view.backgroundColor = [UIColor blackColor];
    [self playVideo];
    
    //    播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAction) name:MPMoviePlayerPlaybackDidFinishNotification object:_videoController];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonAction:)];
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender
{
    [self.videoController stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)playVideo{
    NSURL *url = [NSURL URLWithString:_video.playUrl];
    [self addVideoPlayerWithURL:url];
}

- (void)addVideoPlayerWithURL:(NSURL *)url{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 200, width, width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            [weakSelf toolbarHidden:NO];
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            [weakSelf toolbarHidden:YES];
        }];
        [self.view addSubview:self.videoController.view];
    }
    self.videoController.contentURL = url;
   
}
//隐藏navigation tabbar 电池栏
- (void)toolbarHidden:(BOOL)Bool{
    
    self.navigationController.navigationBar.hidden = Bool;
    self.tabBarController.tabBar.hidden = Bool;
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}

- (void)finishAction
{
    //    1.删除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    2.返回上级窗体
    //    谁申请,谁释放
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
