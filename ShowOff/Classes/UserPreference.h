//
//  UserPreference.h
//  ShowOff
//
//  Created by xujie on 15/6/25.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

typedef void (^SaveCompleteBlock)(BOOL succeeded, NSError *error);

@interface UserPreference : NSObject

@property (nonatomic)   NSString *userNickName;
@property (nonatomic)   NSString *userDescription;
@property (nonatomic)   NSString *userAvatarURL;
@property (nonatomic)   NSString *userBackgroundColor;
@property (nonatomic)   NSString *userGender;
@property (nonatomic)   NSString *userSexualOrientation;
@property (nonatomic)   NSInteger viewNumber;
@property (nonatomic)   NSInteger appreciateNumber;

+ (instancetype)sharedUserPreference;

- (instancetype)initWithUserName:(NSString *)userName;
- (instancetype)initWithAVObject:(AVObject *)obj;

- (void)configureWithAVObject:(AVObject *)obj;

- (void)storeUserPreferenceInUserDefaults;
- (void)fetchUserPreferenceFromUserDefaults;
- (void)removeUserPreferenceInUserDefaults;

@end
