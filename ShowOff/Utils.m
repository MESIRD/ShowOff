//
//  Utils.m
//  ShowOff
//
//  Created by xujie on 15/6/23.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "Utils.h"
#import "Universal.h"


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
#ifdef APPLICATION_UNIVERSAL_FONT
    [button.titleLabel setFont:[UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:16]];
#endif
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

+ (void)configureFUITextField:(FUITextField *)textField withPlaceHolder:(NSString *)placeHolder andIndent:(BOOL)isIndent {
    
    textField.font = [UIFont flatFontOfSize:16];
    textField.backgroundColor = [UIColor clearColor];
    textField.placeholder = placeHolder;
    if ( isIndent) {
        textField.edgeInsets = UIEdgeInsetsMake(4.0f, 30.0f, 4.0f, 15.0f);
    } else {
        textField.edgeInsets = UIEdgeInsetsMake(4.0f, 5.0f, 4.0f, 15.0f);
    }
    textField.textFieldColor = [UIColor whiteColor];
    textField.borderColor = [UIColor turquoiseColor];
    textField.borderWidth = 2.0f;
    textField.cornerRadius = 3.0f;
#ifdef APPLICATION_UNIVERSAL_FONT
    [textField setFont:[UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:16]];
#endif
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

+ (UIButton *)getCustomBarButtonViewWithTitle:(NSString *)buttonTitle target:(id)target andAction:(SEL)action {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 24)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
#ifdef APPLICATION_UNIVERSAL_FONT
    [button.titleLabel setFont:[UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:16]];
#endif
    return button;
}

+ (CGSize)getSizeOfTextView:(UITextView *)textView withinSize:(CGSize)size {
    
    return [textView sizeThatFits:size];
}

+ (NSString *)getTimeIntervalBetweenNowAndDate:(NSDate *)date {
    
    int timeInterval = -((int)[date timeIntervalSinceNow]);
    if ( timeInterval/60 == 0) {
        //within one minute
        return [NSString stringWithFormat:@"%d秒前", timeInterval];
    } else if ( timeInterval/3600 == 0) {
        //within one hour
        return [NSString stringWithFormat:@"%d分钟前", timeInterval/60];
    } else if ( timeInterval/86400 == 0) {
        //within one day
        return [NSString stringWithFormat:@"%d小时前", timeInterval/3600];
    } else {
        //more than one day
        return [NSString stringWithFormat:@"%d天前", timeInterval/86400];
    }
}

+ (UIImage *)clipImage:(UIImage *)image inRect:(CGRect)rect {
    
    CGImageRef imageRef = image.CGImage;
    CGImageRef cgImage = CGImageCreateWithImageInRect(imageRef, rect);
    return [UIImage imageWithCGImage:cgImage];
}

+ (void)showFlatAlertView:(NSString *)title andMessage:(NSString *)message {
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:message
                                                         delegate:nil cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    alertView.titleLabel.font = [UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    alertView.messageLabel.font = [UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    alertView.defaultButtonFont = [UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
}

+ (void)showProcessingOperation {
    
    [SVProgressHUD setBackgroundColor:[UIColor turquoiseColor]];
    [SVProgressHUD setForegroundColor:[UIColor cloudsColor]];
    [SVProgressHUD setRingThickness:4.0];
    [SVProgressHUD show];
}

+ (void)hideProcessingOperation {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

+ (void)showSuccessOperationWithTitle:(NSString *)title inSeconds:(unsigned int)seconds followedByOperation:(VoidOperationBlock)operation {

    [SVProgressHUD setBackgroundColor:[UIColor turquoiseColor]];
    [SVProgressHUD setForegroundColor:[UIColor cloudsColor]];
    [SVProgressHUD setFont:[UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:16]];
    [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"correct"]];
    [SVProgressHUD showSuccessWithStatus:title];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            sleep(seconds);
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
    [SVProgressHUD setFont:[UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:16]];
    [SVProgressHUD setErrorImage:[UIImage imageNamed:@"error"]];
    [SVProgressHUD showErrorWithStatus:title];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            sleep(seconds);
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

+ (UIViewController *)viewControllerWithEmbededView:(UIView *)view {
    
    for (UIView *superView = view.superview; superView; superView = superView.superview) {
        UIResponder *responder = [superView nextResponder];
        if ( [responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

@end
