//
//  PostObject.m
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "PostObject.h"
#import <AVOSCloud/AVOSCloud.h>



@interface PostObject()

@end


@implementation PostObject

- (void)setPostUser:(AVUser *)postUser {
    
    _postUser = postUser;
    _postUser = (AVUser *)[_postUser fetchIfNeeded];
    AVQuery *queryUserPreference = [AVQuery queryWithClassName:@"UserPreference"];
    [queryUserPreference whereKey:@"belongedUser" equalTo:_postUser];
    AVObject *userPreference = [queryUserPreference getFirstObject];
    _userAvatarURL = [NSURL URLWithString:[userPreference objectForKey:@"userAvatarURL"]];
    _postUserNickName = [userPreference objectForKey:@"userNickName"];
}

@end
