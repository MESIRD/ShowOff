//
//  MeViewController.h
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeTableView.h"

@interface MeViewController : UIViewController
@property (strong, nonatomic) IBOutlet MeTableView *meTableView;
@property (weak, nonatomic) IBOutlet UIView *unlogView;

@end
