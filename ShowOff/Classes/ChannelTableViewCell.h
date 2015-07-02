//
//  ChannelTableViewCell.h
//  ShowOff
//
//  Created by xujie on 15/6/29.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *channelTitle;
@property (weak, nonatomic) IBOutlet UILabel *concernedNumber;


@end
