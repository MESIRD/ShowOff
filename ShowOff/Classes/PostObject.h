//
//  PostObject.h
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface PostObject : NSObject

- (NSArray *)postImages;
- (NSString *)postText;
- (User *)user;

- (void)configurePostObjectWithUser:(User *)user postText:(NSString *)postText andPostImages:(NSArray *)postImages;

@end
