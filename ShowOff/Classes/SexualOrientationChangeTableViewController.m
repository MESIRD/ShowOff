//
//  SexualOrientationChangeTableViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/25.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "SexualOrientationChangeTableViewController.h"
#import "SexualOrientationTableViewCell.h"
#import "Utils.h"
#import "UserPreference.h"
#import <AVOSCloud/AVOSCloud.h>

@interface SexualOrientationChangeTableViewController()

@property (nonatomic) NSArray *sexualOrientationOptionArray;

@end

@implementation SexualOrientationChangeTableViewController


static NSString * const reuseIdentifier = @"sexualOrientationCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //do any additional setup below
    _sexualOrientationOptionArray = @[@"异性", @"同性", @"保密"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _sexualOrientationOptionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SexualOrientationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if ( cell == nil) {
        cell = [[SexualOrientationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.title.text = _sexualOrientationOptionArray[indexPath.row];
    if ( [_sexualOrientationOptionArray[indexPath.row] isEqualToString:_selectedOption]) {
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
    _selectedOption = _sexualOrientationOptionArray[indexPath.row];
    [self.tableView reloadData];
    switch (indexPath.row) {
        case 0:
            //man
            [self updateSexualOrientation:_sexualOrientationOptionArray[indexPath.row]];
            break;
        case 1:
            //woman
            [self updateSexualOrientation:_sexualOrientationOptionArray[indexPath.row]];
            break;
        case 2:
            //secrecy
            [self updateSexualOrientation:_sexualOrientationOptionArray[indexPath.row]];
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

- (void)updateSexualOrientation:(NSString *)sexualOrientation {


    [Utils showProcessingOperation];
    AVQuery *query = [AVQuery queryWithClassName:@"UserPreference"];
    [query whereKey:@"belongedUser" equalTo:[AVUser currentUser]];
    AVObject *obj = [query findObjects][0];
    [obj setObject:sexualOrientation forKey:@"userSexualOrientation"];
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( succeeded) {
            [[UserPreference sharedUserPreference] setUserSexualOrientation:sexualOrientation];
            [[UserPreference sharedUserPreference] storeUserPreferenceInUserDefaults];
            [Utils hideProcessingOperation];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Change Sexual Orientation" object:nil];
            [Utils showSuccessOperationWithTitle:@"修改成功!" inSeconds:2 followedByOperation:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [Utils showFailOperationWithTitle:@"修改失败!\n请检查网络设置." inSeconds:2 followedByOperation:nil];
        }
    }];
}


@end
