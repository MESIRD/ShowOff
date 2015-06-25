//
//  MeInfoViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/24.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "MeInfoViewController.h"
#import "MeInfoTableView.h"
#import "MeInfoSettingTableViewController.h"
#import "Utils.h"
#import "UserPreference.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AVOSCloud/AVOSCloud.h>

@interface MeInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *unPostView;
@property (weak, nonatomic) IBOutlet MeInfoTableView *meInfoTableView;

@end

@implementation MeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set navigationbar tint color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //set navigation item title
    self.navigationItem.title = [[AVUser currentUser] username];
    
    //configure setting bar button item
    UIBarButtonItem *settingButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(pushToSettingPage)];
    [self.navigationItem setRightBarButtonItem:settingButtonItem];

    //configure header view
    [self configureHeaderView];
    
    //hide Unpost View
    [_unPostView setHidden:YES];    
    
    //register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNoPosts)       name:@"Me Post Number Zero" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNickName)    name:@"Change Nick Name"    object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDescription) name:@"Change Description"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAvatar)      name:@"Change Avatar"       object:nil];
}

- (void)updateNickName {
    
    _nickName.text = [[UserPreference sharedUserPreference] userNickName];
}

- (void)updateDescription {
    
    _userDescription.text = [[UserPreference sharedUserPreference] userDescription];
}

- (void)updateAvatar {
    
    [_avatar setImageWithURL:[NSURL URLWithString:[[UserPreference sharedUserPreference] userAvatarURL]] placeholderImage:[UIImage imageNamed:@"default_avatar_circle"]];
}

- (void)configureHeaderView {
    
    AVQuery *query = [AVQuery queryWithClassName:@"UserPreference"];
    [query whereKey:@"belongedUser" equalTo:[AVUser currentUser]];
    AVObject *userPreference = [query findObjects][0];
    _nickName.text = [userPreference objectForKey:@"userNickName"];
    _userDescription.text = [userPreference objectForKey:@"userDescription"];
    [_avatar setImageWithURL:[NSURL URLWithString:[userPreference objectForKey:@"userAvatarURL"]] placeholderImage:[UIImage imageNamed:@"default_avatar_circle"]];
    _viewNumber.text = [NSString stringWithFormat:@"%@", [userPreference objectForKey:@"viewNumber"]];
    _appreciateNumber.text = [NSString stringWithFormat:@"%@", [userPreference objectForKey:@"appreciateNumber"]];
    NSArray *rgb = [[userPreference objectForKey:@"userBackgroundColor"] componentsSeparatedByString:@","];
    _backgroundImage.image = [Utils getImageFilledByColor:[UIColor colorWithRed:[rgb[0] floatValue]/255 green:[rgb[1] floatValue]/255 blue:[rgb[2] floatValue]/255 alpha:1]];
}

- (void)showNoPosts {
    
    [_unPostView setHidden: NO];
    [_meInfoTableView setHidden:YES];
}

- (void)pushToSettingPage {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MeInfoSettingTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MeInfoSettingTableViewController"];
    [self.navigationController pushViewController:vc animated:YES];
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