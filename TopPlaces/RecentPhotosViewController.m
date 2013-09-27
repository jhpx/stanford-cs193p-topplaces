//
//  RecentPhotosViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-27.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "RecentPhotosViewController.h"

@interface RecentPhotosViewController ()
@end

@implementation RecentPhotosViewController


-(NSArray *)items
{
    NSArray *recent = [super items];
    if (!recent) {
        recent = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTOS_KEY];
    }
    return recent;
}

-(void)setItems:(NSArray *)items
{
    //do nothing, can't change these items by a given array.
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tableView reloadData];
}

@end
