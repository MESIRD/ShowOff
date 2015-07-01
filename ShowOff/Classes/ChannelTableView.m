//
//  ChannelTableView.m
//  ShowOff
//
//  Created by xujie on 15/6/29.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "ChannelTableView.h"
#import "ChannelTableViewCell.h"
#import "ChannelObject.h"
#import "Utils.h"
#import <FlatUIKit/FlatUIKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import <AVOSCloud/AVOSCloud.h>

@interface ChannelTableView()

@property (nonatomic)   NSMutableArray     *channelArray;

@end

@implementation ChannelTableView

static NSString * const reuseIdentifier = @"channelCell";

- (void)awakeFromNib {
    
    [self setBackgroundColor:[UIColor cloudsColor]];
    
    [self registerNib:[UINib nibWithNibName:@"ChannelTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.tableFooterView = [[UIView alloc] init];
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    _channelArray = [[NSMutableArray alloc] init];
    
    //fetch hottest channels from server
    [self fetchNewestChannels];
}

- (void)headerRefresh {
    
    [self fetchNewestChannels];
}

- (void)footerRefresh {
    
    [self fetchOlderChannels];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return _channelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.channelTitle.text = [(ChannelObject *)_channelArray[indexPath.row] channelTitle];
    cell.channelDescription.text = [(ChannelObject *)_channelArray[indexPath.row] channelDescription];
    NSURL *url = [(ChannelObject *)_channelArray[indexPath.row] channelBackgroundImageURL];
    [cell.backgroundImageView setImageWithURL:url];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 140;
}

#pragma mark - data source update

- (void)fetchNewestChannels {
    
    [_channelArray removeAllObjects];
    AVQuery *query = [AVQuery queryWithClassName:@"Channel"];
    [query whereKey:@"objectId" notEqualTo:@"5590fe3be4b00777039b5110"];
    [query orderByDescending:@"updatedAt"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ( !error) {
            if ( objects.count) {
                //has several channels
                NSMutableArray *channels = [[NSMutableArray alloc] init];
                for (AVObject *obj in objects) {
                    ChannelObject *channel = [[ChannelObject alloc] init];
                    channel.channelTitle = [obj objectForKey:@"channelTitle"];
                    channel.channelDescription = [obj objectForKey:@"channelDescription"];
                    channel.channelBackgroundImageURL = [NSURL URLWithString:[obj objectForKey:@"channelBackgroundImageURL"]];
                    [channels addObject:channel];
                }
                _channelArray = [channels mutableCopy];
                [self reloadData];
                [self.header endRefreshing];
            } else {
                //channel amount is zero
                [self.header endRefreshing];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"City Has No Channel" object:nil];
            }
        } else {
            //fetching channels with error
            [self.header endRefreshing];
            [Utils showFailOperationWithTitle:@"加载逼格夹失败..." inSeconds:2 followedByOperation:nil];
        }
    }];
}

- (void)fetchOlderChannels {
    
    AVQuery *query = [AVQuery queryWithClassName:@"Channel"];
    [query whereKey:@"objectId" notEqualTo:@"5590fe3be4b00777039b5110"];
    [query orderByDescending:@"updatedAt"];
    query.limit = 10;
    query.skip = _channelArray.count;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ( !error) {
            if ( objects.count) {
                //has several older channels
                NSMutableArray *channels = [[NSMutableArray alloc] init];
                for (AVObject *obj in objects) {
                    ChannelObject *channel = [[ChannelObject alloc] init];
                    channel.channelTitle = [obj objectForKey:@"channelTitle"];
                    channel.channelDescription = [obj objectForKey:@"channelDescription"];
                    channel.channelBackgroundImageURL = [NSURL URLWithString:[obj objectForKey:@"channelBackgroundImageURL"]];
                    [channels addObject:channel];
                }
                [_channelArray addObjectsFromArray:channels];
            } else {
                //there's no more channels could be loaded
                [self.footer noticeNoMoreData];
            }
        } else {
            //fetching channels with error
            [Utils showFailOperationWithTitle:@"加载逼格夹失败..." inSeconds:2 followedByOperation:nil];
        }
    }];
}

@end
