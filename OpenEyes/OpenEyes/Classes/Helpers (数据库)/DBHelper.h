//
//  DBHelper.h
//  OpenEyes
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Video;
@interface DBHelper : NSObject

+ (instancetype)sharedDBHelper;

#pragma mark - 插入数据库
- (void)insertVideo:(Video *)video;

#pragma mark - 查询全部数据
- (NSArray *)selectAllVideoes;

#pragma mark - 根据videoID查询单条数据
- (Video *)selectVideoWithID:(NSString *)videoID;

#pragma mark - 删除数据
- (void)deleteVideoWithID:(NSString *)videoID;
@end
