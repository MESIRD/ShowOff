//
//  UserInfoViewController.m
//  ShowOff
//
//  Created by xujie on 15/7/2.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoTableView.h"
#import "MeInfoSettingTableViewController.h"
#import "Utils.h"
#import "UserPreference.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVOSCloud/AVOSCloud.h>

@interface UserInfoViewController ()
{
    BOOL isSelf;
}

@property (weak, nonatomic) IBOutlet UIView *unPostView;
@property (weak, nonatomic) IBOutlet UserInfoTableView *userInfoTableView;

@end

@implementation UserInfoViewController

- (void)setUser:(AVUser *)user {
    
    _user = user;
    AVUser *currentUser = [AVUser currentUser];
    if ( currentUser && [_user.username isEqualToString:currentUser.username]) {
        isSelf = YES;
    } else {
        isSelf = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //set navigationbar tint color
    [self.navigationController.navigationBar setTintColor:[UIColor cloudsColor]];
    
    //set navigation item title color
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor cloudsColor]}];
    
    //configure setting bar button item
    if ( isSelf) {
        UIButton *settingButton = [Utils getCustomBarButtonViewWithTitle:@"设置" target:self andAction:@selector(pushToSettingPage)];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:settingButton]];
    }
    
    _avatar.layer.cornerRadius = _avatar.frame.size.height/2;
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.borderColor = [UIColor cloudsColor].CGColor;
    _avatar.layer.borderWidth = 3.0;
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
    
    //configure header view
    [self configureHeaderView];
    
    //hide Unpost View
    [_unPostView setHidden:YES];
    
    //set user to UserInfoTableView
    _userInfoTableView.user = _user;
    [_userInfoTableView fetchNewestMePosts];
    
    //register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNoPosts)       name:@"Me Post Number Zero"     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNickName)    name:@"Change Nick Name"        object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDescription) name:@"Change Description"      object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAvatar)      name:@"Change Avatar"           object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBackgroundColor)      name:@"Change Background Color" object:nil];
}

- (void)updateNickName {
    
    _nickName.text = [[UserPreference sharedUserPreference] userNickName];
    self.navigationItem.title = [[UserPreference sharedUserPreference]userNickName];
}

- (void)updateDescription {
    
    _userDescription.text = [[UserPreference sharedUserPreference] userDescription];
}

- (void)updateAvatar {
    
    [_avatar sd_setImageWithURL:[NSURL URLWithString:[[UserPreference sharedUserPreference] userAvatarURL]] placeholderImage:[UIImage imageNamed:@"default_avatar_circle"]];
}

- (void)updateBackgroundColor {
    
    NSArray *rgb = [[[UserPreference sharedUserPreference] userBackgroundColor] componentsSeparatedByString:@","];
    [_backgroundImage setImage:[Utils getImageFilledByColor:[UIColor colorWithRed:[rgb[0] floatValue]/255 green:[rgb[1] floatValue]/255 blue:[rgb[2] floatValue]/255 alpha:1]]];
}

- (void)configureHeaderView {
    
    if (isSelf) {
        //if this is user self
        //set title
        self.navigationItem.title = [[UserPreference sharedUserPreference] userNickName];
        _nickName.text = [[UserPreference sharedUserPreference] userNickName];
        _userDescription.text = [[UserPreference sharedUserPreference] userDescription];
        //calculate string height
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"avatar_%@.png", [[AVUser currentUser] username]]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ( [fileManager fileExistsAtPath:filePath]) {
            _avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
        } else {
            _avatar.image = [UIImage imageNamed:@"default_avatar_circle"];
        }
        _viewNumber.text = [NSString stringWithFormat:@"%ld", [[UserPreference sharedUserPreference] viewNumber]];
        _appreciateNumber.text = [NSString stringWithFormat:@"%ld", [[UserPreference sharedUserPreference] appreciateNumber]];
        NSArray *rgb = [[[UserPreference sharedUserPreference] userBackgroundColor] componentsSeparatedByString:@","];
        _backgroundImage.image = [Utils getImageFilledByColor:[UIColor colorWithRed:[rgb[0] floatValue]/255 green:[rgb[1] floatValue]/255 blue:[rgb[2] floatValue]/255 alpha:1]];
    } else {
        //if this is other user
        AVQuery *query = [AVQuery queryWithClassName:@"UserPreference"];
        [query whereKey:@"belongedUser" equalTo:_user];
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if ( !error) {
                //set title
                self.navigationItem.title = [object objectForKey:@"userNickName"];
                _nickName.text = [object objectForKey:@"userNickName"];
                _userDescription.text = [object objectForKey:@"userDescription"];
                [_avatar sd_setImageWithURL:[NSURL URLWithString:[object objectForKey:@"userAvatarURL"]] placeholderImage:[UIImage imageNamed:@"default_avatar_circle"]];
                _viewNumber.text = [NSString stringWithFormat:@"%ld", [[object objectForKey:@"viewNumber"] integerValue]];
                _appreciateNumber.text = [NSString stringWithFormat:@"%ld", [[object objectForKey:@"appreciateNumber"] integerValue]];
                NSArray *rgb = [[object objectForKey:@"userBackgroundColor"] componentsSeparatedByString:@","];
                _backgroundImage.image = [Utils getImageFilledByColor:[UIColor colorWithRed:[rgb[0] floatValue]/255 green:[rgb[1] floatValue]/255 blue:[rgb[2] floatValue]/255 alpha:1]];
            } else {
                //network problem
                [Utils showFailOperationWithTitle:@"更新失败\n请检查网络设置" inSeconds:2 followedByOperation:nil];
            }
        }];

    }
    
}

- (void)showNoPosts {
    
    [_unPostView setHidden: NO];
    [_userInfoTableView setHidden:YES];
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

@end
