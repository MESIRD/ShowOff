//
//  MeViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "MeViewController.h"
#import "FlatUIKit.h"

@interface MeViewController ()

//user information view
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *userInformationView;

//application feedback view
@property (weak, nonatomic) IBOutlet UIView *applicationFeedbackView;

//position view
@property (weak, nonatomic) IBOutlet UIView *positionView;

//setting view
@property (weak, nonatomic) IBOutlet UIView *settingView;

//logout view
@property (weak, nonatomic) IBOutlet UIView *logoutView;


@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    FUISwitch *flatSwitch = [[FUISwitch alloc] initWithFrame:CGRectMake(263, 9, 51, 31)];
    flatSwitch.onColor = [UIColor turquoiseColor];
    flatSwitch.offColor = [UIColor cloudsColor];
    flatSwitch.onBackgroundColor = [UIColor midnightBlueColor];
    flatSwitch.offBackgroundColor = [UIColor silverColor];
    flatSwitch.offLabel.font = [UIFont boldFlatFontOfSize:14];
    flatSwitch.onLabel.font = [UIFont boldFlatFontOfSize:14];
    
    [_positionView addSubview:flatSwitch];
    
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
