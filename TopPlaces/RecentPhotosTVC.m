//
//  RecentPhotosTVC.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-27.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "RecentPhotosTVC.h"

@interface RecentPhotosTVC ()
@end

@implementation RecentPhotosTVC

// getItems时，默认载入NSUserDefaults的数据
-(NSArray *)items
{
    NSArray *recent = [super items];
    if (!recent) {
        recent = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTOS_KEY];
    }
    return recent;
}

// setItems时，同步保存新的items至NSUserDefaults
-(void)setItemsHook:(NSArray*)items
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:items forKey:RECENT_PHOTOS_KEY];
    [defaults synchronize];
}

// view出现前刷新
- (void)viewWillAppear:(BOOL)animated
{
    [self.activityIndicator stopAnimating];
	[self.tableView reloadData];
}


#pragma mark - UITableViewDelegate

// 实现最近访问photo列表的删除功能
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray * items = [self.items mutableCopy];
        [items removeObject:(self.items)[indexPath.row]];
        self.items = items;
    }
}

@end
