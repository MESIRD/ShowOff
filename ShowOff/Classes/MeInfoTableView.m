//
//  MeInfoTableView.m
//  ShowOff
//
//  Created by xujie on 15/6/24.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "MeInfoTableView.h"
#import "MeInfoTableViewCell.h"
#import "MJRefresh.h"

@interface MeInfoTableView()

@property (nonatomic) NSMutableArray *mePostsArray;

@end

@implementation MeInfoTableView

static NSString * const reuseIdentifier = @"meInfoTableViewCell";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if ( self) {
        
        //initialize data source
        _mePostsArray = [[NSMutableArray alloc] init];
        
        [self fetchMePosts];
        
        //set delegate and data source
        self.delegate = self;
        self.dataSource = self;
        
        //set table view header and footer

        self.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMePosts)];
        self.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(addMorePosts)];
        
        //register cell class
        [self registerNib:[UINib nibWithNibName:@"MeInfoTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _mePostsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.postText.text = _mePostsArray[indexPath.row][@"postText"];
    cell.avatar.image = [UIImage imageNamed:_mePostsArray[indexPath.row][@"avatar"]];
    cell.nickName.text = _mePostsArray[indexPath.row][@"nickName"];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_mePostsArray[indexPath.row][@"hasPhoto"] boolValue]) {
        return 150;
    } else {
        return 94;
    }
}

- (void)fetchMePosts {
    
    //fetching posts from server using GCD
    [self.header beginRefreshing];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //fetching operations
        sleep(1);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (_mePostsArray.count == 0) {
                [self.header endRefreshing];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Me Post Number Zero" object:nil];
            }
        });
    });
}

- (void)refreshMePosts {
    
    [self.header endRefreshing];
}

- (void)addMorePosts{
    
    [self.footer endRefreshing];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
