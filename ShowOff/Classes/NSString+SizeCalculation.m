//
//  NSString+SizeCalculation.m
//  ShowOff
//
//  Created by xujie on 15/7/1.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "NSString+SizeCalculation.h"

@implementation NSString (SizeCalculation)

- (CGSize)calculateSize:(CGSize)size {
    
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.text = self;
    return [tempLabel sizeThatFits:size];
}

@end
