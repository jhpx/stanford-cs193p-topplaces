//
//  PlacePhotosTVC.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-26.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "PlacePhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface PlacePhotosTVC ()

@end

@implementation PlacePhotosTVC

// 在setItems时，将places按照国家分组，索引表保存至self.placesByCountry
-(void)setItemsHook:(NSArray*)items
{
    [self.activityIndicator stopAnimating];
}


// 按行进行segue，异步获取Flickr上某一photo的实际image
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Photo"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    [segue.destinationViewController updateByMethod:^{return [FlickrFetcher urlForPhoto:self.items[indexPath.row] format:FlickrPhotoFormatLarge];} callback:@selector(setImageURL:)];
                    [segue.destinationViewController setTitle:[self titleForIndexPath:indexPath]];
                }
            }
        }
    }
}

// 与按行segue同时执行，刷新并保存最新访问photos列表
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* placePhoto = self.items[indexPath.row];
    NSMutableArray *newRecentPhotos = [NSMutableArray arrayWithObjects: placePhoto, nil];
    
    for (id photo in [defaults objectForKey:RECENT_PHOTOS_KEY]) {
        if ([photo isKindOfClass:[NSDictionary class]] && ![photo[FLICKR_PHOTO_ID] isEqualToString:placePhoto[FLICKR_PHOTO_ID]]) {
            [newRecentPhotos addObject:photo];
        }
    }
    [defaults setObject:newRecentPhotos forKey:RECENT_PHOTOS_KEY];
    [defaults synchronize];
}


#pragma mark - DataRepresent

- (NSString *)titleForIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *photo = self.items[indexPath.row];
    NSString *result = photo[FLICKR_PHOTO_TITLE];
    if (![result length]) {
        result = photo[FLICKR_PHOTO_DESCRIPTION];
    }
    if (![result length]) {
        result = @"Unknown";
    }
    return result;
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
