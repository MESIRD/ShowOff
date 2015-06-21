//
//  HomeViewController.h
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewestTableView.h"
#import "HottestTableView.h"

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet NewestTableView *newestTableView;
@property (weak, nonatomic) IBOutlet HottestTableView *hottestTableView;



@end
