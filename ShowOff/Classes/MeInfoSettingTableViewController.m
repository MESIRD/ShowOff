//
//  MeInfoSettingTableViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/24.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "MeInfoSettingTableViewController.h"
#import "MeInfoImageChangeTableViewCell.h"
#import "MeInfoSettingIndicatorTableViewCell.h"
#import "MeInfoSettingTableViewCell.h"
#import "NickNameChangeViewController.h"
#import "DescriptionChangeViewController.h"
#import "GenderChangeTableViewController.h"
#import "SexualOrientationChangeTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"
#import <AVOSCloud/AVOSCloud.h>


@interface MeInfoSettingTableViewController ()

@property (nonatomic)   NSArray *meInfoSettingGroup;
@property (nonatomic)   AVObject *userPreference;

@end

@implementation MeInfoSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //initialize data source group
    
    AVQuery *query = [AVQuery queryWithClassName:@"UserPreference"];
    [query whereKey:@"belongedUser" equalTo:[AVUser currentUser]];
    _userPreference = [query findObjects][0];
    _meInfoSettingGroup = @[@[@[@"更改头像",    [_userPreference objectForKey:@"userAvatarURL"]],
                              @[@"更改背景色",  [_userPreference objectForKey:@"userBackgroundColor"]]],
                            @[@[@"昵称",        [_userPreference objectForKey:@"userNickName"]],
                              @[@"描述",        [_userPreference objectForKey:@"userDescription"]],
                              @[@"用户名",      [[AVUser currentUser] username]]],
                            @[@[@"性别",        [_userPreference objectForKey:@"userGender"]],
                              @[@"性取向",      [_userPreference objectForKey:@"userSexualOrientation"]]]];
    
    //set navigationitem title
    self.navigationItem.title = @"设置";
    
    //set tableview footer view
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    //register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Nick Name"          object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Avatar"             object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Background Color"   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Description"        object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Gender"             object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Sexual Orientation" object:nil];

    [self.tableView reloadData];
}

- (void)updateTableData {
    
    [_userPreference refresh];
    _meInfoSettingGroup = @[@[@[@"更改头像",    [_userPreference objectForKey:@"userAvatarURL"]],
                              @[@"更改背景色",  [_userPreference objectForKey:@"userBackgroundColor"]]],
                            @[@[@"昵称",        [_userPreference objectForKey:@"userNickName"]],
                              @[@"描述",        [_userPreference objectForKey:@"userDescription"]],
                              @[@"用户名",      [[AVUser currentUser] username]]],
                            @[@[@"性别",        [_userPreference objectForKey:@"userGender"]],
                              @[@"性取向",      [_userPreference objectForKey:@"userSexualOrientation"]]]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return _meInfoSettingGroup.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_meInfoSettingGroup[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ( indexPath.section == 0) {
        if ( [_meInfoSettingGroup[indexPath.section][indexPath.row][0] isEqualToString:@"更改头像"]) {
            
            MeInfoImageChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageChangeCell" forIndexPath:indexPath];
            if ( cell == nil) {
                cell = [[MeInfoImageChangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageChangeCell"];
            }
            cell.title.text = _meInfoSettingGroup[indexPath.section][indexPath.row][0];
            [cell.avatar setImageWithURL:[NSURL URLWithString:_meInfoSettingGroup[indexPath.section][indexPath.row][1]] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
            return cell;
        } else {
            
            MeInfoImageChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageChangeCell" forIndexPath:indexPath];
            if ( cell == nil) {
                cell = [[MeInfoImageChangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imageChangeCell"];
            }
            cell.title.text = _meInfoSettingGroup[indexPath.section][indexPath.row][0];
            NSArray *rgb = [_meInfoSettingGroup[indexPath.section][indexPath.row][1] componentsSeparatedByString:@","];
            cell.avatar.image = [Utils getImageFilledByColor:[UIColor colorWithRed:[rgb[0] floatValue]/255 green:[rgb[1] floatValue]/255 blue:[rgb[2] floatValue]/255 alpha:1]];
            return cell;
        }
        
    } else if ( indexPath.section == 1) {
        
        if ( [_meInfoSettingGroup[indexPath.section][indexPath.row][0] isEqualToString:@"用户名"]) {
            
            MeInfoSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
            if ( cell == nil) {
                cell = [[MeInfoSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
            }
            cell.title.text = _meInfoSettingGroup[indexPath.section][indexPath.row][0];
            cell.value.text = _meInfoSettingGroup[indexPath.section][indexPath.row][1];
            return cell;
        } else {
            
            MeInfoSettingIndicatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingIndicatorCell" forIndexPath:indexPath];
            if ( cell == nil) {
                cell = [[MeInfoSettingIndicatorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingIndicatorCell"];
            }
            cell.title.text = _meInfoSettingGroup[indexPath.section][indexPath.row][0];
            cell.value.text = _meInfoSettingGroup[indexPath.section][indexPath.row][1];
            return cell;
        }
    } else if ( indexPath.section == 2) {
        
        MeInfoSettingIndicatorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingIndicatorCell" forIndexPath:indexPath];
        if ( cell == nil) {
            cell = [[MeInfoSettingIndicatorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingIndicatorCell"];
        }
        cell.title.text = _meInfoSettingGroup[indexPath.section][indexPath.row][0];
        cell.value.text = _meInfoSettingGroup[indexPath.section][indexPath.row][1];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            //avatar change
            //show imagepicker
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    //nick name
                    [self showNickNameChangeViewController];
                    break;
                case 1:
                    //description
                    [self showDescriptionChangeViewController];
                    break;
                default:
                    break;
            }
            //
            break;
        case 2:
            //
            switch (indexPath.row) {
                case 0:
                    //gender
                    [self showGenderChangeViewController];
                    break;
                case 1:
                    //sexual orientation
                    [self showSexualOrientationChangeViewController];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
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
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [tableView footerViewForSection:section];
    if ( footerView == nil) {
        footerView = [[UIView alloc] init];
    }
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [tableView headerViewForSection:section];
    if ( headerView == nil) {
        headerView = [[UIView alloc] init];
    }
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (void)showNickNameChangeViewController {
    
    NickNameChangeViewController *vc = [[NickNameChangeViewController alloc] init];
    vc.currentNickName = _meInfoSettingGroup[1][0][1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showDescriptionChangeViewController {
    
    DescriptionChangeViewController *vc = [[DescriptionChangeViewController alloc] init];
    vc.currentUserDescription = _meInfoSettingGroup[1][1][1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showGenderChangeViewController {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    GenderChangeTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"GenderChangeTableViewController"];
    vc.selectedOption = _meInfoSettingGroup[2][0][1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showSexualOrientationChangeViewController {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SexualOrientationChangeTableViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SexualOrientationChangeTableViewController"];
    vc.selectedOption = _meInfoSettingGroup[2][1][1];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
