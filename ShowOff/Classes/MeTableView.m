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

@interface MeTableView()

@property (nonatomic)   NSArray *settingGroup;

@end

@implementation MeTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if ( self) {
        
        //init group
        _settingGroup = [[NSArray alloc] initWithObjects: @[@[@"default_avatar", @"mesird"]], @[@[@"position", @"开启定位"], @[@"setting", @"应用设置"], @[@"feedback", @"应用反馈"]], @[@[@"logout", @"退出"]], nil];
        
        //set separator insets
//        [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        //table footer view configuration
        self.tableFooterView = [[UIView alloc] init];

        //set delegate and dataSource
        self.delegate = self;
        self.dataSource = self;
        
        [self reloadData];
    }
    return self;
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
        cell.avatar.image = [UIImage imageNamed:_settingGroup[indexPath.section][indexPath.row][0]];
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
            break;
        case 2:
            //logout
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

@end