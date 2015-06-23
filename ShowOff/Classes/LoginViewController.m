//
//  LoginViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/23.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "LoginViewController.h"
#import "FlatUIKit.h"
#import "Utils.h"
#import <AVOSCloud/AVOSCloud.h>

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) FUITextField *userName;
@property (nonatomic, strong) FUITextField *password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set navigation bar color
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    
    //set navigation title
    self.navigationItem.title = @"登录";
    
    //set background color
    [self.view setBackgroundColor:[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1]];
    
    //set navigation title color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor cloudsColor]};
    
    //set back bar button item
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousPage)];
    [backButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor cloudsColor]} forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    
    
    FUIButton *completeButton = [[FUIButton alloc] initWithFrame:CGRectMake(40, 300, 240, 40)];
    [Utils configureFUIButton:completeButton withTitle:@"登录" target:self andAction:@selector(login)];
    [self.view addSubview:completeButton];
    
    _userName = [[FUITextField alloc] initWithFrame:CGRectMake(40, 140, 240, 40)];
    [Utils configureFUITextField:_userName withPlaceHolder:@"用户名"];
    [_userName setReturnKeyType:UIReturnKeyDone];
    [_userName setDelegate:self];
    
    UIImageView *userNameIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    userNameIcon.image = [UIImage imageNamed:@"username"];
    [_userName addSubview:userNameIcon];
    [self.view addSubview:_userName];
    
    _password = [[FUITextField alloc] initWithFrame:CGRectMake(40, 220, 240, 40)];
    [Utils configureFUITextField:_password withPlaceHolder:@"密码"];
    [_password setSecureTextEntry:YES];
    [_password setReturnKeyType:UIReturnKeyDone];
    [_password setDelegate:self];
    
    UIImageView *passwordIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    passwordIcon.image = [UIImage imageNamed:@"password"];
    [_password addSubview:passwordIcon];
    [self.view addSubview:_password];
}

- (void)backToPreviousPage {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)login {
    
    if ( [Utils isEmptyTextField:_userName]) {
        //show cannot use empty phone number
        [Utils showFlatAlertView:@"错误" andMessage:@"用户名不能为空!"];
        return ;
    }
    
    if ( [Utils isEmptyTextField:_password]) {
        //show cannot use empty password
        [Utils showFlatAlertView:@"错误" andMessage:@"密码不能为空!"];
        return ;
    }
    
    NSError *error = nil;
    [AVUser logInWithUsername:_userName.text password:_password.text error:&error];
    if ( error == nil) {
        [Utils showSuccessOperationWithTitle:@"登录成功!" inSeconds:1 followedByOperation:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"User Login" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        NSLog(@"Login Log : %@", error);
        [Utils showFlatAlertView:@"警告" andMessage:@"用户名或密码错误!"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end