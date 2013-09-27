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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Photo"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL)]) {
                    
                    NSDictionary* placePhoto = self.items[indexPath.row];
                    NSURL *url = [FlickrFetcher urlForPhoto:placePhoto format:FlickrPhotoFormatLarge];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForIndexPath:indexPath]];
                    
                    
                    // syncrosize
                    
                    
//                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                    
//                    NSArray* defaultRecentPhotos = [defaults objectForKey:RECENT_PHOTOS_KEY];
//                    NSMutableArray *newRecentPhotos = [[NSMutableArray alloc]initWithObjects: placePhoto, nil];
//                    
//                    
//                    for (id photo in defaultRecentPhotos) {
//                        if ([photo isKindOfClass:[NSDictionary class]] && ![photo[FLICKR_PHOTO_ID] isEqualToString:placePhoto[FLICKR_PHOTO_ID]]) {
//                            [newRecentPhotos addObject:photo];
//                        }
//                    }
//                    [defaults setObject:newRecentPhotos forKey:RECENT_PHOTOS_KEY];
//                    [defaults synchronize];
                    
                }
                
            }
        }
    }
}


- (NSString *)titleForIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *photo = self.items[indexPath.row];
    NSString *result = photo[FLICKR_PHOTO_TITLE];
    if (!result) {
        result = photo[FLICKR_PHOTO_DESCRIPTION];
    }else if (!result) {
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
