//
//  PostObject.h
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostObject : NSObject

@property (strong, nonatomic) NSArray   *postImages;
@property (assign, nonatomic) NSString  *postText;
@property (strong, nonatomic) NSString  *userId;

- (NSURL *)fetchUserAvatarURL;

@end
