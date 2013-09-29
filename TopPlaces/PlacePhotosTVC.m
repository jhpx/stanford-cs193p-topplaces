//
//  PlacePhotosTVC.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-26.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "PlacePhotosTVC.h"
#import "FlickrFetcher.h"

@interface PlacePhotosTVC ()

@end

@implementation PlacePhotosTVC

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Photo"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    NSURL *url = [FlickrFetcher urlForPhoto:self.items[indexPath.row] format:FlickrPhotoFormatLarge];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForIndexPath:indexPath]];
                }
            }
        }
    }
}

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
    }else if (![result length]) {
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
