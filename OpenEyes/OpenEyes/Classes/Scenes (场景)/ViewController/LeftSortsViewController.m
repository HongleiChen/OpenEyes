//
//  OlderCell.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/5.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//
#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "OtherViewController.h"
#import "RegistViewController.h"
#import "LonginViewController.h"
#import "UIImage+NJ.h"
#import "UIImageView+WebCache.h"
#import "ToIntroViewController.h"
#import "StatementViewController.h"

#define kIsLogined @"login"

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSData *imageData;
@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:imageview];

    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
    // 监听某个通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"RegistreloadSortTVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction2:) name:@"LonginloadSortTVC" object:nil];
}

- (void)notificationAction:(NSNotification *)sender
{
    
    _imageView.image = [UIImage imageWithData:_imageData];
    [self.tableview reloadData];
    // 删除通知监听
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)notificationAction2:(NSNotification *)sender
{
    
    _imageView.image = [UIImage imageWithData:_imageData];
    [self.tableview reloadData];
    // 删除通知监听
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置Cell上的内容
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"注册";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"登录";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"我的收藏";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"清除缓存";
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"关于我们";
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"免责声明";
    } else if (indexPath.row == 6) {
        cell.textLabel.text = @"注销";
    }
    return cell;
}

#pragma mark - 设置点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RegistViewController *registVC = [storyboard instantiateViewControllerWithIdentifier:@"RegistVC"];
        UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:registVC];
        
        [self presentViewController:NVC animated:YES completion:nil];
    } else if (indexPath.row == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LonginViewController *longinVC = [storyboard instantiateViewControllerWithIdentifier:@"LonginVC"];
        UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:longinVC];
        
        [self presentViewController:NVC animated:YES completion:nil];
    } else if (indexPath.row == 2) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kIsLogined]) {
            // 提示用户登陆
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请您登陆后操作" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alertView show];
        } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OtherViewController *otherVC = [storyboard instantiateViewControllerWithIdentifier:@"OtherVC"];
        UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:otherVC];
        
        [self presentViewController:NVC animated:YES completion:nil];
            
        }
    } else if (indexPath.row == 3) {
        [self clearCache];
    } else if (indexPath.row == 4) {
        self.navigationController.navigationBar.hidden = YES;
        ToIntroViewController *introViewController = [[ToIntroViewController alloc] init];
        
        [self presentViewController:introViewController animated:YES completion:nil];
    } else if (indexPath.row == 5) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StatementViewController *statementVC = [storyboard instantiateViewControllerWithIdentifier:@"StatementVC"];
        UINavigationController *NVC = [[UINavigationController alloc] initWithRootViewController:statementVC];
        
        [self presentViewController:NVC animated:YES completion:nil];
    } else if (indexPath.row == 6) {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsLogined];
        _imageView.image = [UIImage imageNamed:@"test"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注销成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    }
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉

}
#pragma mark - 设置头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}
#pragma mark - 设置头视图内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    
    self.imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"aaa"];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imageView.layer.masksToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.center = CGPointMake(self.tableview.bounds.size.width / 2, view.bounds.size.height / 1.3);
    _imageView.transform=CGAffineTransformMakeRotation(M_PI_2);
    [view addSubview:_imageView];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsLogined]) {
        _imageView.image = [UIImage imageWithData:_imageData];
    } else {
        _imageView.image = [UIImage imageNamed:@"test"];
    }
    
    
    return view;
}

// 清除缓存方法
- (void)clearCache{
    
    UIAlertController *alerttC = [UIAlertController alertControllerWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"缓存大小%.1fM,是否清除?",((CGFloat)[[SDImageCache sharedImageCache] getSize]) / 1024.0 / 1024.0] preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        
        
        
    }];
    
    UIAlertAction *ok= [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        
        dispatch_async(
                       dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                       , ^{
                           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                           
                           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                           
                           for (NSString *p in files) {
                               NSError *error;
                               NSString *path = [cachPath stringByAppendingPathComponent:p];
                               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                               }
                           }
                           [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
        
    }];
    
    [alerttC addAction:cancel];
    [alerttC addAction:ok];
    
//        [alerttC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = @"password";
//        }];
    
    [self presentViewController:alerttC animated:YES completion:nil];
}

// 缓存清除成功
-(void)clearCacheSuccess
{
    
    UIAlertView * alertView = [[ UIAlertView alloc ] initWithTitle : @" 提示 " message : @" 缓存清理完毕 " delegate : nil cancelButtonTitle : @" 确定 " otherButtonTitles : nil ];
    
    [alertView show ];
    
}

@end
