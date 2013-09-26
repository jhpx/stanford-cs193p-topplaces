//
//  TopPlacesViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-24.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrFetcher.h"

@interface TopPlacesViewController ()

@end

@implementation TopPlacesViewController

- (void)setPlaces:(NSArray *)places
{
    _places = places;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.places = [FlickrFetcher topPlaces];
    for ( id p in self.places){
        if ([p isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@",p);
        }
        
    }
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Get Place Photos"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
//                    NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
//                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
//                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Top Place";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *place = (self.places)[indexPath.row];
    NSString *place_title = place[FLICKR_PLACE_WOE];
    cell.textLabel.text = place_title;
    cell.detailTextLabel.text = [place[FLICKR_PLACE_NAME] substringFromIndex:[place_title length]+1];
    return cell;
}

#pragma mark - UITableViewDelegate


@end
