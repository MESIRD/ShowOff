//
//  PostObject.m
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "PostObject.h"



@interface PostObject()

@property (strong, nonatomic) NSArray   *postImages;
@property (assign, nonatomic) NSString  *postText;
@property (strong, nonatomic) User      *user;

@end


@implementation PostObject

- (NSArray *)postImages {
    
    return _postImages;
}

- (NSString *)postText {
    
    return _postText;
}

- (User *)user {
    
    return _user;
}

- (instancetype)init {
    
    self = [super init];
    if ( self) {
        
        
    }
    return self;
}

- (void)configurePostObjectWithUser:(User *)user postText:(NSString *)postText andPostImages:(NSArray *)postImages {
    
    if ( !user) {
        return ;
    }
    
    _user = [[User alloc] init];
    _user = user;
    
    _postText = postText;
    
    if ( !postImages) {
        return ;
    }
    
    _postImages = [postImages mutableCopy];
}


@end
