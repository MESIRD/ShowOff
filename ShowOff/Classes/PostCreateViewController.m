//
//  PostCreateViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/29.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "PostCreateViewController.h"
#import "Universal.h"
#import "Utils.h"
#import <AVOSCloud/AVOSCloud.h>

@interface PostCreateViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSInteger currentTappedImageViewIndex;
    NSInteger currentImageViewNumber;
    NSInteger currentImageNumber;
    NSInteger currentUploadedImageNumber;
}

@property (strong, nonatomic) UIImagePickerController   *imagePicker;
@property (strong, nonatomic) NSMutableArray            *imageURLs;

@end

@implementation PostCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"发布状态";
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor cloudsColor]}];
    
    //initialize image picker
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.allowsEditing = YES;
    _imagePicker.navigationBar.tintColor = [UIColor cloudsColor];
    _imagePicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor cloudsColor]};
    [_imagePicker.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    
    _postTextView.placeHolder = @"说点什么...";
    _postTextView.delegate = self;

    for (FUIButton *button in _removeButtons) {
        [Utils configureFUIButton:button withTitle:@"-" target:self andAction:@selector(removeImage:)];
        button.hidden = YES;
    }
    
    for (UIImageView *imageView in _postImageViews) {
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickImageFromAlbum:)];
        [imageView addGestureRecognizer:tapRecognizer];
    }
    [_postImageViews[1] setHidden:YES];
    [_postImageViews[2] setHidden:YES];
    
    [_addImageSigns[1] setHidden:YES];
    [_addImageSigns[2] setHidden:YES];
    
    UIBarButtonItem *publishBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishPost)];
    [self.navigationItem setRightBarButtonItem:publishBarButtonItem];
    
    _imageURLs = [[NSMutableArray alloc] init];
    
    currentImageViewNumber = 1;
    currentTappedImageViewIndex = -1;
    currentImageNumber = 0;
    currentUploadedImageNumber = 0;
}

- (void)finishUploadingImage:(NSString *)imageURL {
    
    if ( currentUploadedImageNumber == currentImageNumber) {
        //the last image has been uploaded
        if ( imageURL) {
            [_imageURLs addObject:imageURL];
        }
        
        AVQuery *query = [AVQuery queryWithClassName:@"Channel"];
        [query whereKey:@"objectId" equalTo:@"5590fe3be4b00777039b5110"];
        AVObject *channelObj = [query getFirstObject];
        AVObject *postObj = [AVObject objectWithClassName:@"Post"];
        [postObj setObject:channelObj forKey:@"belongedChannel"];
        [postObj setObject:_postTextView.text forKey:@"postText"];
        [postObj setObject:_imageURLs forKey:@"postImageURLs"];
        [postObj setObject:[AVUser currentUser] forKey:@"postCreater"];
        [postObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if ( succeeded) {
                [Utils hideProcessingOperation];
                [Utils showSuccessOperationWithTitle:@"发布成功!" inSeconds:2 followedByOperation:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Publish Successfully To States" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            } else {
                [Utils hideProcessingOperation];
                [Utils showFlatAlertView:@"警告" andMessage:@"发布状态失败!\n请检查网络设置"];
            }
        }];
    } else {
        //upload one image
        [_imageURLs addObject:imageURL];
    }
}

- (void)publishPost {
    
    if ( [Utils isEmptyTextView:_postTextView]) {
        [Utils showFlatAlertView:@"提示" andMessage:@"发布内容不能为空!"];
        return ;
    }
    
    [Utils showProcessingOperation];
    
    NSDate *now = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy_mm_dd_HH_MM_SS"];
    
    if ( currentImageNumber == 0) {
        [self finishUploadingImage:nil];
    } else {
        if ( ((UIImageView *)_postImageViews[0]).image != nil) {
            AVFile *imageFile = [AVFile fileWithName:[NSString stringWithFormat:@"post_%@_%@_first", [[AVUser currentUser] username], [formatter stringFromDate:now]] data:UIImagePNGRepresentation(((UIImageView *)_postImageViews[0]).image)];
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ( succeeded) {
                    currentUploadedImageNumber ++;
                    [self finishUploadingImage:imageFile.url];
                } else {
                    [Utils showFlatAlertView:@"警告" andMessage:@"上传图片错误!\n请检查网络设置"];
                }
            }];
        }
        
        if ( ((UIImageView *)_postImageViews[1]).image != nil) {
            AVFile *imageFile = [AVFile fileWithName:[NSString stringWithFormat:@"post_%@_%@_second", [[AVUser currentUser] username], [formatter stringFromDate:now]] data:UIImagePNGRepresentation(((UIImageView *)_postImageViews[1]).image)];
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ( succeeded) {
                    currentUploadedImageNumber ++;
                    [self finishUploadingImage:imageFile.url];
                } else {
                    [Utils showFlatAlertView:@"警告" andMessage:@"上传图片错误!\n请检查网络设置"];
                }
            }];
        }
        
        if ( ((UIImageView *)_postImageViews[2]).image != nil) {
            AVFile *imageFile = [AVFile fileWithName:[NSString stringWithFormat:@"post_%@_%@_third", [[AVUser currentUser] username], [formatter stringFromDate:now]] data:UIImagePNGRepresentation(((UIImageView *)_postImageViews[2]).image)];
            [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if ( succeeded) {
                    currentUploadedImageNumber ++;
                    [self finishUploadingImage:imageFile.url];
                } else {
                    [Utils showFlatAlertView:@"警告" andMessage:@"上传图片错误!\n请检查网络设置"];
                }
            }];
        }
    }
    
    
}

- (void)pickImageFromAlbum:(UITapGestureRecognizer *)sender {
    
    NSInteger index = [_postImageViews indexOfObject:sender.view];
    currentTappedImageViewIndex = index;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)removeImage:(FUIButton *)sender {
    
    NSInteger index = [_removeButtons indexOfObject:sender];
    for ( NSInteger i = index; i < currentImageViewNumber; i ++) {
        if ( i == currentImageViewNumber-1) {
            if ( ((UIImageView *)_postImageViews[i]).image == nil) {
                [_postImageViews[i] setHidden:YES];
                [_addImageSigns[i] setHidden:YES];
            } else {
                [_addImageSigns[i] setHidden:NO];
                [_removeButtons[i] setHidden:YES];
                ((UIImageView *)_postImageViews[i]).image = nil;
            }
        } else {
            if ( ((UIImageView *)_postImageViews[i+1]).image == nil) {
                ((UIImageView *)_postImageViews[i]).image = nil;
                [_addImageSigns[i] setHidden:NO];
                [_removeButtons[i] setHidden:YES];
            } else {
                ((UIImageView *)_postImageViews[i]).image = [((UIImageView *)_postImageViews[i+1]).image copy];
            }
        }
    }
    currentImageViewNumber --;
    currentImageNumber --;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ( [navigationController isKindOfClass:[UIImagePickerController class]] &&
        ( (UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerViewController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if ( currentTappedImageViewIndex == -1) {
        return ;
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ( !image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    CGRect rect;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    CGFloat ratio = 0.7;
    if ( w*1.0/h > ratio) {
        rect = CGRectMake((w-h*ratio)/2, 0, h*ratio, h);
    } else {
        rect = CGRectMake(0, (h-w/ratio)/2, w, w/ratio);
    }
    UIImage *clippedImage = [Utils clipImage:image inRect:rect];
    ((UIImageView *)_postImageViews[currentTappedImageViewIndex]).image = clippedImage;
    [_addImageSigns[currentTappedImageViewIndex] setHidden:YES];
    [_removeButtons[currentTappedImageViewIndex] setHidden:NO];
    
    if ( currentTappedImageViewIndex != 2) {
        [_postImageViews[currentTappedImageViewIndex+1] setHidden:NO];
        [_addImageSigns[currentTappedImageViewIndex+1] setHidden:NO];
    }
    
    if ( currentImageViewNumber != 3) {
        currentImageViewNumber ++;
    }
    currentTappedImageViewIndex = -1;
    currentImageNumber ++;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    currentTappedImageViewIndex = -1;
}

#pragma mark - TextView delegate

- (void)textViewDidChange:(UITextView *)textView {
    
    if ( [textView isKindOfClass:[MSDTextView class]]) {
        [(MSDTextView *)textView textViewDidChange:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return [(MSDTextView *)textView textView:textView shouldChangeTextInRange:range replacementText:text];
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
