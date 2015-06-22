//
//  MeSwitchTableViewCell.m
//  ShowOff
//
//  Created by mesird on 6/22/15.
//  Copyright (c) 2015 mesird. All rights reserved.
//

#import "MeSwitchTableViewCell.h"
#import "FlatUIKit.h"

@implementation MeSwitchTableViewCell

- (void)awakeFromNib {
    
    //
    
    FUISwitch *flatSwitch = [[FUISwitch alloc] initWithFrame:CGRectMake(250, 9, 60, 31)];
    flatSwitch.onColor = [UIColor turquoiseColor];
    flatSwitch.offColor = [UIColor cloudsColor];
    flatSwitch.onBackgroundColor = [UIColor midnightBlueColor];
    flatSwitch.offBackgroundColor = [UIColor silverColor];
    flatSwitch.offLabel.font = [UIFont boldFlatFontOfSize:14];
    flatSwitch.onLabel.font = [UIFont boldFlatFontOfSize:14];
    
    [self addSubview:flatSwitch];
}

@end
