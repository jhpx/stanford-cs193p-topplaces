//
//  ImageViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-27.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ImageViewController

// 当setImageURL时刷新图片
- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self.activityIndicator startAnimating];
    [self updateByMethod:^{return [self reloadImage];} callback:@selector(resetScrollAndImageView:)];
}

- (UIImage*)reloadImage
{
    NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
    NSLog(@"Fetching image from internet...");
    return [UIImage imageWithData:imageData];
}


// 按照imageURL刷新图片，重置scrollView的contentSize与zoomScale
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

// 异步刷新数据，以任意block方式在后台线程刷新，刷新完成后回主线程调用target的callback方法
- (void) updateByMethod:(id(^)())updateMethod callback:(SEL)callback;
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
        id something = updateMethod();
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self respondsToSelector:callback]) {
                _Pragma("clang diagnostic push") \
                _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
                [self performSelector:callback withObject:something];
                _Pragma("clang diagnostic pop") \
            }
        });
    });
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end