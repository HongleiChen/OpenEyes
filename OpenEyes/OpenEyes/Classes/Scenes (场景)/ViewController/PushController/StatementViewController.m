//
//  StatementViewController.m
//  OpenEyes
//
//  Created by lanou3g on 15/8/13.
//  Copyright (c) 2015年 Fred Chen. All rights reserved.
//

#import "StatementViewController.h"

@interface StatementViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)leftBarButton:(UIBarButtonItem *)sender;
@end

@implementation StatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)leftBarButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
