//
//  MeUserInfoTableViewCell.m
//  ShowOff
//
//  Created by mesird on 6/22/15.
//  Copyright (c) 2015 mesird. All rights reserved.
//

#import "MeUserInfoTableViewCell.h"

@implementation MeUserInfoTableViewCell

- (void)awakeFromNib {
    
    _avatar.layer.cornerRadius = 5;
    _avatar.layer.masksToBounds = YES;
    _avatar.contentMode = UIViewContentModeScaleAspectFill;
}

@end
