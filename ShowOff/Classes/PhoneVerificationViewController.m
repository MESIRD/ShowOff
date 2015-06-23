//
//  phoneVerificationViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/23.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "PhoneVerificationViewController.h"
#import "UserNamePasswordInputViewController.h"
#import "FlatUIKit.h"
#import "Utils.h"
#import <AVOSCloud/AVOSCloud.h>

@interface PhoneVerificationViewController ()

@end

@implementation PhoneVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set navigation bar color
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    
    //set back bar button item
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousPage)];
    [backButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor cloudsColor]} forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    
    //set verify bar button item
    UIBarButtonItem *verifyButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"验证" style:UIBarButtonItemStylePlain target:self action:@selector(verifySmsCode)];
    [verifyButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor cloudsColor]} forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:verifyButtonItem];
    
    //set navigation title
    self.navigationItem.title = @"手机验证";
    
    //set navigation title color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor cloudsColor]};
    
    //set get sms code button
    FUIButton *getSmsCodeButton = [[FUIButton alloc] initWithFrame:CGRectMake(249, 141, 40, 30)];
    getSmsCodeButton.buttonColor = [UIColor turquoiseColor];
    getSmsCodeButton.shadowColor = [UIColor greenSeaColor];
    getSmsCodeButton.shadowHeight = 3.0f;
    getSmsCodeButton.cornerRadius = 6.0f;
    getSmsCodeButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [getSmsCodeButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [getSmsCodeButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [getSmsCodeButton setTitle:@"获取" forState:UIControlStateNormal];
    [getSmsCodeButton setTitle:@"获取" forState:UIControlStateHighlighted];
    [getSmsCodeButton addTarget:self action:@selector(requestSmsCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getSmsCodeButton];
    
}

- (void)backToPreviousPage {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestSmsCode {
    
    if ( ![Utils judgePhoneNumberValidation:_phoneNumber.text]) {
        //show invalid phone number alert
        [Utils showFlatAlertView:@"错误" andMessage:@"无效的手机号码!"];
        return ;
    }
    
    //send varify code to the given phone number
    [AVOSCloud requestSmsCodeWithPhoneNumber:_phoneNumber.text
                                     appName:@"秀"
                                   operation:@"注册"
                                  timeToLive:10
                                    callback:^(BOOL succeeded, NSError *error) {
                                        if ( succeeded) {
                                            [Utils showSuccessOperationWithTitle:@"发送成功!" inSeconds:1 followedByOperation:nil];
                                        } else {
                                            NSLog(@"Send Sms Code Request Failed.");
                                            NSLog(@"Send SMS Code Log : %@", error);
                                        }
                                    }];
}

- (void)verifySmsCode {

//    if ([Utils isEmptyTextField:_phoneNumber]) {
//        [Utils showFlatAlertView:@"错误" andMessage:@"手机号码不能为空!"];
//        return ;
//    }
//    
//    if ( [Utils isEmptyTextField:_verifyCode]) {
//        [Utils showFlatAlertView:@"错误" andMessage:@"验证码不能为空!"];
//        return ;
//    }
//    
//    //varify the code
//    [AVOSCloud verifySmsCode:_verifyCode.text mobilePhoneNumber:_phoneNumber.text callback:^(BOOL succeeded, NSError *error) {
//        if ( succeeded) {
//            [Utils showSuccessOperationWithTitle:@"验证成功!" inSeconds:1 followedByOperation:^{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                UserNamePasswordInputViewController *userNamePasswordInputViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserNamePasswordInputViewController"];
                userNamePasswordInputViewController.phoneNumber = [_phoneNumber.text copy];
                [self.navigationController pushViewController:userNamePasswordInputViewController animated:YES];
//            }];
//        } else {
//            [Utils showFailOperationWithTitle:@"验证失败!" inSeconds:1 followedByOperation:nil];
//        }
//    }];
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
    if ( [segue destinationViewController] == [UserNamePasswordInputViewController class]) {
        UserNamePasswordInputViewController *userNamePasswordInputViewController = (UserNamePasswordInputViewController *)segue.destinationViewController;
        userNamePasswordInputViewController
    }
    
}
*/

@end
