//
//  PlacePhotosViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-26.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "PlacePhotosViewController.h"
#import "FlickrFetcher.h"

@interface PlacePhotosViewController ()

@end

@implementation PlacePhotosViewController

- (void) setItems:(NSArray *)items
{
    [super setItems:items];
    for ( id p in self.items){
        if ([p isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@",p);
        }
        
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"List Place Photos"]) {
//                NSDictionary *place = (self.items)[indexPath.row];
//                NSArray* photos = [FlickrFetcher photosInPlace:place maxResults:20];
//                [segue.destinationViewController setPhotos:photos];
            }
        }
    }
}


- (NSString *)titleForIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *photo = self.items[indexPath.row];
    return photo[FLICKR_PHOTO_TITLE];
}

- (NSString *)subtitleForIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *photo = self.items[indexPath.row];
    return photo[FLICKR_PHOTO_DESCRIPTION];
}

- (NSString *)cellIdentifier
{
    return @"Flickr Photos";
}

@end
