//
//  ChannelCreateViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/29.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "ChannelCreateViewController.h"
#import "MSDTextView.h"
#import "Universal.h"
#import "Utils.h"
#import <AVOSCloud/AVOSCloud.h>
#import <FlatUIKit/FlatUIKit.h>

@interface ChannelCreateViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) FUITextField  *channelTitle;
@property (strong, nonatomic) MSDTextView   *channelDescription;
@property (strong, nonatomic) UIImageView   *channelBackgroundImage;
@property (strong, nonatomic) UILabel       *channelTitleLabel;
@property (strong, nonatomic) UILabel       *channelDescriptionLabel;
@property (strong, nonatomic) FUIButton     *uploadButton;
@property (strong, nonatomic) FUIButton     *removeButton;
@property (strong, nonatomic) UILabel       *imageLabel;

@property (strong, nonatomic) UIImagePickerController   *imagePicker;

@end

@implementation ChannelCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set view background
    [self.view setBackgroundColor:[UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1]];
    
    //set tint color
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor cloudsColor]};
    
    //set navigation item title
    self.navigationItem.title = @"创建逼格夹";
    
    //initialize imagepicker
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.allowsEditing = YES;
    _imagePicker.navigationBar.tintColor = [UIColor cloudsColor];
    _imagePicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor cloudsColor]};
    [_imagePicker.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    
    //create channel title textfield
    _channelTitle = [[FUITextField alloc] initWithFrame:CGRectMake(0, 240, SCREEN_WIDTH, 40)];
    [Utils configureFUITextField:_channelTitle withPlaceHolder:@"逼格夹名称" andIndent:NO];
    _channelTitle.delegate = self;
    [self.view addSubview:_channelTitle];
    
    //create channel description textview
    _channelDescription = [[MSDTextView alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 120)];
    _channelDescription.delegate = self;
    _channelDescription.placeHolder = @"逼格夹描述";
    [self.view addSubview:_channelDescription];
    
    //create channel background image upload widget
    _channelBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 140)];
    _channelBackgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    _channelBackgroundImage.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_channelBackgroundImage];
    
    _imageLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, 140, 160, 20)];
    _imageLabel.font = [UIFont systemFontOfSize:16];
    _imageLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
    _imageLabel.textAlignment = NSTextAlignmentCenter;
    _imageLabel.text = @"逼格夹背景图片";
    [self.view addSubview:_imageLabel];
    
    _channelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH-70, 30)];
    _channelTitleLabel.font = [UIFont boldFlatFontOfSize:25];
    _channelTitleLabel.textColor = [UIColor cloudsColor];
    [_channelBackgroundImage addSubview:_channelTitleLabel];
    
    _channelDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake( SCREEN_WIDTH-245, 40, 240, 90)];
    _channelDescriptionLabel.font = [UIFont systemFontOfSize:15];
    _channelDescriptionLabel.textColor = [UIColor cloudsColor];
    _channelDescriptionLabel.numberOfLines = 5;
    _channelDescriptionLabel.textAlignment = NSTextAlignmentRight;
    [_channelBackgroundImage addSubview:_channelDescriptionLabel];
    
    _uploadButton = [[FUIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 85, 20, 20)];
    [Utils configureFUIButton:_uploadButton withTitle:@"+" target:self andAction:@selector(pickChannelBackgroundImage)];
    [self.view addSubview:_uploadButton];
    
    _removeButton = [[FUIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 85, 20, 20)];
    [Utils configureFUIButton:_removeButton withTitle:@"-" target:self andAction:@selector(removeBackgroundImage)];
    [self.view addSubview:_removeButton];
    _removeButton.hidden = YES;
    
    //create 'create' button
    UIBarButtonItem *createChannelButton = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStylePlain target:self action:@selector(createChannel)];
    [self.navigationItem setRightBarButtonItem:createChannelButton];
    
}

- (void)createChannel {
    
    if ( [Utils isEmptyTextField:_channelTitle]) {
        [Utils showFlatAlertView:@"提示" andMessage:@"逼格夹名称不能为空!"];
        return ;
    }
    
    [Utils showProcessingOperation];
    if ( _channelBackgroundImage.image) {
        NSData *backgroundImageData = UIImagePNGRepresentation(_channelBackgroundImage.image);
        AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"channelbackground_%@.png", _channelTitle.text] data:backgroundImageData];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if ( succeeded) {
                AVObject *channelObj = [AVObject objectWithClassName:@"Channel"];
                [channelObj setObject:_channelTitle.text forKey:@"channelTitle"];
                [channelObj setObject:_channelDescription.text forKey:@"channelDescription"];
                [channelObj setObject:file.url forKey:@"channelBackgroundImageURL"];
                [channelObj setObject:[AVUser currentUser] forKey:@"channelCreater"];
                [channelObj save];
                
                [Utils hideProcessingOperation];
                [Utils showSuccessOperationWithTitle:@"逼格夹创建成功!" inSeconds:2 followedByOperation:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [Utils hideProcessingOperation];
                [Utils showFlatAlertView:@"错误" andMessage:@"创建逼格夹失败!\n请检查网络设置"];
            }
        }];
    } else {
        AVObject *channelObj = [AVObject objectWithClassName:@"Channel"];
        [channelObj setObject:_channelTitle.text forKey:@"channelTitle"];
        [channelObj setObject:_channelDescription.text forKey:@"channelDescription"];
        [channelObj setObject:nil forKey:@"channelBackgroundImageURL"];
        [channelObj setObject:[AVUser currentUser] forKey:@"channelCreater"];
        [channelObj save];
        
        [Utils hideProcessingOperation];
        [Utils showSuccessOperationWithTitle:@"逼格夹创建成功!" inSeconds:2 followedByOperation:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    
    
}

- (void)pickChannelBackgroundImage {
    
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)removeBackgroundImage {
    
    _channelBackgroundImage.image = nil;
    _imageLabel.hidden = NO;
    _removeButton.hidden = YES;
}

#pragma mark - ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ( !image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    NSLog(@"image size : %f, %f", image.size.width, image.size.height);
    CGRect rect;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    CGFloat ratio = SCREEN_WIDTH/140;
    if ( w*1.0/h > ratio) {
        rect = CGRectMake((w-h*ratio)/2, 0, h*ratio, h);
    } else {
        rect = CGRectMake(0, (h-w/ratio)/2, w, w/ratio);
    }
    NSLog(@"rect : %f, %f, %f, %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    UIImage *clipedImage = [Utils clipImage:image inRect:rect];
    _channelBackgroundImage.image = clipedImage;
    _removeButton.hidden = NO;
    _imageLabel.hidden = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"location:%ld, length:%ld", range.location, range.length);
    NSLog(@"string:%@", string);
    
    _channelTitleLabel.text = [_channelTitle.text stringByReplacingCharactersInRange:range withString:string];
    
    if ( range.location == 0 && [string isEqualToString:@""]) {
        //this is a delete action
        
    } else if ( range.length == 0 && string.length == 1) {
        //this is a single letter typing action
        
    } else if ( range.location == 0 && string.length == range.length) {
        //this is an auto-typing action
        
    }
    
    if ( [string isEqualToString:@"\n"]) {
        return NO;
    } else {
//        _channelTitleLabel.text = [textField.text stringByAppendingString:string];
    }
    return YES;
}

#pragma mark - textView delegate

- (void)textViewDidChange:(UITextView *)textView {
    
    if ( [textView isKindOfClass:[MSDTextView class]]) {
        [(MSDTextView *)textView textViewDidChange:textView];
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ( [@"\n" isEqualToString:text]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        _channelDescriptionLabel.text = [_channelDescription.text stringByReplacingCharactersInRange:range withString:text];
        return YES;
    }
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
