//
//  OtherViewController.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/8.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "OtherViewController.h"
#import "DBHelper.h"
#import "Video.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "UINavigationController+Push__Pop.h"

#define kCellIdentifier @"cellIdentifier"
@interface OtherViewController ()

@property (nonatomic, retain) NSMutableArray *allDataArray;
@property (nonatomic, assign) NSInteger number;

@end

@implementation OtherViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    // 添加右边编辑按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(editAction:)];
    
    // 监听某个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"reloadOtherTVC" object:nil];
}

#pragma mark - 载入数据
- (void)loadData
{
    NSArray *array = [[DBHelper sharedDBHelper] selectAllVideoes];
    self.allDataArray = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];

    
}

#pragma mark - 监听事件
- (void)notificationAction:(NSNotification *)sender
{
    // 删除数组中的元素
    Video *video = sender.userInfo[@"key"];
    for (Video *item in _allDataArray) {
        if ([item.videoID isEqual:video.videoID]) {
            _number = [_allDataArray indexOfObject:item];
        }
    }
    [_allDataArray removeObjectAtIndex:_number];
    
    [self.tableView reloadData];
    
    // 删除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - 设置导航栏右侧按键功能
- (void)editAction:(UIBarButtonItem *)sender
{
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    
    if ([sender.title isEqualToString:@"Edit"]) {
        sender.title = @"Done";
    } else {
        sender.title = @"Edit";
    }
    
}

#pragma mark - 设置tableViewCell数据

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _allDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
    }
    
    Video *video = _allDataArray[indexPath.row];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = video.title;
    
    int time = video.duration;
    NSString *times = [NSString stringWithFormat:@"%02d'%02d''", time / 60, time % 60];
    NSString *type = [NSString stringWithFormat:@"# %@ / %@", video.category, times];
    cell.detailTextLabel.text = type;
    
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.layer.masksToBounds = YES;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:video.coverForDetail]];
    
    
    
    return cell;
}

#pragma mark - 点击cell事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"detailVC"];
    detailVC.video = _allDataArray[indexPath.row];
    // 设置推出动画
    [self.navigationController pushViewController:detailVC animatedWithTransition:UIViewAnimationTransitionFlipFromLeft];
}


#pragma mark - 设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - 取消界面按钮功能
- (IBAction)disMissView:(UIBarButtonItem *)sender {
    
//    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 删除相关方法
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"来世再见";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 操作数据库中的值
    Video *video = _allDataArray[indexPath.row];
    [[DBHelper sharedDBHelper] deleteVideoWithID:video.videoID];
    // 删除页面当前值
    [_allDataArray removeObjectAtIndex:indexPath.row];
    
    // 更新页面
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
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
