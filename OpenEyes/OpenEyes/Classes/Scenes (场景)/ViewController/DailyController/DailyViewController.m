//
//  DailyViewController.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/3.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "DailyViewController.h"
#import "DailyCell.h"
#import "Video.h"
#import "DailyList.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "UINavigationController+Push__Pop.h"
#import "MJRefresh.h"
#import "AppDelegate.h"



#define kCellIdentifier @"cellIdentifier"
#define kMainUrl(date, number) [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v1/feed?num=10&date=%@&vc=67&v=1.7.0&f=iphone&start=%ld", date, number]

@interface DailyViewController ()
@property (nonatomic, retain) NSMutableArray *videosArray;
// 二维数组
@property (nonatomic, retain) NSMutableArray *allDataArray;

@property (nonatomic, retain) NSMutableArray *dailyListArray;

@property (nonatomic, assign) NSInteger number;

@end

@implementation DailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 修改导航条透明度
    self.tabBarController.tabBar.translucent = NO;
    
    [self loadData];
 
    // 注册自定义cell
    [self.tableView registerNib:[UINib nibWithNibName:@"DailyCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    //下拉刷新, 上拉加载
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}



#pragma mark - 实现下拉刷新, 上拉加载
- (void)headerRereshing
{
    // 加载时延迟一秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 在主线程中
        // 刷新表格
        // 注意: 如果子类中需要刷新数据, 需要重写这个 - (void)headerRereshing 方法
        [self.tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 在主线程中
        
        _number = _number - 86400 * 10;
        // 刷新表格
        // 注意: 如果子类中需要刷新数据, 需要重写这个 - (void)headerRereshing 方法
        [self loadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });   
}

#pragma mark - 载入数据
- (void)loadData
{
    // 获取当前时间
    NSDate *senddate = [NSDate date];
    NSDate *before = [senddate dateByAddingTimeInterval:_number];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString = [dateformatter stringFromDate:before];
    
    NSURL *url = [NSURL URLWithString:kMainUrl(locationString, _number)];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // typeof(self): 获取当前对象的类型
    __block typeof (self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前网络不可用" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alertView show];
            alertView = nil;
            return;
        }
        
        // 获取解析数据
        NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        // 封装dailyList模型
        for (NSDictionary *dict in dicts[@"dailyList"]) {
            DailyList *dailyList = [DailyList new];
            [dailyList setValuesForKeysWithDictionary:dict];
            [weakSelf.dailyListArray addObject:dailyList];
            
        }
        // 封装video模型
        for (NSDictionary *dict in dicts[@"dailyList"]) {
            weakSelf.videosArray = [NSMutableArray array];
            for (NSDictionary *item in dict[@"videoList"]) {
                Video *video = [Video new];
                [video setValuesForKeysWithDictionary:item];
                [_videosArray addObject:video];
            }
            [weakSelf.allDataArray addObject:_videosArray];
        }
        [weakSelf.tableView reloadData];
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _allDataArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_allDataArray[section] count];
    
}

#pragma mark - 设置cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消点中效果
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DailyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[DailyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    
    Video *video = _allDataArray[indexPath.section][indexPath.row];
    cell.titleLabel.text = video.title;
    
    int time = video.duration;
    NSString *times = [NSString stringWithFormat:@"%02d'%02d''", time / 60, time % 60];
    NSString *type = [NSString stringWithFormat:@"# %@ / %@", video.category, times];
    cell.typeLabel.text = type;
    
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:video.coverForDetail]];
    
    return cell;
}


#pragma mark - 设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.width * 0.7;
}
#pragma mark - 设置头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 35;
}


#pragma mark - 设置HeaderView的title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    DailyList *dailyList = _dailyListArray[section];
    NSString *time = [NSString stringWithFormat:@"%@", dailyList.date];
    NSString *sences = [time substringWithRange:NSMakeRange(0, 10)];
    
    // 1. 创建时间转换的对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 2. 设置时间格式串时间
    [formatter setDateFormat:@"MM月dd日"];
    NSDate *times = [NSDate dateWithTimeIntervalSince1970:[sences integerValue]];
    // 将NSDate转换为NSString
    NSString *nowDateStr = [formatter stringFromDate:times];

    return nowDateStr;
}

/*
#pragma mark - 设置HeaderView中的Label居中, 并设置Label显示的内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
{
    DailyList *dailyList = _dailyListArray[section];
    NSString *time = [NSString stringWithFormat:@"%@", dailyList.date];
    NSString *sences = [time substringWithRange:NSMakeRange(0, 10)];
    
    // 1. 创建时间转换的对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 2. 设置时间格式串时间
    [formatter setDateFormat:@"MM月dd日"];
    NSDate *times = [NSDate dateWithTimeIntervalSince1970:[sences integerValue]];
    // 将NSDate转换为NSString
    NSString *nowDateStr = [formatter stringFromDate:times];
    
     //section text as a label
    UILabel *label = [[UILabel alloc] init];
    label.text = nowDateStr;
    label.font = [UIFont boldSystemFontOfSize:35.0f];
    label.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    [tableView.tableHeaderView addSubview:label];
    
    return tableView.tableHeaderView;
    
}
*/

#pragma mark - 点击cell事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    detailVC.video = _allDataArray[indexPath.section][indexPath.row];
    // 推出子控制器是隐藏tabBar
//    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animatedWithTransition:UIViewAnimationTransitionFlipFromLeft];

}


#pragma mark - 懒加载

- (NSMutableArray *)allDataArray
{
    if (!_allDataArray) {
        self.allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}

- (NSMutableArray *)dailyListArray
{
    if (!_dailyListArray) {
        self.dailyListArray = [NSMutableArray array];
    }
    return _dailyListArray;
}

@end
