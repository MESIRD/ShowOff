//
//  UserNamePasswordInputViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/23.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "UserNamePasswordInputViewController.h"
#import "Utils.h"
#import "FlatUIKit.h"
#import "UserPreference.h"
#import <AVOSCloud/AVOSCloud.h>

@interface UserNamePasswordInputViewController () <UITextFieldDelegate>

@property (nonatomic, strong) FUITextField *userName;
@property (nonatomic, strong) FUITextField *password;

@end

@implementation UserNamePasswordInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set navigation bar color
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    
    //set background color
    [self.view setBackgroundColor:[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1]];
    
    //set back button item
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(backToPreviousPage)];
    [backButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor cloudsColor]} forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    
    //set navigation title
    self.navigationItem.title = @"注册";
    
    //set navigation title color
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor cloudsColor]};
    
    //create a complete button
    FUIButton *completeButton = [[FUIButton alloc] initWithFrame:CGRectMake(40, 300, 240, 40)];
    [Utils configureFUIButton:completeButton withTitle:@"注册" target:self andAction:@selector(completeUserRegister)];
    [self.view addSubview:completeButton];
    
    _userName = [[FUITextField alloc] initWithFrame:CGRectMake(40, 140, 240, 40)];
    [Utils configureFUITextField:_userName withPlaceHolder:@"用户名" andIndent:YES];
    [_userName setReturnKeyType:UIReturnKeyDone];
    [_userName setDelegate:self];
    
    UIImageView *userNameIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    userNameIcon.image = [UIImage imageNamed:@"username"];
    [_userName addSubview:userNameIcon];
    [self.view addSubview:_userName];
    
    _password = [[FUITextField alloc] initWithFrame:CGRectMake(40, 220, 240, 40)];
    [Utils configureFUITextField:_password withPlaceHolder:@"密码" andIndent:YES];
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

- (void)completeUserRegister {
    
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
    
    AVUser *user = [AVUser user];
    user.username = _userName.text;
    user.password = _password.text;
    user.mobilePhoneNumber = _phoneNumber;
    
    [Utils showProcessingOperation];
    
    NSError *error = nil;
    if ( [user signUp:&error]) {
        [Utils showSuccessOperationWithTitle:@"注册成功!" inSeconds:1 followedByOperation:^{
            
            /*
             self.userNickName = userName;
             self.userDescription = @"在干什么...";
             self.userAvatarURL = @"";
             self.userBackgroundColor = @"103,99,76";
             self.userGender = @"保密";
             self.userSexualOrientation = @"保密";
             self.viewNumber = 0;
             self.appreciateNumber = 0;
             */
            
            //create user preference
            AVObject *obj = [AVObject objectWithClassName:@"UserPreference"];
            [obj setObject:_userName.text forKey:@"userNickName"];
            [obj setObject:@"在干什么..." forKey:@"userDescription"];
            [obj setObject:@"" forKey:@"userAvatarURL"];
            [obj setObject:@"103,99,76" forKey:@"userBackgroundColor"];
            [obj setObject:@"保密" forKey:@"userGender"];
            [obj setObject:@"保密" forKey:@"userSexualOrientation"];
            [obj setObject:@0 forKey:@"viewNumber"];
            [obj setObject:@0 forKey:@"appreciateNumber"];
            [obj setObject:[AVUser currentUser] forKey:@"belongedUser"];
            [obj saveInBackground];
            
            //login user
            NSError *login_error = nil;
            [AVUser logInWithUsername:_userName.text password:_password.text error:&login_error];
            if ( login_error) {
                //login failed
                NSLog(@"------登录失败!------");
            } else {
                //login successfully
                
                //save user preference in user defaults
                UserPreference *userPreference = [[UserPreference alloc] initWithAVObject:obj];
                [userPreference storeUserPreferenceInUserDefaults];
                
                //post notification
                [[NSNotificationCenter defaultCenter] postNotificationName:@"User Login" object:nil];
            }
            
            [Utils hideProcessingOperation];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        NSLog(@"Register Log : %@", error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
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
