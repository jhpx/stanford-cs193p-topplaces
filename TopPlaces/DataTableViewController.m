//
//  DataTableViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-24.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "DataTableViewController.h"
#import "MapViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface DataTableViewController () <MapViewControllerDelegate,UISplitViewControllerDelegate>
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
// setItems完成后，停转activityIndicator，刷新splitViewDetail
- (void)setItems:(NSArray *)items
{
//    if(_items!=items)
//    {
        _items = items;
        if ([self respondsToSelector:@selector(setItemsHook:)]){
            [self performSelector:@selector(setItemsHook:) withObject:items];
        }
        
        [self.activityIndicator stopAnimating];
        
        [self updateDestinationViewController:[self.splitViewController.viewControllers lastObject]]; //for ipad
        [self.tableView reloadData];
//    }
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
    [super awakeFromNib];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

// 调用了四个指定方法，均在DataRepresent.h协议中给出，子类必须实现此协议。
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

#pragma mark - open methods

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

- (void)updateDestinationViewController:(UIViewController*)controller
{
    if ([controller isKindOfClass:[MapViewController class]]) {
        MapViewController *mapVC = (MapViewController *)controller;
        mapVC.delegate = self;
        mapVC.annotations = [self mapAnnotations];
        if (self.title) {
            mapVC.title = [self.title stringByAppendingString:@" Map"];
        }
        else {
            mapVC.title = @"Map";
        }
        mapVC.splitViewController.delegate = self;
    }
}

#pragma mark - UISplitViewControllerDelegate

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if ([detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        return detailVC;
    }
    else {
        return nil;
    }
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.navigationItem.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

//- (void) setSplitViewControllerDelegate
//{
//    if(!self.splitViewController.delegate)self.splitViewController.delegate = self;
//}

@end
