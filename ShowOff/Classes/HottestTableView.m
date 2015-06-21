//
//  HottestTableView.m
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "HottestTableView.h"
#import "HottestTableViewCell.h"
#import "UITableViewCell+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "PostObject.h"

@interface HottestTableView()

@property (nonatomic) NSMutableArray *hottestPostArray;

@end

@implementation HottestTableView

static NSString * const reuseIdentifier = @"hottestCell";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if ( self) {
        
        [self setBackgroundColor:[UIColor cloudsColor]];
        
        [self registerClass:[HottestTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
        [self registerNib:[UINib nibWithNibName:@"HottestTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
        
        self.delegate = self;
        self.dataSource = self;
        
        _hottestPostArray = [[NSMutableArray alloc] init];
        
        //fetch hottest posts from server
        [self fetchHottestPosts];
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
    return _hottestPostArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HottestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
//    [cell configureFlatCellWithColor:[UIColor greenSeaColor] selectedColor:[UIColor silverColor] roundingCorners:UIRectCornerAllCorners];
//    [cell setSeparatorHeight:10.0f];
    
    
    PostObject *postObject = _hottestPostArray[indexPath.row];
    [cell configurePostWithImageURL:[[postObject user] avatarURL] andPostText:[postObject postText]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

#pragma mark - data source update

- (void)fetchHottestPosts {
    
    for (int i = 0; i < 20; i ++) {
        PostObject *postObject = [[PostObject alloc] init];
        [postObject configurePostObjectWithUser:[User userWithUserId:@"1" userName:@"mesird" andAvatarURL:[NSURL URLWithString:@"http://img4.imgtn.bdimg.com/it/u=1002497239,3170408703&fm=11&gp=0.jpg"]] postText:@"今天中午食堂的饭感觉还不错！" andPostImages:nil];
        [_hottestPostArray addObject:postObject];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
