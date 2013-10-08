//
//  ImageViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-27.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "ImageViewController.h"
#import "DataUtils.h"

@interface ImageViewController ()<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ImageViewController

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
}


// 当setImageURL时刷新图片,activityIndicator开始转动
- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self.activityIndicator startAnimating];
    [DataUtils updateByMethod:^{return [self reloadImage];} target:self callback:@selector(resetScrollAndImageView:)];
}

// 按照imageURL刷新图片，重方法，需异步调用
- (UIImage*)reloadImage
{
    NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
    NSLog(@"Fetching image from internet...");
    return [UIImage imageWithData:imageData];
}


// 重置scrollView的contentSize与zoomScale，停转activityIndicator
- (void)resetScrollAndImageView:(UIImage*)image
{
    self.scrollView.zoomScale = 1.0;
    if(self.imageView.image != image)
    {self.imageView.image = image;
        if (image) {
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            self.scrollView.contentSize = image.size;
        }
        else {
            self.imageView.frame = CGRectZero;
            self.scrollView.contentSize = CGSizeZero;
        }
    }
    [self.activityIndicator stopAnimating];
}

// 载入页面后，重设定scrollView的最大最小Scale以及delegate
// 之后，重新刷新图片
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetScrollAndImageView:self.imageView.image];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - SplitViewBarButtonItemPresenter

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.navigationItem.leftBarButtonItems
 mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.navigationItem.leftBarButtonItems = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}
@end