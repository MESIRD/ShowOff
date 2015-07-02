//
//  UserInfoTableView.m
//  ShowOff
//
//  Created by xujie on 15/7/2.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "UserInfoTableView.h"
#import "PostTableViewCell.h"
#import "PostObject.h"
#import "Utils.h"
#import <MJRefresh/MJRefresh.h>
#import <AVOSCloud/AVOSCloud.h>

@interface UserInfoTableView()
{
    BOOL isSelf;
}

@property (nonatomic) NSMutableArray *userPostArray;

@end

@implementation UserInfoTableView

static NSString * const reuseIdentifier = @"postCell";

- (void)setUser:(AVUser *)user {
    
    _user = user;
    AVUser *currentUser = [AVUser currentUser];
    if ( currentUser && [_user.username isEqualToString:currentUser.username]) {
        isSelf = YES;
    } else {
        isSelf = NO;
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if ( self) {
        
        //initialize data source
        _userPostArray = [[NSMutableArray alloc] init];
        
        //set delegate and data source
        self.delegate = self;
        self.dataSource = self;
        
        //set table view header and footer
        
        self.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
        self.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        
        //register cell class
        [self registerNib:[UINib nibWithNibName:@"PostTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _userPostArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //configure the cell
    [cell configurePostText:[_userPostArray[indexPath.row] postText]
                 PostImages:[_userPostArray[indexPath.row] postImages]
          withUserAvatarURL:[_userPostArray[indexPath.row] userAvatarURL]];
    cell.timeLabel.text = [Utils getTimeIntervalBetweenNowAndDate:[_userPostArray[indexPath.row] postDate]];
    cell.postUserNickName.hidden = YES;
    cell.avatar.userInteractionEnabled = NO;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [_userPostArray[indexPath.row] cellHeight];
}

- (void)headerRefresh {
    
    [self fetchNewestMePosts];
}

- (void)footerRefresh {
    
    [self fetchOlderMePosts];
}

- (void)fetchNewestMePosts {
    
    [_userPostArray removeAllObjects];
    AVQuery *queryPost = [AVQuery queryWithClassName:@"Post"];
    [queryPost whereKey:@"postCreater" equalTo:_user];
    [queryPost orderByDescending:@"createdAt"];
    queryPost.limit = 10;
    [queryPost findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ( !error) {
            if ( objects.count) {
                //
                NSMutableArray *posts = [[NSMutableArray alloc] init];
                for (AVObject *obj in objects) {
                    PostObject *post = [[PostObject alloc] init];
                    post.postText = [obj objectForKey:@"postText"];
                    post.postImages = [obj objectForKey:@"postImageURLs"];
                    post.postUser = [obj objectForKey:@"postCreater"];
                    post.postDate = [obj objectForKey:@"createdAt"];
                    post.cellHeight = [self getCellHeightWithText:post.postText hasImage:(post.postImages.count > 0)];
                    [posts addObject:post];
                }
                _userPostArray = [posts mutableCopy];
                [self reloadData];
                [self.header endRefreshing];
            } else {
                //post amount is zero
                [self.header endRefreshing];
                if ( isSelf) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Me Post Number Zero" object:nil];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"User Post Number Zero" object:nil];
                }
            }
        } else {
            //fetching error
            [self.header endRefreshing];
            [Utils showFailOperationWithTitle:@"加载状态失败..." inSeconds:2 followedByOperation:nil];
        }
    }];
}

- (void)fetchOlderMePosts {
    
    AVQuery *queryPost = [AVQuery queryWithClassName:@"Post"];
    [queryPost whereKey:@"postCreater" equalTo:_user];
    [queryPost orderByDescending:@"createdAt"];
    queryPost.skip = _userPostArray.count;
    queryPost.limit = 10;
    [queryPost findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ( !error) {
            if ( objects.count) {
                //
                NSMutableArray *posts = [[NSMutableArray alloc] init];
                for (AVObject *obj in objects) {
                    PostObject *post = [[PostObject alloc] init];
                    post.postText = [obj objectForKey:@"postText"];
                    post.postImages = [obj objectForKey:@"postImageURLs"];
                    post.postUser = [obj objectForKey:@"postCreater"];
                    post.postDate = [obj objectForKey:@"createdAt"];
                    post.cellHeight = [self getCellHeightWithText:post.postText hasImage:(post.postImages.count > 0)];
                    [posts addObject:post];
                }
                [_userPostArray addObjectsFromArray:posts];
                [self reloadData];
                [self.header endRefreshing];
            } else {
                //post amount is zero
                [self.header endRefreshing];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"User No More Post" object:nil];
            }
        } else {
            //fetching error
            [self.header endRefreshing];
            [Utils showFailOperationWithTitle:@"加载状态失败..." inSeconds:2 followedByOperation:nil];
        }
    }];
}

- (CGFloat)getCellHeightWithText:(NSString *)postText hasImage:(BOOL)hasImage {
    
    CGFloat height = 0.0;
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 36, 266, 26)];
    textView.text = postText;
    textView.font = [UIFont systemFontOfSize:15];
    CGSize maximumSize = CGSizeMake(266, 9999);
    height += 36;
    height += [Utils getSizeOfTextView:textView withinSize:maximumSize].height;
    height += 8;
    if ( hasImage) {
        height += 100 + 8;
    }
    height += 21 + 8;
    height = height > 50 ? height : 50;
    return height;
}

@end
