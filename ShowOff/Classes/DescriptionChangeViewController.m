//
//  DescriptionChangeViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/24.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "DescriptionChangeViewController.h"
#import "Utils.h"
#import "Universal.h"
#import "UserPreference.h"
#import "MSDTextView.h"
#import <FlatUIKit/FlatUIKit.h>
#import <AVOSCLoud/AVOSCloud.h>

@interface DescriptionChangeViewController () <UITextFieldDelegate>

@property (nonatomic) MSDTextView *meDescription;

@end

@implementation DescriptionChangeViewController

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //set navigationitem title
    self.navigationItem.title = @"修改描述";
    
    //create text view
    _meDescription = [[MSDTextView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 180)];
    _meDescription.placeHolder = @"描述";
    _meDescription.text = _currentUserDescription;
    [self.view addSubview:_meDescription];
    
    //set background color
    [self.view setBackgroundColor:[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1]];
    
    //set complete button item
    UIBarButtonItem *completeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeChangeDescription)];
    [completeButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor cloudsColor]} forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:completeButtonItem];
}

- (void)completeChangeDescription {

    //change description operation
    if ([Utils isEmptyTextView:_meDescription]) {
        [Utils showFlatAlertView:@"错误" andMessage:@"描述内容不能为空!"];
        return ;
    }
    
    if ( [_currentUserDescription isEqualToString:_meDescription.text]) {
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    

    [Utils showProcessingOperation];
    AVQuery *query = [AVQuery queryWithClassName:@"UserPreference"];
    [query whereKey:@"belongedUser" equalTo:[AVUser currentUser]];
    AVObject *obj = [query findObjects][0];
    [obj setObject:_meDescription.text forKey:@"userDescription"];
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( succeeded) {
            [[UserPreference sharedUserPreference] setUserDescription:_meDescription.text];
            [[UserPreference sharedUserPreference] storeUserPreferenceInUserDefaults];
            [Utils hideProcessingOperation];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Change Description" object:nil];
            [Utils showSuccessOperationWithTitle:@"修改成功!" inSeconds:2 followedByOperation:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [Utils showFailOperationWithTitle:@"修改失败!\n请检查描述内容或网络设置." inSeconds:2 followedByOperation:nil];
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
