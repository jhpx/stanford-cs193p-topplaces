//
//  TopPlacesTVC.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-27.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "FlickrFetcher.h"
#import "PlacePhotosTVC.h"

@interface TopPlacesTVC ()

@property (nonatomic, strong) NSDictionary *placesByCountry;
@end

@implementation TopPlacesTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.items = [FlickrFetcher topPlaces];
    for (NSDictionary *p in self.items)
    {
        NSLog(@"%@",p);
    }
}

-(void)setItemsHook:(NSArray*)items
{
    [self updatePlacesByCountry];
}

- (void)updatePlacesByCountry
{
    NSMutableDictionary *placesByCountry = [NSMutableDictionary dictionary];
    for (NSDictionary *place in self.items) {
        NSString *country = [[place[FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];
        NSMutableArray *places = placesByCountry[country];
        if (!places) {
            places = [NSMutableArray array];
            placesByCountry[country] = places;
        }
        [places addObject:place];
    }
    self.placesByCountry = placesByCountry;
}

- (NSDictionary *)placeByIndexPath:(NSIndexPath*)indexPath
{
    NSString *country = [self countryForSection:indexPath.section];
    NSArray *placesByCountry = (self.placesByCountry)[country];
    return placesByCountry[indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"List Place Photos"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setItems:)]) {
                    NSDictionary *place = [self placeByIndexPath:indexPath];
                    NSArray* photos = [FlickrFetcher photosInPlace:place maxResults:20];
                    [segue.destinationViewController setItems:photos];
                    [segue.destinationViewController setTitle:place[FLICKR_PLACE_WOE]];
                }
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSString *)countryForSection:(NSInteger)section
{
    return [self.placesByCountry allKeys][section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self countryForSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.placesByCountry count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *country = [self countryForSection:section];
    NSArray *placesByCountry = (self.placesByCountry)[country];
    return [placesByCountry count];
}


#pragma mark - DataRepresent

- (NSString *)titleForIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *place = [self placeByIndexPath:indexPath];
    return place[FLICKR_PLACE_WOE];
}

- (NSString *)subtitleForIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *place = [self placeByIndexPath:indexPath];
    return [place[FLICKR_PLACE_NAME] substringFromIndex:[place[FLICKR_PLACE_WOE] length]+1];
}

- (NSString *)cellIdentifier
{
    return @"Flickr Top Places";
}


@end
