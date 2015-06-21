//
//  NewestTableViewCell.m
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "NewestTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface NewestTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;


@end

@implementation NewestTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configurePostWithImageURL:(NSURL *)imageURL andPostText:(NSString *)postText {
    
    [_avatar setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    _postTextLabel.text = postText;
}

@end
