//
//  MeInfoSettingTableViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/24.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "MeInfoSettingTableViewController.h"
//cells
#import "MeInfoImageChangeTableViewCell.h"
#import "MeInfoSettingIndicatorTableViewCell.h"
#import "MeInfoSettingTableViewCell.h"
//cell view controllers
#import "NickNameChangeViewController.h"
#import "DescriptionChangeViewController.h"
#import "GenderChangeTableViewController.h"
#import "SexualOrientationChangeTableViewController.h"
#import "ColorChangeCollectionViewController.h"
//tools
#import "Utils.h"
#import "UserPreference.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <AVOSCloud/AVOSCloud.h>


@interface MeInfoSettingTableViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic)   NSArray *meInfoSettingGroup;
@property (nonatomic)   AVObject *userPreference;
@property (nonatomic)   UIImagePickerController *imagePicker;

@end

@implementation MeInfoSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //set navigationitem title
    self.navigationItem.title = @"设置";
    
    //set tableview footer view
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    //initialize image picker
    [self configureImagePicker];
    
    //initialize data source group
    [self updateTableData];
    
    //register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Nick Name"          object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Avatar"             object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Background Color"   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Description"        object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Gender"             object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData) name:@"Change Sexual Orientation" object:nil];
}

- (void)updateTableData {
    
    _meInfoSettingGroup = @[@[@[@"更改头像",    [[UserPreference sharedUserPreference] userAvatarURL]],
                              @[@"更改背景色",  [[UserPreference sharedUserPreference] userBackgroundColor]]],
                            @[@[@"昵称",        [[UserPreference sharedUserPreference] userNickName]],
                              @[@"描述",        [[UserPreference sharedUserPreference] userDescription]],
                              @[@"用户名",      [[AVUser currentUser] username]]],
                            @[@[@"性别",        [[UserPreference sharedUserPreference] userGender]],
                              @[@"性取向",      [[UserPreference sharedUserPreference] userSexualOrientation]]]];
    [self.tableView reloadData];
}

- (void)configureImagePicker {
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _imagePicker.allowsEditing = YES;
    _imagePicker.navigationBar.tintColor = [UIColor cloudsColor];
    _imagePicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor cloudsColor]};
    [_imagePicker.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ( image == nil) {
        //(fail to select image)do not need upload image
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    } else {
        //(successfully select)upload image to server
        //judge whether there is an avatar image in the server to the given user
        AVQuery *query = [AVQuery queryWithClassName:@"_File"];
        [query whereKey:@"name" hasPrefix:[NSString stringWithFormat:@"avatar_%@", [[AVUser currentUser] username]]];
        NSInteger count = [query countObjects];
        [Utils showProcessingOperation];
        if ( UIImagePNGRepresentation(image)) {
            //this image is a png format image
            if ( count == 0) {
                //user hasn't uploaded avatar yet, this is the first time
                NSData *imageData = UIImagePNGRepresentation(image);
                [self uploadAvatarImage:imageData];
            } else {
                //user had uploaded avatar once, this is not the first time
                AVFile *imageFile = (AVFile *)[query getFirstObject];
                [imageFile deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if ( succeeded) {
                        NSData *imageData = UIImagePNGRepresentation(image);
                        [self uploadAvatarImage:imageData];
                    } else {
                        [Utils hideProcessingOperation];
                        NSLog(@"delete original avatar fail");
                    }
                }];
            }
        } else {
            //this image is a jepg format image
            if ( count == 0) {
                //user hasn't uploaded avatar yet, this is the first time
                NSData *imageData = UIImageJPEGRepresentation(image, 1);
                [self uploadAvatarImage:imageData];
            } else {
                //user had uploaded avatar once, this is not the first time
                AVFile *imageFile = (AVFile *)[query getFirstObject];
                [imageFile deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if ( succeeded) {
                        NSData *imageData = UIImageJPEGRepresentation(image, 1);
                        [self uploadAvatarImage:imageData];
                    } else {
                        [Utils hideProcessingOperation];
                        NSLog(@"delete original avatar fail");
                    }
                }];
            }
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadAvatarImage:(NSData *)imageData {
    
    AVFile *imageFile = [AVFile fileWithName:[NSString stringWithFormat:@"avatar_%@.png", [[AVUser currentUser] username]] data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( succeeded) {
            AVQuery *queryUP = [AVQuery queryWithClassName:@"UserPreference"];
            [queryUP whereKey:@"belongedUser" equalTo:[AVUser currentUser]];
            AVObject *obj = [queryUP getFirstObject];
            [obj setObject:[imageFile url] forKey:@"userAvatarURL"];
            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ( succeeded) {
                    //save image data in file
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *docDir = [paths objectAtIndex:0];
                    NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"avatar_%@.png", [[AVUser currentUser] username]]];
                    [imageData writeToFile:filePath atomically:YES];
                    //
                    [Utils hideProcessingOperation];
                    [[UserPreference sharedUserPreference] setUserAvatarURL:[imageFile url]];
                    [[UserPreference sharedUserPreference] storeUserPreferenceInUserDefaults];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Change Avatar" object:nil];
                    [Utils showSuccessOperationWithTitle:@"头像上传成功!" inSeconds:2 followedByOperation:nil];
                } else {
                    [Utils hideProcessingOperation];
                    NSLog(@"update avatar url fail");
                }
            }];
        } else {
            [Utils hideProcessingOperation];
            [Utils showFlatAlertView:@"错误" andMessage:@"头像上传失败!\n请检查网络设置"];
        }
    }];
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
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [paths objectAtIndex:0];
            NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"avatar_%@.png", [[AVUser currentUser] username]]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ( [fileManager fileExistsAtPath:filePath]) {
                cell.avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
            } else {
                cell.avatar.image = [UIImage imageNamed:@"default_avatar"];
            }
            cell.title.text = _meInfoSettingGroup[indexPath.section][indexPath.row][0];
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
        case 0: {
            //avatar change
            switch (indexPath.row) {
                case 0:
                    //show imagepicker
                    [self presentViewController:_imagePicker animated:YES completion:nil];
                    break;
                case 1:
                    //background color
                    [self showBackgroundColorChangeViewController];
                    break;
                default:
                    break;
            }
            break;
        }
        case 1: {
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
        }
        case 2: {
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
        }
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

- (void)showBackgroundColorChangeViewController {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ColorChangeCollectionViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ColorChangeCollectionViewController"];
    vc.selectedColor = _meInfoSettingGroup[0][1][1];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ( [navigationController isKindOfClass:[UIImagePickerController class]] &&
        ( (UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
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
