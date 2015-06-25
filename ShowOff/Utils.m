//
//  Utils.m
//  ShowOff
//
//  Created by xujie on 15/6/23.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "Utils.h"


@interface Utils()

@end

@implementation Utils

+ (Utils *)defaultUtils {
    
    static Utils *utils = nil;
    if ( !utils) {
        utils = [[Utils alloc] init];
    }
    return utils;
}

+ (void)configureFUIButton:(FUIButton *)button withTitle:(NSString *)title target:(id)target andAction:(SEL)action {
    
    button.buttonColor = [UIColor turquoiseColor];
    button.shadowColor = [UIColor greenSeaColor];
    button.shadowHeight = 3.0f;
    button.cornerRadius = 6.0f;
    button.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

+ (void)configureFUITextField:(FUITextField *)textField withPlaceHolder:(NSString *)placeHolder {
    
    textField.font = [UIFont flatFontOfSize:16];
    textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = placeHolder;
    textField.edgeInsets = UIEdgeInsetsMake(4.0f, 30.0f, 4.0f, 15.0f);
    textField.textFieldColor = [UIColor whiteColor];
    textField.borderColor = [UIColor turquoiseColor];
    textField.borderWidth = 2.0f;
    textField.cornerRadius = 3.0f;
}

+ (UIImage *)getImageFilledByColor:(UIColor *)color {
    
    CGRect imageRect = CGRectMake(0, 0, 50, 50);
    UIGraphicsBeginImageContext(imageRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, imageRect);
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
    
}

+ (void)showFlatAlertView:(NSString *)title andMessage:(NSString *)message {
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
}

+ (void)showSuccessOperationWithTitle:(NSString *)title inSeconds:(unsigned int)seconds followedByOperation:(VoidOperationBlock)operation {

    [SVProgressHUD setBackgroundColor:[UIColor turquoiseColor]];
    [SVProgressHUD setForegroundColor:[UIColor cloudsColor]];
    [SVProgressHUD setFont:[UIFont boldFlatFontOfSize:16]];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"correct"]];
    [SVProgressHUD showSuccessWithStatus:title];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if ( operation != nil) {
                operation();
            }
        });
        
    });
}

+ (void)showFailOperationWithTitle:(NSString *)title inSeconds:(unsigned int)seconds followedByOperation:(VoidOperationBlock)operation {
    
    [SVProgressHUD setBackgroundColor:[UIColor turquoiseColor]];
    [SVProgressHUD setForegroundColor:[UIColor cloudsColor]];
    [SVProgressHUD setFont:[UIFont boldFlatFontOfSize:16]];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
    [SVProgressHUD showErrorWithStatus:title];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if ( operation != nil) {
                operation();
            }
        });
    });
}

+ (BOOL)judgePhoneNumberValidation:(NSString *)phoneNumber {
    
    NSString *patternTel = @"^1[3,5,8][0-9]{9}$";
    NSError *error = nil;
    NSRegularExpression *TelExp = [NSRegularExpression regularExpressionWithPattern:patternTel options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult * isMatchTel = [TelExp firstMatchInString:phoneNumber options:0 range:NSMakeRange(0, [phoneNumber length])];
    if ( isMatchTel) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmptyTextField:(UITextField *)textField {
    
    if ( [textField.text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmptyTextView:(UITextView *)textView {
    
    if ( [textView.text isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

@end
