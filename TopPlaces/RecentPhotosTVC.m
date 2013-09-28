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


-(NSArray *)items
{
    NSArray *recent = [super items];
    if (!recent) {
        recent = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTOS_KEY];
    }
    return recent;
}

-(void)setItemsHook:(NSArray*)items
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:items forKey:RECENT_PHOTOS_KEY];
    [defaults synchronize];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tableView reloadData];
}


// simply deletion

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray * items = [self.items mutableCopy];
        [items removeObject:(self.items)[indexPath.row]];
        self.items = items;
    }
}

@end
