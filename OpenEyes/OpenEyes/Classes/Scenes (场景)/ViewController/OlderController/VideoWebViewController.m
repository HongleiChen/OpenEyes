//
//  VideoWebViewController.m
//  ZhangYouBao
//
//  Created by lanou3g on 15/8/8.
//  Copyright (c) 2015年 文艺范儿. All rights reserved.
//

#import "VideoWebViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Video.h"

@interface VideoWebViewController ()

@property (nonatomic, retain)MPMoviePlayerController *moviePlayer;

@end

@implementation VideoWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHtml];
    self.view.backgroundColor = [UIColor whiteColor];
    _moviePlayer = [[MPMoviePlayerController alloc] init];
    self.moviePlayer.view.frame = self.view.bounds;
//  在播放器进行转屏的时候可以适应屏幕
    _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//   一进到页面就全屏
//    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI / 2);
//    _moviePlayer.view.transform = landscapeTransform;
    _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    [self.view addSubview:_moviePlayer.view];
//    通知添加播放状态的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAction) name:MPMoviePlayerPlaybackStateDidChangeNotification object:_moviePlayer];
//    播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAction) name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFullScreen) name:MPMoviePlayerScalingModeDidChangeNotification object:_moviePlayer];
    
   
}
- (void)changeFullScreen
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

/*
MPMoviePlaybackStateStopped, 停止
MPMoviePlaybackStatePlaying, 播放
MPMoviePlaybackStatePaused,  暂停
MPMoviePlaybackStateInterrupted, 中断
MPMoviePlaybackStateSeekingForward, 下一个
MPMoviePlaybackStateSeekingBackward  前一个
 */
- (void)changeAction
{
    
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            NSLog(@"播放");
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停");
          
            break;
        case MPMoviePlaybackStateStopped:
//        执行[self.moviePlayer stop]或者前进后退不工作时触发
            NSLog(@"停止");
            break;
        default:
            break;
    }
}

- (void)finishAction
{
//    1.删除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    2.返回上级窗体
//    谁申请,谁释放
  [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)setUpHtml
{
//    NSString *str = [NSString stringWithFormat:@"http://box.dwstatic.com/apiVideoesNormalDuowan.php?action=f&cf=android&check_code=null&format=json&payer_name=null&plat=android2.2&uu=&ver=2.0&vid=%@&vu=null&sign=signxxxxx", self.Url];
//    NSURL *url = [NSURL URLWithString:str];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    __block typeof(self)weakSelf = self;
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//       
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        
//      
//        NSString *arr = [dict[@"result"][@"items"][@"1000"][@"transcode"][@"urls"] lastObject];
    NSLog(@"%@", _video.playUrl);
        
        self.moviePlayer.contentURL = [NSURL URLWithString:_video.playUrl];
        self.moviePlayer.view.frame = self.view.bounds;
        self.webView.scrollView.bounces = NO;
        self.webView.scrollView.showsVerticalScrollIndicator = NO;
        self.webView.scrollView.showsHorizontalScrollIndicator = NO;
        self.webView.scrollView.indicatorStyle = UIScrollViewKeyboardDismissModeOnDrag;
        self.webView.scrollView.scrollsToTop = YES;
        [self.moviePlayer play];
        
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
