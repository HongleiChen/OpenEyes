//
//  VideoWebViewController.h
//  ZhangYouBao
//
//  Created by lanou3g on 15/8/8.
//  Copyright (c) 2015年 文艺范儿. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerDelegare <NSObject>

- (void)moviePlayerDidFinished;

@end

@class Video;
@interface VideoWebViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic, retain) NSString *Url;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, weak) id<UIViewControllerDelegare> delegate;

@property (nonatomic, retain)  Video *video;
@end
