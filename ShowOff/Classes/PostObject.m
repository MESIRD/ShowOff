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

- (NSURL *)fetchUserAvatarURL {
    
    AVUser *user = (AVUser *)[_postUser fetchIfNeeded];
    AVQuery *queryUserPreference = [AVQuery queryWithClassName:@"UserPreference"];
    [queryUserPreference whereKey:@"belongedUser" equalTo:user];
    AVObject *userPreference = [queryUserPreference getFirstObject];
    return [NSURL URLWithString:[userPreference objectForKey:@"userAvatarURL"]];
}

@end
