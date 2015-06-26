//
//  GenderChangeTableViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/25.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "GenderChangeTableViewController.h"
#import "GenderTableViewCell.h"
#import "Utils.h"
#import "UserPreference.h"
#import <AVOSCloud/AVOSCloud.h>

@interface GenderChangeTableViewController()

@property (nonatomic) NSArray *genderOptionArray;

@end

@implementation GenderChangeTableViewController

static NSString * const reuseIdentifier = @"genderCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //do any additional setup below
    _genderOptionArray = @[@"男", @"女", @"保密"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _genderOptionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GenderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"genderCell" forIndexPath:indexPath];
    if ( cell == nil) {
        cell = [[GenderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"genderCell"];
    }
    cell.title.text = _genderOptionArray[indexPath.row];
    if ( [_genderOptionArray[indexPath.row] isEqualToString:_selectedOption]) {
        cell.selectedIcon.image = [Utils getImageFilledByColor:[UIColor colorWithRed:59.0/255 green:75.0/255 blue:91.0/255 alpha:1]];
    } else {
        cell.selectedIcon.image = nil;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( [_selectedOption isEqualToString:_genderOptionArray[indexPath.row]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    _selectedOption = _genderOptionArray[indexPath.row];
    [self.tableView reloadData];
    switch (indexPath.row) {
        case 0:
            //man
            [self updateGender:_genderOptionArray[indexPath.row]];
            break;
        case 1:
            //woman
            [self updateGender:_genderOptionArray[indexPath.row]];
            break;
        case 2:
            //secrecy
            [self updateGender:_genderOptionArray[indexPath.row]];
            break;
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [tableView headerViewForSection:section];
    if ( !header) {
        header = [[UIView alloc] init];
    }
    header.backgroundColor = [UIColor clearColor];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footer = [tableView footerViewForSection:section];
    if ( !footer) {
        footer = [[UIView alloc] init];
    }
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (void)updateGender:(NSString *)gender {
    

    [Utils showProcessingOperation];
    AVQuery *query = [AVQuery queryWithClassName:@"UserPreference"];
    [query whereKey:@"belongedUser" equalTo:[AVUser currentUser]];
    AVObject *obj = [query findObjects][0];
    [obj setObject:gender forKey:@"userGender"];
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( succeeded) {
            [[UserPreference sharedUserPreference] setUserGender:gender];
            [[UserPreference sharedUserPreference] storeUserPreferenceInUserDefaults];
            [Utils hideProcessingOperation];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Change Gender" object:nil];
            [Utils showSuccessOperationWithTitle:@"修改成功!" inSeconds:2 followedByOperation:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [Utils showFailOperationWithTitle:@"修改失败!\n请检查网络设置." inSeconds:2 followedByOperation:nil];
        }
    }];
}

@end
