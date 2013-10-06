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

// 延迟实例化activityIndicator，初始即开始转动
- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.color=[UIColor grayColor];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.center = CGPointMake(160, 240);
        [_activityIndicator startAnimating];
    }
    return _activityIndicator;
}

// 预留一个setItemsHook函数，供子类在reloadData前对数据进行Hook处理
// items载入完成，停转activityIndicator

- (void)setItems:(NSArray *)items
{
    if(_items!=items)
    {
        _items = items;
        if ([self respondsToSelector:@selector(setItemsHook:)]){
            [self performSelector:@selector(setItemsHook:) withObject:items];
        }
        
        //        for (NSDictionary *p in _items)
        //        {
        //            NSLog(@"%@",p);
        //        }
        
        [self.activityIndicator stopAnimating];
        [self.tableView reloadData];
    }
}

#pragma mark - View Controller Lifecycle

// 载入页面后，加载activityIndicator，开始旋转
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView addSubview:self.activityIndicator];
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

// 调用了三个指定方法，均在DataRepresent.h协议中给出，子类必须实现此协议。
//- (NSString *)titleForItem:(NSDictionary*)item;
//- (NSString *)subtitleForItem:(NSDictionary*)item;
//- (NSString *)cellIdentifier;
//- (NSDictionary *)itemByIndexPath:(NSIndexPath*)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self conformsToProtocol:@protocol(DataRepresent)]) {
        NSString *CellIdentifier = [self performSelector:@selector(cellIdentifier) ];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        NSDictionary *item = [self performSelector:@selector(itemByIndexPath:) withObject:indexPath];
        cell.textLabel.text = [self performSelector:@selector(titleForItem:)  withObject:item];
        cell.detailTextLabel.text = [self performSelector:@selector(subtitleForItem:) withObject:item];
        return cell;
    }
    else{
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@""];
    }
    
}
    
#pragma mark - DataRepresent
// 默认返回nil，子类必须覆盖

- (NSString *)titleForItem:(NSDictionary*)item
{
    return nil;
}

- (NSString *)subtitleForItem:(NSDictionary*)item
{
    return nil;
}

- (NSString *)cellIdentifier
{
    return nil;
}

- (NSDictionary *)itemByIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}
@end
