//
//  UserInfoTableView.h
//  ShowOff
//
//  Created by xujie on 15/7/2.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface UserInfoTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) AVUser *user;

- (void)fetchNewestMePosts;

@end
