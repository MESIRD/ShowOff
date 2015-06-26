//
//  ColorChangeCollectionViewController.m
//  ShowOff
//
//  Created by mesird on 6/26/15.
//  Copyright (c) 2015 mesird. All rights reserved.
//

#import "ColorChangeCollectionViewController.h"
#import "UserPreference.h"
#import "Utils.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ColorChangeCollectionViewController ()

@property (nonatomic) NSArray *colorCollection;

@end

@implementation ColorChangeCollectionViewController

static NSString * const reuseIdentifier = @"colorCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"修改背景色";
    
    //initialize colorCollection
    _colorCollection = @[@"253,195,173", @"253,223,173", @"243,253,173", @"204,253,173",
                         @"173,253,201", @"173,253,245", @"173,229,253", @"173,182,253",
                         @"226,173,253", @"253,173,220", @"253,173,173", @"103,76,76",
                         @"103,99,76",   @"83,103,76",   @"76,100,103",  @"94,76,103",
                         @"146,3,7",     @"146,86,3",    @"140,146,3",   @"39,146,3",
                         @"3,146,145",   @"3,108,146",   @"3,22,146",    @"90,3,146",
                         @"146,3,125"
                         
                         ];
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _colorCollection.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSArray *rgb = [_colorCollection[indexPath.row] componentsSeparatedByString:@","];
    cell.backgroundColor = [UIColor colorWithRed:[rgb[0] floatValue]/255 green:[rgb[1] floatValue]/255 blue:[rgb[2] floatValue]/255 alpha:1];
    
    cell.layer.cornerRadius = 5.0;
    cell.layer.masksToBounds = YES;
    if ( [_selectedColor isEqualToString:_colorCollection[indexPath.row]]) {
        cell.layer.borderColor = [UIColor colorWithWhite:1 alpha:1].CGColor;
        cell.layer.borderWidth = 3.0;
    } else {
        cell.layer.borderWidth = 0;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( [_selectedColor isEqualToString:_colorCollection[indexPath.row]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    _selectedColor = _colorCollection[indexPath.row];
    [self.collectionView reloadData];
    
    [self handleSelectOperationWithColor:_colorCollection[indexPath.row]];
}

#pragma mark - Select Operation

- (void)handleSelectOperationWithColor:(NSString *)backgroundColor {


    [Utils showProcessingOperation];
    AVQuery *query = [AVQuery queryWithClassName:@"UserPreference"];
    [query whereKey:@"belongedUser" equalTo:[AVUser currentUser]];
    AVObject *obj = [query findObjects][0];
    [obj setObject:backgroundColor forKey:@"userBackgroundColor"];
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if ( succeeded) {
            [[UserPreference sharedUserPreference] setUserBackgroundColor:backgroundColor];
            [[UserPreference sharedUserPreference] storeUserPreferenceInUserDefaults];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Change Background Color" object:nil];
            [Utils hideProcessingOperation];
            [Utils showSuccessOperationWithTitle:@"修改成功!" inSeconds:2 followedByOperation:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {

            [Utils showFailOperationWithTitle:@"修改失败!\n请检查网络设置." inSeconds:2 followedByOperation:nil];
        }
    }];
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
