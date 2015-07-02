//
//  ChannelTableViewCell.m
//  ShowOff
//
//  Created by xujie on 15/6/29.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "ChannelTableViewCell.h"
#import "Universal.h"

@implementation ChannelTableViewCell

- (void)awakeFromNib {
    
    self.backgroundColor = [UIColor clearColor];
    _channelTitle.font = [UIFont fontWithName:@"RTWS YueGothic Demo" size:22];
    _concernedNumber.font = [UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:14];
}

@end
