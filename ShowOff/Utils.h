//
//  Utils.h
//  ShowOff
//
//  Created by xujie on 15/6/23.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"
#import "FlatUIKit.h"
#import <UIKit/UIKit.h>

typedef void (^VoidOperationBlock)(void);

@interface Utils : NSObject
+ (Utils *)defaultUtils;

+ (void)configureFUIButton:(FUIButton *)button withTitle:(NSString *)title target:(id)target andAction:(SEL)action;
+ (void)configureFUITextField:(FUITextField *)textField withPlaceHolder:(NSString *)placeHolder andIndent:(BOOL)isIndent;

+ (UIImage *)getImageFilledByColor:(UIColor *)color;
+ (UIImage *)clipImage:(UIImage *)image inRect:(CGRect)rect;

+ (CGSize)getSizeOfTextView:(UITextView *)textView withinSize:(CGSize)size;

+ (void)showFlatAlertView:(NSString *)title andMessage:(NSString *)message;
+ (void)showProcessingOperation;
+ (void)hideProcessingOperation;
+ (void)showSuccessOperationWithTitle:(NSString *)title inSeconds:(unsigned int)seconds followedByOperation:(VoidOperationBlock)operation;
+ (void)showFailOperationWithTitle:(NSString *)title inSeconds:(unsigned int)seconds followedByOperation:(VoidOperationBlock)operation;

+ (BOOL)judgePhoneNumberValidation:(NSString *)phoneNumber;

+ (BOOL)isEmptyTextField:(UITextField *)textField;
+ (BOOL)isEmptyTextView:(UITextView *)textView;

+ (UIViewController *)viewControllerWithEmbededView:(UIView *)view;
@end
