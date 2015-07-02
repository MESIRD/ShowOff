//
//  UserInfoViewController.h
//  ShowOff
//
//  Created by xujie on 15/7/2.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface UserInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *userDescription;
@property (weak, nonatomic) IBOutlet UILabel *appreciateNumber;
@property (weak, nonatomic) IBOutlet UILabel *viewNumber;

@property (strong, nonatomic) AVUser *user;

@end
