//
//  AppSettingTableViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/26.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "AppSettingTableViewController.h"
#import "AppSettingTableViewCell.h"
#import "PasswordChangeViewController.h"
#import <FlatUIKit/FlatUIKit.h>

@interface AppSettingTableViewController()

@property (nonatomic) NSArray *appSettingGroup;

@end

@implementation AppSettingTableViewController

static NSString * const reuseIdentifier = @"appSettingCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //any additional operations
    
    //initialize app setting group
    _appSettingGroup = @[@[@[@"password", @"修改密码"],
                           @[@"clearCache", @"清除缓存"]],
                         @[@[@"about", @"关于"]]];
    
    //set navigation item title
    self.navigationItem.title = @"应用设置";
    
    //set navigation bar tint color
    [self.navigationController.navigationBar setTintColor:[UIColor cloudsColor]];
    
    //
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _appSettingGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_appSettingGroup[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if ( cell == nil) {
        cell = [[AppSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.icon.image = [UIImage imageNamed:_appSettingGroup[indexPath.section][indexPath.row][0]];
    cell.title.text = _appSettingGroup[indexPath.section][indexPath.row][1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            //change password
            PasswordChangeViewController *vc = [[PasswordChangeViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
            switch (indexPath.row) {
                case 0:
                    //clear cache
                    break;
                case 1:
                    //about
                    break;
                default:
                    break;
            }
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
    
    if ( section == 0) {
        return 60;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20;
}

@end
