//
//  ChannelObject.h
//  ShowOff
//
//  Created by xujie on 15/6/29.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelObject : NSObject

@property (strong, nonatomic) NSString  *channelTitle;
@property (strong, nonatomic) NSString  *channelDescription;
@property (strong, nonatomic) NSURL     *channelBackgroundImageURL;
@property (nonatomic)         NSInteger  concernedNumber;

@end
