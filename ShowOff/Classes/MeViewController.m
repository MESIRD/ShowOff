//
//  MeViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "MeViewController.h"
#import "FlatUIKit.h"
#import "Universal.h"
#import "UserNamePasswordInputViewController.h"
#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "Utils.h"
#import <AVOSCloud/AVOSCloud.h>

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor cloudsColor]};
    self.navigationItem.title = @"个人";
    
    
    //add login and register buttons
    FUIButton *loginButton = [[FUIButton alloc] initWithFrame:CGRectMake(0.2 * SCREEN_WIDTH, 0.5 * SCREEN_HEIGHT, 80, 40)];
    [Utils configureFUIButton:loginButton withTitle:@"登录" target:self andAction:@selector(turnToLoginPage)];
    
    FUIButton *registerButton = [[FUIButton alloc] initWithFrame:CGRectMake(0.6 * SCREEN_WIDTH, 0.5 * SCREEN_HEIGHT, 80, 40)];
    [Utils configureFUIButton:registerButton withTitle:@"注册" target:self andAction:@selector(turnToRegisterPage)];
    
    [_unlogView addSubview:loginButton];
    [_unlogView addSubview:registerButton];

    if ([AVUser currentUser]) {
        [_unlogView setHidden:YES];
        [_meTableView setHidden:NO];
    } else {
        [_meTableView setHidden:YES];
        [_unlogView setHidden:NO];
    }
    
    
    //reigster notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:@"User Login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:@"User Logout" object:nil];
}

- (void)turnToLoginPage {
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)turnToRegisterPage {
    
    UserNamePasswordInputViewController *userNamePasswordInputViewController = [[UserNamePasswordInputViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userNamePasswordInputViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)userLogin {
    
    [_meTableView setHidden:NO];
    [_meTableView reloadData];
    [_unlogView setHidden:YES];
}

- (void)userLogout {

    [_meTableView setHidden:YES];
    [_unlogView setHidden:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ( [segue.identifier isEqualToString:@"meToUserInfoSegue"]) {
        if ( [segue.destinationViewController isKindOfClass:[UserInfoViewController class]]) {
            UserInfoViewController *vc = (UserInfoViewController *)segue.destinationViewController;
            vc.user = [AVUser currentUser];
        }
    }
}


@end
