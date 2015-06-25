//
//  UserPreference.m
//  ShowOff
//
//  Created by xujie on 15/6/25.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "UserPreference.h"
#import <AVOSCloud/AVOSCloud.h>

@interface UserPreference()

@end

@implementation UserPreference

/*
 @property (nonatomic)   NSString *userNickName;
 @property (nonatomic)   NSString *userDescription;
 @property (nonatomic)   NSString *userAvatarURL;
 @property (nonatomic)   UIColor  *userBackgroundColor;
 @property (nonatomic)   NSString *userGender;
 @property (nonatomic)   NSString *userSexualOrientation;
 @property (nonatomic)   NSInteger viewNumber;
 @property (nonatomic)   NSInteger appreciateNumber;
 */

@synthesize userNickName = _userNickName;
@synthesize userDescription = _userDescription;
@synthesize userAvatarURL = _userAvatarURL;
@synthesize userBackgroundColor = _userBackgroundColor;
@synthesize userGender = _userGender;
@synthesize userSexualOrientation = _userSexualOrientation;
@synthesize viewNumber = _viewNumber;
@synthesize appreciateNumber = _appreciateNumber;

- (void)setUserNickName:(NSString *)userNickName {
    
    _userNickName = userNickName;
}

- (void)setUserDescription:(NSString *)userDescription {
    
    _userDescription = userDescription;
}

- (void)setUserAvatarURL:(NSString *)userAvatarURL {
    
    _userAvatarURL = userAvatarURL;
}

- (void)setUserBackgroundColor:(NSString *)userBackgroundColor {
    
    _userBackgroundColor = userBackgroundColor;
}

- (void)setUserGender:(NSString *)userGender {
    
    _userGender = userGender;
}

- (void)setUserSexualOrientation:(NSString *)userSexualOrientation {
    
    _userSexualOrientation = userSexualOrientation;
}

- (void)setViewNumber:(NSInteger)viewNumber {
    
    _viewNumber = viewNumber;
}

- (void)setAppreciateNumber:(NSInteger)appreciateNumber {
    
    _appreciateNumber = appreciateNumber;
}

- (NSString *)userNickName {
    
    if ( !_userNickName) {
        _userNickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNickName"];
    }
    return _userNickName;
}

- (NSString *)userDescription {
    
    if ( !_userDescription) {
        _userDescription = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDescription"];
    }
    return _userDescription;
}

- (NSString *)userAvatarURL {
    
    if ( !_userAvatarURL) {
        _userAvatarURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAvatarURL"];
    }
    return _userAvatarURL;
}

- (NSString *)userBackgroundColor {
    
    if ( !_userBackgroundColor) {
        _userBackgroundColor = [[NSUserDefaults standardUserDefaults] objectForKey:@"userBackgroundColor"];
    }
    return _userBackgroundColor;
}

- (NSString *)userGender {
    
    if ( !_userGender) {
        _userGender = [[NSUserDefaults standardUserDefaults] objectForKey:@"userGender"];
    }
    return _userGender;
}

- (NSString *)userSexualOrientation {
    
    if ( !_userSexualOrientation) {
        _userSexualOrientation = [[NSUserDefaults standardUserDefaults] objectForKey:@"userSexualOrientation"];
    }
    return _userSexualOrientation;
}

- (NSInteger)viewNumber {
    
    _viewNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"viewNumber"] integerValue];
    return _viewNumber;
}

- (NSInteger)appreciateNumber {
    
    _appreciateNumber = [[[NSUserDefaults standardUserDefaults] objectForKey:@"appreciateNumber"] integerValue];
    return _viewNumber;
}

+ (instancetype)sharedUserPreference {
    
    static UserPreference *sharedUserPreference = nil;
    if ( sharedUserPreference == nil) {
        sharedUserPreference = [[UserPreference alloc] init];
    }
    return sharedUserPreference;
}

- (instancetype)initWithUserName:(NSString *)userName {
    
    self = [super init];
    if ( self) {
        
        self.userNickName = userName;
        self.userDescription = @"在干什么...";
        self.userAvatarURL = @"";
        self.userBackgroundColor = @"103,99,76";
        self.userGender = @"保密";
        self.userSexualOrientation = @"保密";
        self.viewNumber = 0;
        self.appreciateNumber = 0;
    }
    return self;
}

- (instancetype)initWithAVObject:(AVObject *)obj {
    
    self = [super init];
    if ( self) {
        
        self.userNickName =          [obj objectForKey:@"userNickName"];
        self.userDescription =       [obj objectForKey:@"userDescription"];
        self.userAvatarURL =         [obj objectForKey:@"userAvatarURL"];
        self.userBackgroundColor =   [obj objectForKey:@"userBackgroundColor"];
        self.userGender =            [obj objectForKey:@"userGener"];
        self.userSexualOrientation = [obj objectForKey:@"userSexualOrientation"];
        self.viewNumber =            [[obj objectForKey:@"viewNumber"] integerValue];
        self.appreciateNumber =      [[obj objectForKey:@"appreciateNumber"] integerValue];
    }
    return self;
}

- (void)storeUserPreferenceInUserDefaults {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_userNickName forKey:@"userNickName"];
    [ud setObject:_userDescription forKey:@"userDescription"];
    [ud setObject:_userAvatarURL forKey:@"userAvatarURL"];
    [ud setObject:_userBackgroundColor forKey:@"userBackgroundColor"];
    [ud setObject:_userGender forKey:@"userGender"];
    [ud setObject:_userSexualOrientation forKey:@"userSexualOrientation"];
    [ud setObject:[NSNumber numberWithInteger:_viewNumber] forKey:@"viewNumber"];
    [ud setObject:[NSNumber numberWithInteger:_appreciateNumber] forKey:@"appreciateNumber"];
}

- (void)fetchUserPreferenceFromUserDefaults {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    self.userNickName =          [ud objectForKey:@"userNickName"];
    self.userDescription =       [ud objectForKey:@"userDescription"];
    self.userAvatarURL =         [ud objectForKey:@"userAvatarURL"];
    self.userBackgroundColor =   [ud objectForKey:@"userBackgroundColor"];
    self.userGender =            [ud objectForKey:@"userGender"];
    self.userSexualOrientation = [ud objectForKey:@"userSexualOrientation"];
    self.viewNumber =            [[ud objectForKey:@"viewNumber"] integerValue];
    self.appreciateNumber =      [[ud objectForKey:@"appreciateNumber"] integerValue];
}

+ (void)removeUserPreferenceInUserDefaults {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"userNickName"];
    [ud removeObjectForKey:@"userDescription"];
    [ud removeObjectForKey:@"userAvatarURL"];
    [ud removeObjectForKey:@"userBackgroundColor"];
    [ud removeObjectForKey:@"userGender"];
    [ud removeObjectForKey:@"userSexualOrientation"];
    [ud removeObjectForKey:@"viewNumber"];
    [ud removeObjectForKey:@"appreciateNumber"];
}


@end
