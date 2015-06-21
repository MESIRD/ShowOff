//
//  User.m
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "User.h"

@interface User()

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSURL    *avatarURL;

@end

@implementation User

- (NSString *)userId {
    
    return _userId;
}

- (NSString *)userName {
    
    return _userName;
}

- (NSURL *)avatarURL {
    
    return _avatarURL;
}

+ (instancetype)userWithUserId:(NSString *)userId userName:(NSString *)userName andAvatarURL:(NSURL *)avatarURL {
    
    User *user = [[User alloc] init];
    
    [user configureUserWithUserId:userId userName:userName andAvatarURL:avatarURL];
    
    return user;
}

- (instancetype)initWithUserId:(NSString *)userId userName:(NSString *)userName andAvatarURL:(NSURL *)avatarURL {
    
    self = [super init];
    if ( self) {
        
        [self configureUserWithUserId:userId userName:userName andAvatarURL:avatarURL];
    }
    return self;
}

- (void)configureUserWithUserId:(NSString *)userId userName:(NSString *)userName andAvatarURL:(NSURL *)avatarURL {
    
    _userId = [NSString stringWithString:userId];
    _userName = [NSString stringWithString:userName];
    _avatarURL = [avatarURL copy];
}

@end
