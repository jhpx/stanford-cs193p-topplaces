//
//  DataTableViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-24.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "DataTableViewController.h"
#import "DataRepresent.h"

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
- (void)setItems:(NSArray *)items
{
    if(_items!=items)
    {
        _items = items;
        if ([self respondsToSelector:@selector(setItemsHook:)]){
            [self performSelector:@selector(setItemsHook:) withObject:items];
        }
        [self.tableView reloadData];
    }
}

// 载入页面后，异步获取Flickr上的topPlaces
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

@end
