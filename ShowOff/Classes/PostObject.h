//
//  PostObject.h
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface PostObject : NSObject

@property (strong, nonatomic) NSArray   *postImages;
@property (strong, nonatomic) NSString  *postText;
@property (strong, nonatomic) AVUser    *postUser;

- (NSURL *)fetchUserAvatarURL;

@end
