//
//  Video.h
//  OpenEyes
//
//  Created by lanou3g on 15/8/4.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic, copy) NSString *category; // 视频类别
@property (nonatomic, copy) NSString *coverBlurred;  // 封面模糊图片 url
@property (nonatomic, copy) NSString *coverForDetail;  // 封面图片 url
@property (nonatomic, copy) NSString *coverForFeed;
@property (nonatomic, copy) NSString *coverForSharing;
@property (nonatomic, copy) NSString *date; // 日期
@property (nonatomic, copy) NSString *description_; // 详情
@property (nonatomic, assign) int duration;  // 时长
@property (nonatomic, copy) NSString *videoID; // 地址
@property (nonatomic, copy) NSString *idx;  // 组内序号
@property (nonatomic, copy) NSString *playUrl;  // 视频地址 url
@property (nonatomic, copy) NSString *rawWebUrl;  // 原网址 url html
@property (nonatomic, copy) NSString *title;  // 标题
@property (nonatomic, copy) NSString *webUrl;  // 网址 url html

@property (nonatomic, retain) NSArray *playInfo; // 播放类别

//@property (nonatomic, retain) NSDictionary *provider; // 提供者
@property (nonatomic, copy) NSString *alias; // 别名
@property (nonatomic, copy) NSString *icon;  // 图标 url
@property (nonatomic, copy) NSString *name; // 姓名

//@property (nonatomic, retain) NSDictionary *consumption;  // 消费
@property (nonatomic, copy) NSString *collectionCount; // 收藏数
@property (nonatomic, copy) NSString *playCount;  // 播放次数
@property (nonatomic, copy) NSString *shareCount;  // 分享次数


@end
