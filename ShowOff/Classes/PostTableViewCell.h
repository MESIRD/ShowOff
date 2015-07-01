//
//  PostTableViewCell.h
//  ShowOff
//
//  Created by xujie on 15/6/29.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITextView *postTextView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *postImages;


//configure the cell content and return the estimated height
- (CGFloat)configurePostText:(NSString *)postText PostImages:(NSArray *)postImageURLs withUserAvatarURL:(NSURL *)userAvatarURL;

@end
