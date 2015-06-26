//
//  MeInfoImageChangeTableViewCell.m
//  ShowOff
//
//  Created by xujie on 15/6/24.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "MeInfoImageChangeTableViewCell.h"

@implementation MeInfoImageChangeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _avatar.layer.cornerRadius = 5;
    _avatar.layer.masksToBounds = YES;
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
