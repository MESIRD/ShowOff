//
//  PostTableViewCell.m
//  ShowOff
//
//  Created by xujie on 15/6/29.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "PostTableViewCell.h"
#import "NSString+SizeCalculation.h"
#import "Utils.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation PostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self) {
        _avatar.layer.cornerRadius = _avatar.frame.size.height/2;
        _avatar.layer.masksToBounds = YES;
        
        for (UIImageView *imageView in _postImages) {
            imageView.layer.cornerRadius = 5.0;
            imageView.layer.masksToBounds = YES;
            
            imageView.backgroundColor = [UIColor orangeColor];
        }
        _postTextView.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)awakeFromNib {
    
    _avatar.layer.cornerRadius = _avatar.frame.size.height/2;
    _avatar.layer.masksToBounds = YES;
    
    for (UIImageView *imageView in _postImages) {
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = YES;
        
        imageView.backgroundColor = [UIColor orangeColor];
    }
    _postTextView.backgroundColor = [UIColor orangeColor];
}

- (CGFloat)configurePostText:(NSString *)postText PostImages:(NSArray *)postImageURLs withUserAvatarURL:(NSURL *)userAvatarURL {
    
    CGFloat cellEstimatedHeight = 0.0;
    [_avatar setImageWithURL:userAvatarURL placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    //calculate the estimated height of this cell
    _postTextView.text = postText;
    CGSize maximumLabelSize = CGSizeMake(266, 9999);
    CGSize expectSize = [Utils getSizeOfTextView:_postTextView withinSize:maximumLabelSize];
    //resize the label frame
    CGRect labelRect = _postTextView.frame;
    labelRect.size.height = expectSize.height;
    _postTextView.frame = labelRect;
    //configure post images
    if ( postImageURLs && postImageURLs.count) {
        //given that there are no more than three postImages in this array
        for ( int i = 0; i < postImageURLs.count; i ++) {
            [((UIImageView *)_postImages[i]) setImageWithURL:[NSURL URLWithString:postImageURLs[i]]];
            CGRect imageRect = ((UIImageView *)_postImages[i]).frame;
            imageRect.origin.y = labelRect.origin.y + labelRect.size.height + 10;
            [_postImages[i] setFrame:imageRect ];
        }
        for ( int i = (int)postImageURLs.count; i < 3; i ++) {
            [_postImages[i] setHidden:YES];
        }
        cellEstimatedHeight = labelRect.origin.y + labelRect.size.height + ((UIImageView *)_postImages[0]).frame.origin.y + ((UIImageView *)_postImages[0]).frame.size.height + 10;
        if ( cellEstimatedHeight < _avatar.frame.origin.y + _avatar.frame.size.height) {
            cellEstimatedHeight = _avatar.frame.origin.y + _avatar.frame.size.height + 10;
        }
        return cellEstimatedHeight;
    } else {
        for (UIImageView *imageView in _postImages) {
            [imageView setHidden:YES];
        }
        cellEstimatedHeight = labelRect.origin.y + labelRect.size.height + 10;
        if ( cellEstimatedHeight < _avatar.frame.origin.y + _avatar.frame.size.height) {
            cellEstimatedHeight = _avatar.frame.origin.y + _avatar.frame.size.height + 10;
        }
        return cellEstimatedHeight;
    }
}

@end
