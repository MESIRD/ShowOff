//
//  PostCreateViewController.h
//  ShowOff
//
//  Created by xujie on 15/6/29.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSDTextView.h"
#import <FlatUIKit/FUIButton.h>

@interface PostCreateViewController : UIViewController

@property (weak, nonatomic) IBOutlet MSDTextView *postTextView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *postImageViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *addImageSigns;
@property (strong, nonatomic) IBOutletCollection(FUIButton) NSArray *removeButtons;


@end
