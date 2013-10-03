//
//  DataTableViewController.h
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-24.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataRepresent.h"

@interface DataTableViewController : UITableViewController <DataRepresent>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic) UIActivityIndicatorView * activityIndicator;
- (void)updateByMethod:(id(^)())updateMethod callback:(SEL)callback;
- (void)updateMapViewController:(UIViewController*)controller;
@end
