//
//  NewestTableViewCell.h
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewestTableViewCell : UITableViewCell

- (void)configurePostWithImageURL:(NSURL *)imageURL andPostText:(NSString *)postText;

@end
