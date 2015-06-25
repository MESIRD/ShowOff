//
//  MSDTextView.m
//  ShowOff
//
//  Created by xujie on 15/6/24.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "MSDTextView.h"
#import "UIColor+FlatUI.h"

@interface MSDTextView() <UITextViewDelegate>

@property (nonatomic)   UILabel *placeHolderLabel;

@end

@implementation MSDTextView

- (void)setPlaceHolder:(NSString *)placeHolder {
    
    _placeHolder = placeHolder;
    _placeHolderLabel.text = placeHolder;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    
    _borderWidth = borderWidth;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if ( self) {
        
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake( 5, 5, frame.size.width - 10, 30)];
        [_placeHolderLabel setFont:[UIFont systemFontOfSize:16]];
        [_placeHolderLabel setTextColor:[UIColor lightGrayColor]];
        [_placeHolderLabel setHidden:YES];
        [self addSubview:_placeHolderLabel];
        
        self.delegate = self;
        self.returnKeyType = UIReturnKeyDone;
        self.font = [UIFont systemFontOfSize:16];
        self.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithRed:87.0/255 green:162.0/255 blue:152.0/255 alpha:1].CGColor;
        _borderWidth = 0.0;
    }
    return self;
}



- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    //show border
    self.layer.borderWidth = _borderWidth;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    //hide border
    self.layer.borderWidth = 0.0;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if ( [textView.text isEqualToString:@""]) {
        _placeHolderLabel.hidden = NO;
    } else {
        if ( !_placeHolderLabel.isHidden) {
            _placeHolderLabel.hidden = YES;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
