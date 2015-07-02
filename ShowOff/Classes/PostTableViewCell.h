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
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *postImages;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *postUserNickName;
@property (nonatomic)                NSIndexPath *indexPath;


//configure the cell content and return the estimated height
- (CGFloat)configurePostText:(NSString *)postText PostImages:(NSArray *)postImageURLs withUserAvatarURL:(NSURL *)userAvatarURL;

@end
