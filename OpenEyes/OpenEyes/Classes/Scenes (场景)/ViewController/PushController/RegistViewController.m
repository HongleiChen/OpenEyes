//
//  RegistViewController.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "RegistViewController.h"

#define kUserName @"username"
#define kPwd @"password"
#define kIsLogined @"login"

@interface RegistViewController ()<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (IBAction)LeftItemButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextfield;
- (IBAction)registButton:(UIButton *)sender;
- (IBAction)cancelButton:(UIButton *)sender;
- (IBAction)choosePicTap:(UITapGestureRecognizer *)sender;
- (IBAction)returnKeyboardTap:(UITapGestureRecognizer *)sender;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置TextField代理
    self.pswTextfield.delegate = self;
    self.userTextField.delegate = self;
    
    // 设置图片圆角
    _imageView.layer.cornerRadius = 20;
    _imageView.layer.masksToBounds = YES;
    
    // 判断是否已经登陆, 设置图片内容
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kIsLogined]) {
        _imageView.image = [UIImage imageNamed:@"test"];
    } else {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"aaa"]) {
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"aaa"];
        _imageView.image = [UIImage imageWithData:imageData];
    }
    }
}

- (IBAction)returnKeyboardTap:(UITapGestureRecognizer *)sender
{
    [_userTextField resignFirstResponder];
    [_pswTextfield resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)LeftItemButton:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registButton:(UIButton *)sender
{
    NSLog(@"注册");
    // 获取用户名与密码
    NSString *userNameStr = _userTextField.text;
    NSString *pwdStr = _pswTextfield.text;
    
    if (userNameStr.length == 0 || pwdStr.length == 0) {
        // 提示用户
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空" message:nil delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil];
        [alertView show];
    } else {
    // 保存到本地
    [[NSUserDefaults standardUserDefaults] setObject:userNameStr forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] setObject:pwdStr forKey:kPwd];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLogined];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegistreloadSortTVC" object:nil];
        
    // 推出页面
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击图片事件
- (IBAction)choosePicTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"点击了图片");
    
    UIActionSheet *sheet;
    // 判断是否支持相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        // 需要遵循<UIActionSheetDelegate>
        /**
         * title: 表格标题
         * delegate: 代理
         * cancelButtonTitle: 取消按钮标题
         * destuctiveButtonTitle: 退出按钮标题
         * otherButtonTitle: 其他按钮标题
         */
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    // 需要加showInView (UIAlertView 的 show 方法)
    [sheet showInView:self.view];
}

#pragma mark - 实现actionSheet delegate事件 (<UIActionSheetDelegate>代理方法) 点击sheet触发该方法
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        
        // 判断是否可以使用相册
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
    
            if (buttonIndex == 0) {
                // 如果是第一个按钮, 该方法执行完毕, 下面的程序都不会执行
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        // 需要遵循<UINavigationControllerDelegate ,UIImagePickerControllerDelegate>代理
        imagePickerController.delegate = self;
        // 是否可以编辑
        imagePickerController.allowsEditing = YES;
        // 给UIImagePickerController 创建的对象添加枚举值, 用来判断触发某种状态
        imagePickerController.sourceType = sourceType;
        
        // 推出指定页面
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - 实现ImagePicker delegate 事件 (<UINavigationControllerDelegate ,UIImagePickerControllerDelegate>代理方法) 点击图片触发该方法

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 点击图片收回模态
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 得到图片数据
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /*
//    // 保存图片至本地，方法见下文
//    [self saveImage:image withName:@"currentImage.png"];
//    
//    // 获取路径, 取出照片数据
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
//    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
     */
    // 压缩图片为PNG类型
    NSData *imageData = UIImagePNGRepresentation(image);
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"aaa"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 取出数据赋值
    [self.imageView setImage:image];
    
}

// 用户点击图像选取器中的“cancel”按钮时被调用，这说明用户想要中止选取图像的操作 .....什么鬼
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - 保存图片至沙盒

//- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
//{
//    // 压缩图片为PNG类型
//    NSData *imageData = UIImagePNGRepresentation(currentImage);
//    // 获取沙盒目录
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
//    NSLog(@"%@", fullPath);
//    // 将图片写入文件
//    [imageData writeToFile:fullPath atomically:NO];
//}
*/

@end
