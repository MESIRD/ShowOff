//
//  MeTableView.m
//  ShowOff
//
//  Created by mesird on 6/22/15.
//  Copyright (c) 2015 mesird. All rights reserved.
//

#import "MeTableView.h"
#import "MeUserInfoTableViewCell.h"
#import "MeSettingTableViewCell.h"
#import "MeSwitchTableViewCell.h"

#import "AppSettingTableViewController.h"

#import "UserPreference.h"
#import "Utils.h"
#import <FlatUIKit/FlatUIKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <objc/runtime.h>
#import <AVOSCloud/AVOSCloud.h>

static const char AlertObjectKey;

@interface MeTableView() <UIAlertViewDelegate>

@property (nonatomic)   NSArray *settingGroup;

@end

@implementation MeTableView


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if ( self) {
        
        if ( [AVUser currentUser]) {
            [self setTableData];
        }
        
        //table footer view configuration
        self.tableFooterView = [[UIView alloc] init];
        
        //set delegate and dataSource
        self.delegate = self;
        self.dataSource = self;
        
        [self reloadData];
        
        //register notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableData) name:@"Change Avatar"    object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableData) name:@"Change Nick Name" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableData) name:@"User Login"       object:nil];

    }
    return self;
}

- (void)setTableData {
    
    NSString *userAvatarURL = [[UserPreference sharedUserPreference] userAvatarURL];
    NSString *userNickName = [[UserPreference sharedUserPreference] userNickName];
    //update group
    _settingGroup = @[@[@[userAvatarURL, userNickName]],
                      @[@[@"position", @"开启定位"],
                        @[@"setting", @"应用设置"],
                        @[@"feedback", @"应用反馈"]],
                      @[@[@"logout", @"退出"]]];
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _settingGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_settingGroup[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //
        MeUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meUserInfoCell" forIndexPath:indexPath];
        if ( cell == nil) {
            cell = [[MeUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"meUserInfoCell"];
        }
        [cell.avatar setImageWithURL:[NSURL URLWithString:_settingGroup[indexPath.section][indexPath.row][0]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
        cell.userName.text = _settingGroup[indexPath.section][indexPath.row][1];
        return cell;
    } else if ( indexPath.section == 1) {
        //
        if ( [_settingGroup[indexPath.section][indexPath.row][0] isEqualToString:@"position"]) {
            MeSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meSwitchCell" forIndexPath:indexPath];
            if ( cell == nil) {
                cell = [[MeSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"meSwitchCell"];
            }
            cell.icon.image = [UIImage imageNamed:_settingGroup[indexPath.section][indexPath.row][0]];
            cell.title.text = _settingGroup[indexPath.section][indexPath.row][1];

            return cell;
        } else {
            MeSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meSettingCell" forIndexPath:indexPath];
            if ( cell == nil) {
                cell = [[MeSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"meSettingCell"];
            }
            cell.icon.image = [UIImage imageNamed:_settingGroup[indexPath.section][indexPath.row][0]];
            cell.title.text = _settingGroup[indexPath.section][indexPath.row][1];
            return cell;
        }
    } else if ( indexPath.section == 2) {
        //
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"meLogoutCell" forIndexPath:indexPath];
        if ( cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"meLogoutCell"];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            return 70;
            break;
        case 1:
        case 2:
            return 50;
            break;
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            //user info
            break;
        case 1:
            //settings
            switch (indexPath.row) {
                case 0:
                    //position
                    //nothing to do here
                    break;
                case 1: {
                    //application setting
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    AppSettingTableViewController *targetVC = [sb instantiateViewControllerWithIdentifier:@"AppSettingTableViewController"];
                    UIViewController *currentVC = [Utils viewControllerWithEmbededView:self];
                    [currentVC.navigationController pushViewController:targetVC animated:YES];
                    break;
                }
                case 2:
                    //application feedback
                    
                    break;
                default:
                    break;
            }
            break;
        case 2:
            //logout
            [self showLogoutAlertView];
            break;
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [tableView headerViewForSection:section];
    if ( headerView == nil) {
        headerView = [[UIView alloc] init];
    }
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [tableView footerViewForSection:section];
    if ( footerView == nil) {
        footerView = [[UIView alloc] init];
    }
    [footerView setBackgroundColor:[UIColor clearColor]];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20;
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    void (^clickButtonAtIndex)(NSInteger) = objc_getAssociatedObject(alertView, &AlertObjectKey);
    clickButtonAtIndex(buttonIndex);
}

#pragma mark - User Interaction Call Backs

- (void)showLogoutAlertView {
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"警告"
                                                          message:@"确认要退出登录吗?"
                                                         delegate:self cancelButtonTitle:nil
                                                otherButtonTitles:@"确认", @"取消", nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    
    void (^clickButtonAtIndex)(NSInteger) = ^(NSInteger index) {
        switch (index) {
            case 0:
                [self userLogout];
                break;
            case 1:
                break;
            default:
                break;
        }
    };
    objc_setAssociatedObject(alertView, &AlertObjectKey, clickButtonAtIndex, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alertView show];
}

- (void)userLogout {
    
    if ( [AVUser currentUser]) {
        [AVUser logOut];
        
        //remove user preference from use defaults
        [UserPreference removeUserPreferenceInUserDefaults];
        
        //hide user information table view
        [[NSNotificationCenter defaultCenter] postNotificationName:@"User Logout" object:nil];
    } else {
        NSLog(@"Logout Log : The user has not logined!");
    }
}

@end
