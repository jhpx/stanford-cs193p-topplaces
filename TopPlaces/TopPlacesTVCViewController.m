//
//  TopPlacesTVCViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-27.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "TopPlacesTVCViewController.h"
#import "FlickrFetcher.h"
#import "PlacePhotosViewController.h"

@interface TopPlacesTVCViewController ()

@end

@implementation TopPlacesTVCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.items = [FlickrFetcher topPlaces];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"List Place Photos"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setItems:)]) {
                    NSDictionary *place = (self.items)[indexPath.row];
                    NSArray* photos = [FlickrFetcher photosInPlace:place maxResults:20];
                    [segue.destinationViewController setItems:photos];
                    [segue.destinationViewController setTitle:place[FLICKR_PLACE_WOE]];
                }
            }
        }
    }
}



- (NSString *)titleForIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *place = self.items[indexPath.row];
    return place[FLICKR_PLACE_WOE];
}

- (NSString *)subtitleForIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *place = self.items[indexPath.row];
    return [place[FLICKR_PLACE_NAME] substringFromIndex:[[self titleForIndexPath:indexPath] length]+1];
}

- (NSString *)cellIdentifier
{
    return @"Flickr Top Places";
}

@end
