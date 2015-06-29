//
//  PasswordChangeViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/26.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "PasswordChangeViewController.h"
#import "Universal.h"
#import "Utils.h"
#import <FlatUIKit/FUITextField.h>
#import <AVOSCloud/AVOSCloud.h>

@interface PasswordChangeViewController() <UITextFieldDelegate>

@property (nonatomic) FUITextField *originalPassword;
@property (nonatomic) FUITextField *changedPassword;
@property (nonatomic) FUITextField *repeatPassword;

@end

@implementation PasswordChangeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //any additional setup below
    
    //set view background color
    [self.view setBackgroundColor:[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1]];
    
    //configure three text fields
    _originalPassword = [[FUITextField alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 40)];
    [Utils configureFUITextField:_originalPassword withPlaceHolder:@"原密码" andIndent:YES];
    _originalPassword.returnKeyType = UIReturnKeyDone;
    _originalPassword.secureTextEntry = YES;
    _originalPassword.delegate = self;
    [self.view addSubview:_originalPassword];
    
    _changedPassword = [[FUITextField alloc] initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 40)];
    [Utils configureFUITextField:_changedPassword withPlaceHolder:@"新密码" andIndent:YES];
    _changedPassword.returnKeyType = UIReturnKeyDone;
    _changedPassword.secureTextEntry = YES;
    _changedPassword.delegate = self;
    [self.view addSubview:_changedPassword];
    
    _repeatPassword = [[FUITextField alloc] initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH, 40)];
    [Utils configureFUITextField:_repeatPassword withPlaceHolder:@"重复密码" andIndent:YES];
    _repeatPassword.returnKeyType = UIReturnKeyDone;
    _repeatPassword.secureTextEntry = YES;
    _repeatPassword.delegate = self;
    [self.view addSubview:_repeatPassword];
    
    //set navigation item title
    self.navigationItem.title = @"修改密码";
    
    //set complete bar button item
    UIBarButtonItem *completeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeChangePassword)];
    [self.navigationItem setRightBarButtonItem:completeButtonItem];
}

- (void)completeChangePassword {
    
    //password change operation
    if ([Utils isEmptyTextField:_originalPassword]) {
        [Utils showFlatAlertView:@"错误" andMessage:@"原密码不能为空!"];
        return ;
    }
    
    if ([Utils isEmptyTextField:_changedPassword]) {
        [Utils showFlatAlertView:@"错误" andMessage:@"新密码不能为空!"];
        return ;
    }
    
    if ([Utils isEmptyTextField:_repeatPassword]) {
        [Utils showFlatAlertView:@"错误" andMessage:@"重复密码不能为空!"];
        return ;
    }
    
    if ( ![_changedPassword.text isEqualToString:_repeatPassword.text]) {
        [Utils showFlatAlertView:@"错误" andMessage:@"重复密码与新密码不相同!"];
        return ;
    }
    
    if ( [_originalPassword.text isEqualToString:_changedPassword.text]) {
        [Utils showFlatAlertView:@"错误" andMessage:@"新密码与原密码相同!"];
        return ;
    }
    
    [Utils showProcessingOperation];
    AVUser *user = [AVUser currentUser];
    [user updatePassword:_originalPassword.text newPassword:_changedPassword.text block:^(id object, NSError *error) {
//        bject : {
//          objectId = 558cceb1e4b0de86abcae777;
//          updatedAt = "2015-06-26T11:04:22.785Z";
//        }
        [Utils hideProcessingOperation];
        if ( !error) {
            [Utils showSuccessOperationWithTitle:@"修改成功!" inSeconds:2 followedByOperation:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            NSLog(@"\nError:%@", error);
            switch ([[[error userInfo] objectForKey:@"code"] integerValue]) {
                case 210:
                    //The username and password mismatch
                    [Utils showFailOperationWithTitle:@"修改失败:\n用户名和密码不匹配" inSeconds:2 followedByOperation:nil];
                    break;
                default:
                    break;
            }
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

@end
