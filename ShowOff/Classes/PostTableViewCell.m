//
//  PostTableViewCell.m
//  ShowOff
//
//  Created by xujie on 15/6/29.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "PostTableViewCell.h"
#import "NSString+SizeCalculation.h"
#import "Universal.h"
#import "Utils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <JTSImageViewController/JTSImageViewController.h>
#import <AVOSCloud/AVOSCloud.h>

@interface PostTableViewCell()

@property (strong, nonatomic) UITextView *postTextView;

@end

@implementation PostTableViewCell

- (void)awakeFromNib {
    
    _avatar.layer.cornerRadius = _avatar.frame.size.height/2;
    _avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _avatar.layer.borderWidth = 1.0;
    _avatar.layer.masksToBounds = YES;
    UITapGestureRecognizer *avatarTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAtAvatar:)];
    [_avatar addGestureRecognizer:avatarTapRecognizer];
    
    for (UIImageView *imageView in _postImages) {
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAtImage:)];
        [imageView addGestureRecognizer:tapRecognizer];
        imageView.layer.cornerRadius = 2.0;
        imageView.layer.masksToBounds = YES;
    }
    
    _postTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, 36, 266, 26)];
    _postTextView.scrollEnabled = NO;
    _postTextView.font = [UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:15];
    [self addSubview:_postTextView];
    
    _timeLabel.font = [UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:12];
    _postUserNickName.font = [UIFont fontWithName:APPLICATION_UNIVERSAL_FONT size:12];
}

- (void)tapAtAvatar:(UITapGestureRecognizer *)tapRecognizer {
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:_indexPath, @"indexPath", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Tap At Post Avatar" object:nil userInfo:dictionary];
}

- (void)tapAtImage:(UITapGestureRecognizer *)tapRecognizer {
    
    UIImageView *imageView = (UIImageView *)tapRecognizer.view;
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = imageView.image;
    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = imageView.superview;
    
    JTSImageViewController *imageViewController = [[JTSImageViewController alloc] initWithImageInfo:imageInfo
                                                                                               mode:JTSImageViewControllerMode_Image
                                                                                    backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    [imageViewController showFromViewController:[Utils viewControllerWithEmbededView:self] transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (CGFloat)configurePostText:(NSString *)postText PostImages:(NSArray *)postImageURLs withUserAvatarURL:(NSURL *)userAvatarURL {
    
    CGFloat cellEstimatedHeight = 0.0;
    [_avatar sd_setImageWithURL:userAvatarURL placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    
    //calculate the estimated height of this cell
    _postTextView.text = postText;
    CGSize maximumLabelSize = CGSizeMake(266, 9999);
    CGSize expectSize = [Utils getSizeOfTextView:_postTextView withinSize:maximumLabelSize];
    //resize the label frame
    CGRect labelRect = _postTextView.frame;
    labelRect.size.height = expectSize.height;
    _postTextView.frame = labelRect;
    cellEstimatedHeight += labelRect.origin.y + labelRect.size.height + 8;
    
    //configure post images
    if ( postImageURLs && postImageURLs.count) {
        //given that there are no more than three postImages in this array
        for ( int i = 0; i < postImageURLs.count; i ++) {
            [_postImages[i] setHidden:NO];
            [((UIImageView *)_postImages[i]) sd_setImageWithURL:postImageURLs[i] placeholderImage:[UIImage imageNamed:@"default_post_image"]];
            CGRect imageRect = ((UIImageView *)_postImages[i]).frame;
            imageRect.origin.y = cellEstimatedHeight;
            [_postImages[i] setFrame:imageRect ];
        }
        for ( int i = (int)postImageURLs.count; i < 3; i ++) {
            [_postImages[i] setHidden:YES];
        }
        cellEstimatedHeight += ((UIImageView *)_postImages[0]).frame.size.height + 8;
        //set time label frame
        CGRect timeRect = _timeLabel.frame;
        timeRect.origin.y = cellEstimatedHeight;
        _timeLabel.frame = timeRect;
        cellEstimatedHeight += timeRect.size.height + 8;
        //judge the height with avatar height
        if ( cellEstimatedHeight < _avatar.frame.origin.y + _avatar.frame.size.height) {
            cellEstimatedHeight = _avatar.frame.origin.y + _avatar.frame.size.height + 8;
        }
        return cellEstimatedHeight;
    } else {
        for (UIImageView *imageView in _postImages) {
            [imageView setHidden:YES];
        }
        //set time label frame
        CGRect timeRect = _timeLabel.frame;
        timeRect.origin.y = cellEstimatedHeight;
        _timeLabel.frame = timeRect;
        cellEstimatedHeight += timeRect.size.height + 8;
        //judege the height with avatar height
        if ( cellEstimatedHeight < _avatar.frame.origin.y + _avatar.frame.size.height) {
            cellEstimatedHeight = _avatar.frame.origin.y + _avatar.frame.size.height + 8;
        }
        return cellEstimatedHeight;
    }
}

@end
