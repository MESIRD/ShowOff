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
#import <FlatUIKit/FlatUIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface ChannelTableView()

@property (strong, nonatomic) NSMutableArray *channelArray;

@end

@implementation ChannelTableView

static NSString * const reuseIdentifier = @"hottestCell";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if ( self) {
        
        [self setBackgroundColor:[UIColor cloudsColor]];
        
        [self registerNib:[UINib nibWithNibName:@"ChannelTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        
        self.delegate = self;
        self.dataSource = self;
        
        _channelArray = [[NSMutableArray alloc] init];
        
        //fetch hottest channels from server
        [self fetchHottestChannels];
        [self reloadData];
    }
    return self;
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
    //    [cell configureFlatCellWithColor:[UIColor greenSeaColor] selectedColor:[UIColor silverColor] roundingCorners:UIRectCornerAllCorners];
    //    [cell setSeparatorHeight:10.0f];
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

#pragma mark - data source update

- (void)fetchHottestChannels {
    
    //still has problems
//    NSError *error = nil;
//    AVCloudQueryResult *result = [AVQuery doCloudQueryWithCQL:@"select belongedChannel from Post group by belongedChannel orderby count(belongedChannel) desc" error:&error];
//    NSLog(@"channel : %@", result.results[0]);
    
}

@end
