//
//  AboutViewController.m
//  ShowOff
//
//  Created by mesird on 6/27/15.
//  Copyright (c) 2015 mesird. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutTableView.h"

@interface AboutViewController ()
@property (strong, nonatomic) IBOutlet AboutTableView *aboutTableView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"关于";
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
