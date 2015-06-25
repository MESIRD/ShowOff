//
//  GenderTableViewCell.m
//  ShowOff
//
//  Created by xujie on 15/6/25.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "GenderTableViewCell.h"

@implementation GenderTableViewCell

- (void)awakeFromNib {
    
    _selectedIcon.layer.cornerRadius = _selectedIcon.frame.size.height/2;
    _selectedIcon.layer.masksToBounds = YES;
}

@end
