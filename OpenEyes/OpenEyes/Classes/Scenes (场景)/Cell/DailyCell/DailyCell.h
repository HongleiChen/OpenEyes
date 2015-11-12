//
//  DailyCell.h
//  OpenEyes
//
//  Created by lanou3g on 15/8/3.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
