//
//  AboutTableView.m
//  ShowOff
//
//  Created by mesird on 6/27/15.
//  Copyright (c) 2015 mesird. All rights reserved.
//

#import "AboutTableView.h"

@interface AboutTableView()

@property (nonatomic) NSArray *aboutOptionArray;

@end

@implementation AboutTableView

static NSString * const reuseIdentifier = @"aboutCell";

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self) {
        
        //init table data source
        _aboutOptionArray = @[@"应用商店评价"];
        
        self.delegate = self;
        self.dataSource = self;
        
        [self reloadData];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _aboutOptionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = _aboutOptionArray[indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            //app store review
            
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [tableView footerViewForSection:section];
    if ( footerView == nil) {
        footerView = [[UIView alloc] init];
    }
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [tableView headerViewForSection:section];
    if ( headerView == nil) {
        headerView = [[UIView alloc] init];
    }
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}



@end
