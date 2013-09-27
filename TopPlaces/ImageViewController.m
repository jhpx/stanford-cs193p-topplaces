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
@end

@implementation ImageViewController

// resets the image whenever the URL changes

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

// fetches the data from the URL
// turns it into an image
// adjusts the scroll view's content size to fit the image
// sets the image as the image view's image

- (void)resetImage
{
    NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.imageView.image = image;
    self.scrollView.zoomScale = 1.0;
    
    if (image) {
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        self.scrollView.contentSize = image.size;
    }
    else {
        self.imageView.frame = CGRectZero;
        self.scrollView.contentSize = CGSizeZero;
    }
}

// returns the view which will be zoomed when the user pinches
// in this case, it is the image view, obviously
// (there are no other subviews of the scroll view in its content area)

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

// setup zooming by setting min and max zoom scale
//   and setting self to be the scroll view's delegate
// resets the image in case URL was set before outlets (e.g. scroll view) were set

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
}

@end