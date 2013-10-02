//
//  DataTableViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-24.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "DataTableViewController.h"
#import "MapViewController.h"
#import "ItemAnnotation.h"

@interface DataTableViewController () <MapViewControllerDelegate>
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
// items载入完成，停转activityIndicator,刷新splitViewDetail

- (void)setItems:(NSArray *)items
{
    if(_items!=items)
    {
        _items = items;
        if ([self respondsToSelector:@selector(setItemsHook:)]){
            [self performSelector:@selector(setItemsHook:) withObject:items];
        }

        for (NSDictionary *p in _items)
        {
            NSLog(@"%@",p);
        }
        [self updateSplitViewDetail];
        [self.activityIndicator stopAnimating];
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

// 异步刷新数据，以任意block方式在后台线程刷新，刷新完成后回主线程调用target的callback方法
- (void) updateByMethod:(id(^)())updateMethod callback:(SEL)callback;
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
//        id something = [NSArray arrayWithObject:updateMethod()[0]];
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

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.items count]];
    for (NSDictionary *item in self.items) {
        ItemAnnotation *ia = [ItemAnnotation annotationForItem:item];
        ia.delegate = self;
        [annotations addObject:ia];
    }
    return annotations;
}

- (void)updateSplitViewDetail
{
    id detail = [self.splitViewController.viewControllers lastObject];
    if ([detail isKindOfClass:[MapViewController class]]) {
        MapViewController *mapVC = (MapViewController *)detail;
        mapVC.delegate = self;
        mapVC.annotations = [self mapAnnotations];
    }
}

#pragma mark - MapViewControllerDelegate

// 调用了一个指定方法，均在DataRepresent.h协议中给出，子类须实现此协议。
//- (UIImage*)thumbImageForItem:(NSDictionary*)item;
- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    ItemAnnotation *ia = (ItemAnnotation *)annotation;
    if([self respondsToSelector:@selector(thumbImageForItem:)]) {
        return [self performSelector:@selector(thumbImageForItem:) withObject:ia.item];
    }
    else {
        return nil;
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
