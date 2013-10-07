//
//  ImageViewController.h
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-27.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface ImageViewController : UIViewController <SplitViewBarButtonItemPresenter>
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;
@end
