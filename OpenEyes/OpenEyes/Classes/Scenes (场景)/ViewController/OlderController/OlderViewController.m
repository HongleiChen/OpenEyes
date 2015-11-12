//
//  OlderViewController.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/5.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "OlderViewController.h"
#import "OlderCell.h"
#import "OlderList.h"
#import "UIImageView+WebCache.h"
#import "OlderDetailViewController.h"
#import "AppDelegate.h"

#define kCellIdentifier @"cellIdentifier"
#define kBtween 5
#define kURL @"http://baobab.wandoujia.com/api/v1/categories?vc=67&v=1.7.0&f=iphone"

@interface OlderViewController ()

@property (nonatomic, retain) NSMutableArray *allDataArray;

@end

@implementation OlderViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // 修改导航条透明度
    self.tabBarController.tabBar.translucent = NO;
    
    [self loadData];
 
    // 注册自定义cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"OlderCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


#pragma mark - 解析数据

- (void)loadData
{
    NSURL *url = [NSURL URLWithString:kURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // typeof(self): 获取当前对象的类型
    __block typeof (self) weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data) {
            return;
        }
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        for (NSDictionary *item in array) {
            OlderList *olderList = [OlderList new];
            [olderList setValuesForKeysWithDictionary:item];
            [weakSelf.allDataArray addObject:olderList];
        }
        [self.collectionView reloadData];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _allDataArray.count;
}

#pragma mark - 给cell添加内容

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OlderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    OlderList *oldList = _allDataArray[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"#%@", oldList.name];
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:oldList.bgPicture]];
   
    
    return cell;
}

#pragma mark - 设置cell宽高

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width - kBtween) / 2, (self.view.frame.size.width - kBtween) / 2);
}

#pragma mark - 添加点击效果

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OlderDetailViewController *olderDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"OlderDetailVC"];
    OlderList *olderList = _allDataArray[indexPath.row];
    
    // 对name属性进行转码操作, 传到下一页面
    NSString *url = [olderList.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    olderDetailVC.typeURL = url;
    [self.navigationController pushViewController:olderDetailVC animated:YES];
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
