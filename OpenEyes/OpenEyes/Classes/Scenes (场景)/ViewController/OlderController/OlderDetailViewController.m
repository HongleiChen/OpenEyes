//
//  OlderDetailViewController.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/5.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "OlderDetailViewController.h"
#import "Video.h"
#import "DailyCell.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "UINavigationController+Push__Pop.h"
#import "MJRefresh.h"

#define kOlderURL(ID, number) [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v1/videos?categoryName=%@&num=10&vc=67&net=wifi&v=1.7.0&f=iphone&start=%ld", ID, number]
#define kCellIdentifier @"cellIdentifier"
@interface OlderDetailViewController ()

@property (nonatomic, retain) NSMutableArray *videosArray;
@property (nonatomic, retain) NSMutableArray *allDataArray;

@property (nonatomic, assign) NSInteger number;

@end

@implementation OlderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    // UTF8反编译, 得到字符串用于拼接网址
    self.navigationItem.title = [_typeURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
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
        
        _number = _number + 10;
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
    NSURL *url = [NSURL URLWithString:kOlderURL(_typeURL, _number)];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // typeof(self): 获取当前对象的类型
    __block typeof (self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data) {
            return;
        }
        
        NSDictionary *dicts = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
       
        
            for (NSDictionary *item in dicts[@"videoList"]) {
                Video *video = [Video new];
                [video setValuesForKeysWithDictionary:item];
                [weakSelf.allDataArray addObject:video];
                
            }
        [weakSelf.tableView reloadData];
    }];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _allDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DailyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[DailyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    
    Video *video = _allDataArray[indexPath.row];
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

#pragma mark - 点击cell事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"detailVC"];;
    detailVC.video = _allDataArray[indexPath.row];
    // 推出子控制器是隐藏tabBar
//    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animatedWithTransition:UIViewAnimationTransitionFlipFromLeft];
    //    [detailVC showView];
}
#pragma mark - 懒加载

- (NSMutableArray *)allDataArray
{
    if (!_allDataArray) {
        self.allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}
@end
