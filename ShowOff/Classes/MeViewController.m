//
//  MeViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "MeViewController.h"
#import "FlatUIKit.h"
#import "Universal.h"

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor cloudsColor]};
    self.navigationItem.title = @"个人";

    
    
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
