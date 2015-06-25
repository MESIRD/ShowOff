//
//  MSDTextView.h
//  ShowOff
//
//  Created by xujie on 15/6/24.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSDTextView : UITextView

@property (nonatomic)       NSString *placeHolder;
@property (nonatomic)       CGFloat  borderWidth;
@property (nonatomic)       UIColor  *borderColor;
@property (nonatomic)       CGFloat  cornerRadius;


- (instancetype)initWithFrame:(CGRect)frame;

@end
