//
//  MeSwitchTableViewCell.m
//  ShowOff
//
//  Created by mesird on 6/22/15.
//  Copyright (c) 2015 mesird. All rights reserved.
//

#import "MeSwitchTableViewCell.h"
#import "Utils.h"
#import <FlatUIKit/FlatUIKit.h>

@implementation MeSwitchTableViewCell

- (void)awakeFromNib {
    
    FUISwitch *flatSwitch = [[FUISwitch alloc] initWithFrame:CGRectMake(250, 9, 60, 31)];
    flatSwitch.onColor = [UIColor turquoiseColor];
    flatSwitch.offColor = [UIColor cloudsColor];
    flatSwitch.onBackgroundColor = [UIColor midnightBlueColor];
    flatSwitch.offBackgroundColor = [UIColor silverColor];
    flatSwitch.offLabel.font = [UIFont boldFlatFontOfSize:14];
    flatSwitch.onLabel.font = [UIFont boldFlatFontOfSize:14];
    flatSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LocationPermission"] boolValue];
    [flatSwitch addTarget:self action:@selector(locationSwitchOperation:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:flatSwitch];
}

- (void)locationSwitchOperation:(FUISwitch *)locationSwitch {
    
    NSLog(@"%d", locationSwitch.isOn);
    if ( locationSwitch.isOn) {
        //set userdefaults 'LocationPermission' to YES
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"LocationPermission"];
        //show progress HUD
//        [Utils showSuccessOperationWithTitle:@"定位已关闭" inSeconds:0 followedByOperation:nil];
    } else {
        //set userdefaults 'LocationPermission' to NO
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"LocationPermission"];
        //clear 'UserLocation' information in userdefaults
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserLocation"];
        //show progress HUD
//        [Utils showSuccessOperationWithTitle:@"定位已关闭" inSeconds:0 followedByOperation:nil];
    }
}

@end
