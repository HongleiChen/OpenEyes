//
//  DetailViewController.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/4.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "DetailViewController.h"
#import "Video.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "UINavigationController+Push__Pop.h"
#import "DBHelper.h"
#import "OtherViewController.h"
#import "ViewController.h"
#import "UMSocial.h"

#define kIsLogined @"login"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *footImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;




@end

@implementation DetailViewController

- (void)viewDidLoad { 
    [super viewDidLoad];
    
    // 设置标题位置的图片
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"眼睛"]];
    
    // 隐藏tabBar
//    self.tabBarController.tabBar.hidden = YES;
    [self loadData];
  
    // 判断是否登陆
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kIsLogined]) {
        // 将收藏图标熄灭
        self.firstImageView.image = [UIImage imageNamed:@"heart_gray_16px_583420_easyicon.net"];
    }
}

#pragma mark - 载入数据
- (void)loadData
{
    // 设置标题
    self.titleLabel.text = _video.title;
    // 设置简要说明
    int time = _video.duration;
    NSString *times = [NSString stringWithFormat:@"%02d'%02d''", time / 60, time % 60];
    NSString *type = [NSString stringWithFormat:@"# %@ / %@", _video.category, times];
    self.typeLabel.text = type;
    // 设置详细说明
    self.detailLabel.text = _video.description_;
    // 设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_video.coverForDetail]];
    [self.footImageView sd_setImageWithURL:[NSURL URLWithString:_video.coverBlurred]];
    // 根据数据库中是否有该条信息来判断是否点亮收藏图标
    if (![[DBHelper sharedDBHelper] selectVideoWithID:_video.videoID]) {
        self.firstImageView.image = [UIImage imageNamed:@"heart_gray_16px_583420_easyicon.net"];
    } else {
        self.firstImageView.image = [UIImage imageNamed:@"Heart_16px_1060951_easyicon.net"];
    }
    
}

/*
// 显示页面
//- (void)showView
//{
//    // 1. 拿到window
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    
//    // 2. 设置当前控制器的frame
////    self.view.frame = CGRectMake(0, 64, window.bounds.size.width, window.bounds.size.height - 64);
//    self.view.frame = window.bounds;
//    // 3. 将当前控制器的view添加到window上
//    [window addSubview:self.view];
//    // 4. 执行动画, 让控制器的view从下面钻出来
//    self.view.y = window.bounds.size.height;
//    [UIView animateWithDuration:2 animations:^{
//        // 执行动画
//        self.view.y = 0;
//    } completion:^(BOOL finished) {
//       
//    }];
//}
*/

#pragma mark - 实现收藏功能
- (IBAction)fistTap:(UITapGestureRecognizer *)sender
{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kIsLogined]) {
        // 提示用户登陆
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请您注册或登陆后操作" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
        
    } else {
    // 判断数据库中是否有该条数据
    if (![[DBHelper sharedDBHelper] selectVideoWithID:_video.videoID]) { // 如果没有
        // 插入该条数据
        [[DBHelper sharedDBHelper] insertVideo:_video];
        // 提示用户收藏成功
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"收藏成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        // 将收藏图标点亮
        self.firstImageView.image = [UIImage imageNamed:@"Heart_16px_1060951_easyicon.net"];
    } else { // 如果有该条数据
        
        // 发送通知, 将要删除的值传给收藏页面
        Video *video = [[DBHelper sharedDBHelper] selectVideoWithID:_video.videoID];
//        NSLog(@"============================%@", video);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadOtherTVC" object:nil userInfo:@{@"key": video}];
        // 删除该条数据
        [[DBHelper sharedDBHelper] deleteVideoWithID:_video.videoID];
        // 提示用户取消收藏
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消收藏" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        // 将收藏图标熄灭
        self.firstImageView.image = [UIImage imageNamed:@"heart_gray_16px_583420_easyicon.net"];
        
 
    }
    }
    
}
#pragma mark - 实现分享功能
- (IBAction)secondTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"第二个");
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:_video.title
                                     shareImage:_imageView.image
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,nil]
                                       delegate:nil];
}

#pragma mark - 实现播放功能
- (IBAction)playTap:(UITapGestureRecognizer *)sender {
    NSLog(@"play");
    
    ViewController *playingVC = [[ViewController alloc] init];
    playingVC.video = _video;
    UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:playingVC];
    [self presentViewController:NVC animated:YES completion:nil];
}


@end
