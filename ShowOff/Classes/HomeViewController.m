//
//  HomeViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "HomeViewController.h"
#import "MeViewController.h"
#import "ChannelCreateViewController.h"
#import "Universal.h"
#import "Utils.h"
#import <FlatUIKit/FlatUIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import <MJRefresh/MJRefresh.h>


typedef NS_ENUM(NSInteger, PageName) {
    CHANNEL_PAGE = 1,
    POST_PAGE
};

@interface HomeViewController ()
{
    PageName currentPageName;
}

@property (strong, nonatomic) UIBarButtonItem *createPostBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *createChannelBarButtonItem;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set navigation bar color
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    
    //set tab bar frame
    self.tabBarController.tabBar.frame = CGRectMake(0, self.tabBarController.tabBar.frame.origin.y + 15, SCREEN_WIDTH, 34);
    
    //set tab bar shadow color
    self.tabBarController.tabBar.shadowImage = [UIImage imageNamed:@"transparency"];
    
    //set navigation bar tint color
    self.navigationController.navigationBar.tintColor = [UIColor cloudsColor];
    
    //set tab bar item images to original color
    UITabBarItem *homeItem = [self.tabBarController.tabBar.items objectAtIndex:0];
    homeItem.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem.selectedImage = [[UIImage imageNamed:@"home_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *notificationItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    notificationItem.image = [[UIImage imageNamed:@"notification"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    notificationItem.selectedImage = [[UIImage imageNamed:@"notification_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *meItem = [self.tabBarController.tabBar.items objectAtIndex:2];
    meItem.image = [[UIImage imageNamed:@"me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meItem.selectedImage = [[UIImage imageNamed:@"me_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //add segmentedControl
    FUISegmentedControl *segmentedControl = [[FUISegmentedControl alloc] initWithItems:@[@"城里人", @"乡下人"]];
    
    segmentedControl.selectedFont = [UIFont boldFlatFontOfSize:12];
    segmentedControl.deselectedFont = [UIFont boldFlatFontOfSize:12];
    segmentedControl.selectedColor = [UIColor turquoiseColor];
    segmentedControl.highlightedColor = [UIColor turquoiseColor];
    segmentedControl.deselectedColor = [UIColor clearColor];
    segmentedControl.dividerColor = [UIColor turquoiseColor];
    segmentedControl.cornerRadius = 5.0;
    segmentedControl.frame = CGRectMake(segmentedControl.frame.origin.x, segmentedControl.frame.origin.y, 100, 30);
    segmentedControl.borderWidth = 1.0f;
    segmentedControl.borderColor = [UIColor turquoiseColor];
    segmentedControl.selectedSegmentIndex = 0;
    
    [segmentedControl addTarget:self action:@selector(exchangeHomePage) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
    
    //create button item
    _createChannelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(createChannel)];
    _createPostBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(createPost)];
    
    //hide post table view
    currentPageName = CHANNEL_PAGE;
    [self.navigationItem setRightBarButtonItem:_createChannelBarButtonItem];
    [_postTableView setHidden:YES];
    
    //register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNoContentView) name:@"Channel No Content" object:nil];

}

- (void)exchangeHomePage {
    
    switch (currentPageName) {
        case CHANNEL_PAGE:
            [_channelTableView setHidden:YES];
            [_postTableView setHidden:NO];
            [self.navigationItem setRightBarButtonItem:_createPostBarButtonItem];
            currentPageName = POST_PAGE;
            break;
        case POST_PAGE:
            [_channelTableView setHidden:NO];
            [_postTableView setHidden:YES];
            [self.navigationItem setRightBarButtonItem:_createChannelBarButtonItem];
            currentPageName = CHANNEL_PAGE;
        default:
            break;
    }
}

- (void)showNoContentView {
    
    
}

- (void)createChannel {
    
    ChannelCreateViewController *vc = [[ChannelCreateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createPost {
    
    
}

- (void)hottestHeaderRefresh {
    
    [_channelTableView.header endRefreshing];
}

- (void)hottestFooterRefresh {
    
    [_channelTableView.footer endRefreshing];
}

- (void)newestHeaderRefresh {
    
    
}

- (void)newestFooterRefresh {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
