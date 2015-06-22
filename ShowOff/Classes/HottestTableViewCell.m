//
//  HottestTableViewCell.m
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "HottestTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface HottestTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;


@end

@implementation HottestTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _avatar.layer.cornerRadius = _avatar.frame.size.height/2;
    _avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _avatar.layer.borderWidth = 1.0f;
    _avatar.layer.masksToBounds = YES;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 280, self.frame.size.height);
    
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
