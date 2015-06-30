//
//  HomeViewController.h
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostTableView.h"
#import "ChannelTableView.h"

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet PostTableView *postTableView;
@property (weak, nonatomic) IBOutlet ChannelTableView *channelTableView;

@end
