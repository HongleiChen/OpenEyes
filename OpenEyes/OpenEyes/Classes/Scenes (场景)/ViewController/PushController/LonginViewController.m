//
//  LonginViewController.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/11.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "LonginViewController.h"

#define kUserName @"username"
#define kPwd @"password"
#define kIsLogined @"login"

@interface LonginViewController ()<UITextFieldDelegate>
- (IBAction)leftButton:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
- (IBAction)longinButton:(UIButton *)sender;
- (IBAction)cancelButton:(UIButton *)sender;
- (IBAction)returnKeyboardTap:(UITapGestureRecognizer *)sender;


@end

@implementation LonginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置TextField代理
    self.userTextField.delegate = self;
    self.pwdTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - return键收回键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)leftButton:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)longinButton:(UIButton *)sender
{
    NSLog(@"登录");
    NSString *userName = _userTextField.text;
    NSString *pwd = _pwdTextField.text;
    
    NSString *savedUserName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    NSString *savedPwd = [[NSUserDefaults standardUserDefaults] objectForKey:kPwd];
    
    // 判断用户名和密码是否正确, 如果正确, 保存登陆状态
    if ([userName isEqualToString:savedUserName] && [pwd isEqualToString:savedPwd]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsLogined];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//        [alertView show];
        // 发送通知 改变头像
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LonginloadSortTVC" object:nil];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户名或密码错误" message:nil delegate:nil cancelButtonTitle:@"重新输入" otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (IBAction)cancelButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)returnKeyboardTap:(UITapGestureRecognizer *)sender {
    [_userTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
}
@end
