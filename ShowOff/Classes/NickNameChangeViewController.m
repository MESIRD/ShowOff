//
//  NickNameChangeViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/24.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "NickNameChangeViewController.h"
#import "Utils.h"
#import "Universal.h"
#import "UserPreference.h"
#import <FlatUIKit/FlatUIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface NickNameChangeViewController () <UITextFieldDelegate>

@property (nonatomic) FUITextField *nickName;

@end

@implementation NickNameChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set navigationitem title
    self.navigationItem.title = @"修改昵称";
    
    //create textfield
    _nickName = [[FUITextField alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 40)];
    [Utils configureFUITextField:_nickName withPlaceHolder:@"昵称" andIndent:YES];
    _nickName.delegate = self;
    _nickName.returnKeyType = UIReturnKeyDone;
    _nickName.text = _currentNickName;
    [self.view addSubview:_nickName];
    
    
    //set background color
    [self.view setBackgroundColor:[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1]];
    
    //set complete button item
    UIBarButtonItem *completeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeChangeNickName)];
    [completeButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor cloudsColor]} forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:completeButtonItem];
}

- (void)completeChangeNickName {
    
    //nick name change operation
    if ([Utils isEmptyTextField:_nickName]) {
        [Utils showFlatAlertView:@"错误" andMessage:@"昵称不能为空!"];
        return ;
    }
    
    if ( [_currentNickName isEqualToString:_nickName.text]) {
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    
    [Utils showProcessingOperation];
    AVQuery *query = [AVQuery queryWithClassName:@"UserPreference"];
    [query whereKey:@"belongedUser" equalTo:[AVUser currentUser]];
    AVObject *obj = [query findObjects][0];
    [obj setObject:_nickName.text forKey:@"userNickName"];
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( succeeded) {
            [[UserPreference sharedUserPreference] setUserNickName:_nickName.text];
            [[UserPreference sharedUserPreference] storeUserPreferenceInUserDefaults];
            [Utils hideProcessingOperation];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Change Nick Name" object:nil];
            [Utils showSuccessOperationWithTitle:@"修改成功!" inSeconds:2 followedByOperation:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [Utils showFailOperationWithTitle:@"修改失败!\n请检查昵称或网络设置." inSeconds:2 followedByOperation:nil];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
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
