//
//  PostTableView.m
//  ShowOff
//
//  Created by xujie on 15/6/29.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "PostTableView.h"
#import "PostTableViewCell.h"
#import "PostObject.h"
#import "Utils.h"
#import "NSString+SizeCalculation.h"
#import <MJRefresh/MJRefresh.h>
#import <FlatUIKit/FlatUIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface PostTableView()

@property (strong, nonatomic) NSMutableArray *postArray;
@property (strong, nonatomic) PostTableViewCell *postCell;

@end

@implementation PostTableView

static NSString * const reuseIdentifier = @"postCell";

- (void)awakeFromNib {
    
    [self setBackgroundColor:[UIColor cloudsColor]];
    
    [self registerNib:[UINib nibWithNibName:@"PostTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.tableFooterView = [[UIView alloc] init];
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    _postArray = [[NSMutableArray alloc] init];
    _postCell = [[PostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    //fetch hottest channels from server
    [self fetchNewestPosts];
}


#pragma mark - TableView DataSource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];

    //configure cell
    [cell configurePostText:[_postArray[indexPath.row] postText]
                 PostImages:[_postArray[indexPath.row] postImages]
          withUserAvatarURL:[_postArray[indexPath.row] fetchUserAvatarURL]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = [_postCell configurePostText:[_postArray[indexPath.row] postText]
                             PostImages:[_postArray[indexPath.row] postImages]
                      withUserAvatarURL:[_postArray[indexPath.row] fetchUserAvatarURL]];
    return height;
}

#pragma mark - TableView DataSource update
- (void)headerRefresh {
    
    [self fetchNewestPosts];
}

- (void)footerRefresh {
    
    [self fetchOlderPosts];
}

- (void)fetchNewestPosts {
    
    [_postArray removeAllObjects];
    AVQuery *queryChannel = [AVQuery queryWithClassName:@"Channel"];
    [queryChannel whereKey:@"objectId" equalTo:@"5590fe3be4b00777039b5110"];
    AVObject *currentChannel = [queryChannel getFirstObject];
    AVQuery *queryPost = [AVQuery queryWithClassName:@"Post"];
    [queryPost whereKey:@"belongedChannel" equalTo:currentChannel];
    [queryPost orderByDescending:@"createAt"];
    queryPost.limit = 20;
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
                    [posts addObject:post];
                }
                _postArray = [posts mutableCopy];
                [self reloadData];
                [self.header endRefreshing];
            } else {
                //post amount is zero
                [self.header endRefreshing];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Countryside Has No Post" object:nil];
            }
        } else {
            //fetching error
            [self.header endRefreshing];
            [Utils showFailOperationWithTitle:@"加载状态失败..." inSeconds:2 followedByOperation:nil];
        }
    }];
}

- (void)fetchOlderPosts {
    
    
}


@end
