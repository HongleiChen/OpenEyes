//
//  Video.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/4.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "Video.h"

@implementation Video

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.description_ = value;
    } else if ([key isEqualToString:@"provider"]) {
        
        NSDictionary *dict = (NSDictionary *)value;
        self.alias = dict[@"alias"];
        self.icon = dict[@"icon"];
        self.name = dict[@"name"];
    } else if ([key isEqualToString:@"consumption"]) {
        
        NSDictionary *dict = (NSDictionary *)value;
        self.collectionCount = dict[@"collectionCount"];
        self.playCount = dict[@"playCount"];
        self.shareCount = dict[@"shareCount"];
    } else if([key isEqualToString:@"id"]) {
        self.videoID = value;
    }
        
}

//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"'%@', '%@', '%@', '%@', '%@', '%@', '%@', '%d', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@'", _category, _coverBlurred, _coverForDetail, _coverForFeed, _coverForSharing, _date, _description_, _duration, _videoID, _idx, _playUrl, _rawWebUrl, _title, _webUrl, _alias, _icon, _name, _collectionCount, _playCount, _shareCount];
//}
@end
