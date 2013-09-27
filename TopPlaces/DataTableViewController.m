//
//  DataTableViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-24.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "DataTableViewController.h"

@interface DataTableViewController ()
@end

@implementation DataTableViewController

- (void)setItems:(NSArray *)items
{
    if(_items!=items)
    {
        _items = items;
        if ([self respondsToSelector:@selector(setItemsHook)]){
            [self performSelector:@selector(setItemsHook)];
        }
        [self.tableView reloadData];
    }
}

- (void)awakeFromNib
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self performSelector:@selector(cellIdentifier) ];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self performSelector:@selector(titleForIndexPath:)  withObject:indexPath];
    cell.detailTextLabel.text = [self performSelector:@selector(subtitleForIndexPath:) withObject:indexPath];
    return cell;
}

@end
