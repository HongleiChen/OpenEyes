//
//  DBHelper.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "DBHelper.h"
#import "Video.h"
#import "FMDB.h"

@implementation DBHelper

+ (instancetype)sharedDBHelper
{
    static DBHelper *dbHelper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbHelper = [DBHelper new];
        [dbHelper openDB];
    });
    return dbHelper;
}

// 设置指针变量, 代表数据库
static FMDatabase *db = nil;

#pragma mark - 创建数据库, 创建数据表, 打开数据库
- (void)openDB
{
    // 路径
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/DataBase.sqlite"];
    NSLog(@"%@", filePath);
    // 创建数据库
    db = [FMDatabase databaseWithPath:filePath];
    
    // 创建数据表
    if ([db open]) {
        if ([db executeUpdate:@"CREATE TABLE IF NOT EXISTS ss_video(category TEXT, coverBlurred TEXT, coverForDetail TEXT, coverForFeed TEXT, coverForSharing TEXT, date TEXT, description_ TEXT, duration TEXT, videoID TEXT, idx TEXT, playUrl TEXT, rawWebUrl TEXT, title TEXT, webUrl TEXT, alias TEXT, icon TEXT, name TEXT, collectionCount TEXT, playCount TEXT, shareCount TEXT)"]) {
            NSLog(@"创建成功");
        }
    }
}

#pragma mark - 插入数据库
- (void)insertVideo:(Video *)video
{
    [db open];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO ss_video(category, coverBlurred, coverForDetail, coverForFeed, coverForSharing, date, description_, duration, videoID, idx, playUrl, rawWebUrl, title, webUrl, alias, icon, name, collectionCount, playCount, shareCount) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", video.category, video.coverBlurred, video.coverForDetail, video.coverForFeed, video.coverForSharing, video.date, video.description_, video.duration, video.videoID, video.idx, video.playUrl, video.rawWebUrl, video.title, video.webUrl, video.alias, video.icon, video.name, video.collectionCount, video.playCount, video.shareCount];
    
    if ([db executeUpdate:sql]) {
        NSLog(@"插入成功");
    }
    [db close];
}



#pragma mark - 查询全部数据
- (NSArray *)selectAllVideoes
{
    NSMutableArray *array = [NSMutableArray array];
    [db open];
    
    // 查询所有结果, 放入set中
    FMResultSet *set = [db  executeQuery:@"SELECT * FROM ss_video"];
    
    // 遍历set, 获取每一条数据
    while ([set next]) {
        // 创建模型, 把每一条的每个字段都放入模型
        Video *video = [Video new];
        
        video.category = [set stringForColumn:@"category"];
        video.coverBlurred = [set stringForColumn:@"coverBlurred"];
        video.coverForDetail = [set stringForColumn:@"coverForDetail"];
        video.coverForFeed = [set stringForColumn:@"coverForFeed"];
        video.coverForSharing = [set stringForColumn:@"coverForSharing"];
        video.date = [set stringForColumn:@"date"];
        video.description_ = [set stringForColumn:@"description_"];
        video.videoID = [set stringForColumn:@"videoID"];
        video.idx = [set stringForColumn:@"idx"];
        video.playUrl = [set stringForColumn:@"playUrl"];
        video.rawWebUrl = [set stringForColumn:@"rawWebUrl"];
        video.title = [set stringForColumn:@"title"];
        video.webUrl = [set stringForColumn:@"webUrl"];
        video.alias = [set stringForColumn:@"alias"];
        video.icon = [set stringForColumn:@"icon"];
        video.name = [set stringForColumn:@"name"];
        video.collectionCount = [set stringForColumn:@"collectionCount"];
        video.playCount = [set stringForColumn:@"playCount"];
        video.shareCount = [set stringForColumn:@"shareCount"];
        video.duration = [set intForColumn:@"duration"];
        
        [array addObject:video];
        NSLog(@"查询成功");
    }
    [set close];
    [db close];
    return array;
}

#pragma mark - 根据videoID查询单条数据
- (Video *)selectVideoWithID:(NSString *)videoID
{
    NSMutableArray *array = [NSMutableArray array];
    [db open];
#warning 拼接的SQ语句必须用字符串承接, 不能直接写入set语句
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ss_video WHERE videoID = '%@'", videoID];
    // 查询所有结果, 放入set中
    FMResultSet *set = [db  executeQuery:sql];
    // 遍历set, 获取每一条数据
    while ([set next]) {
        // 创建模型, 把每一条的每个字段都放入模型
        Video *video = [Video new];
        
        video.category = [set stringForColumn:@"category"];
        video.coverBlurred = [set stringForColumn:@"coverBlurred"];
        video.coverForDetail = [set stringForColumn:@"coverForDetail"];
        video.coverForFeed = [set stringForColumn:@"coverForFeed"];
        video.coverForSharing = [set stringForColumn:@"coverForSharing"];
        video.date = [set stringForColumn:@"date"];
        video.description_ = [set stringForColumn:@"description_"];
        video.videoID = [set stringForColumn:@"videoID"];
        video.idx = [set stringForColumn:@"idx"];
        video.playUrl = [set stringForColumn:@"playUrl"];
        video.rawWebUrl = [set stringForColumn:@"rawWebUrl"];
        video.title = [set stringForColumn:@"title"];
        video.webUrl = [set stringForColumn:@"webUrl"];
        video.alias = [set stringForColumn:@"alias"];
        video.icon = [set stringForColumn:@"icon"];
        video.name = [set stringForColumn:@"name"];
        video.collectionCount = [set stringForColumn:@"collectionCount"];
        video.playCount = [set stringForColumn:@"playCount"];
        video.shareCount = [set stringForColumn:@"shareCount"];
        video.duration = [set intForColumn:@"duration"];
        
        [array addObject:video];
        NSLog(@"查询单个成功");
    }
    [set close];
    [db close];
    
    Video *video = array.firstObject;
    
    return video;
}
#pragma mark - 删除数据
- (void)deleteVideoWithID:(NSString *)videoID
{
    [db open];
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM ss_video WHERE videoID = '%@'", videoID];
    
    if ([db executeUpdate:sql]) {
        NSLog(@"删除成功");
    }
    [db close];
}

@end
