//
//  User.h
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (instancetype)userWithUserId:(NSString *)userId userName:(NSString *)userName andAvatarURL:(NSURL *)avatarURL;

- (NSString *)userId;
- (NSString *)userName;
- (NSURL *)avatarURL;

- (instancetype)initWithUserId:(NSString *)userId userName:(NSString *)userName andAvatarURL:(NSURL *)avatarURL;

@end
