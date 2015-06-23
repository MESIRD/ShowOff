//
//  MeUserInfoTableViewCell.m
//  ShowOff
//
//  Created by mesird on 6/22/15.
//  Copyright (c) 2015 mesird. All rights reserved.
//

#import "MeUserInfoTableViewCell.h"

@implementation MeUserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self) {
        
        _avatar.layer.cornerRadius = 5;
        _avatar.layer.masksToBounds = YES;
    }
    return self;
}

@end
