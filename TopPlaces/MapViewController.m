//
//  MapViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-28.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "MapViewController.h"
#import "DataUtils.h"
#import "ItemAnnotation.h"
#import "FlickrFetcher.h"
#import "FlickrPlacePhotosTVC.h"
#import "FlickrTopPlacesTVC.h"

@interface MapViewController() <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;


@end

@implementation MapViewController

#pragma mark - Suegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Map Annotation segue
    if ([sender isKindOfClass:[ItemAnnotation class]]) {
        // 从Photos Map进行segue，异步获取Flickr上某一photo的实际image
        if ([segue.identifier isEqualToString:@"Show Photo"]) {
            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                NSDictionary* photo = [(ItemAnnotation*)sender item];
                [segue.destinationViewController setTitle:[sender title]];
                [DataUtils updateByMethod:^{return [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];} target:segue.destinationViewController callback:@selector(setImageURL:)];
            }
        }
        // 从Places Map进行segue，异步获取Flickr上某一place的photos
        else if ([segue.identifier isEqualToString:@"List Place Photos"]) {
            if ([segue.destinationViewController respondsToSelector:@selector(setItems:)]) {
                NSDictionary *place = [(ItemAnnotation*)sender item];
                [DataUtils updateByMethod:^(){return [FlickrFetcher photosInPlace:place maxResults:50];} target:segue.destinationViewController callback:@selector(setItems:)];
                [segue.destinationViewController setTitle:place[FLICKR_PLACE_WOE]];
            }
        }
    }
    
}

#pragma mark - Synchronize Model and View

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.navItem.title = title;
}

- (void)updateMapView
{
    if (!self.mapView.delegate) self.mapView.delegate = self;
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) {
        [self.mapView addAnnotations:self.annotations];
        [DataUtils zoomMapViewToFitAnnotations:self.mapView animated:YES];
    }
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    [DataUtils updateByMethod:^(){return [self.delegate mapViewController:self imageForAnnotation:aView.annotation];} target:(UIImageView *)aView.leftCalloutAccessoryView callback:@selector(setImage:)];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([self.delegate respondsToSelector:@selector(annotationSegueIdentifier)]) {
        NSString *segueIdentifier = [self.delegate performSelector:@selector(annotationSegueIdentifier)];
        //        //iPad使用delegate进行segue跳转
        //        if (![UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [(UIViewController*)self.delegate performSegueWithIdentifier:segueIdentifier sender:view.annotation];
        //        }
        //        //iphone使用self进行segue跳转
        //        else {
        //            [self performSegueWithIdentifier:segueIdentifier sender:view.annotation];
        //        }
    }
    else {
        NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
    }
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - SplitViewBarButtonItemPresenter

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    self.navItem.leftBarButtonItem = splitViewBarButtonItem;
}

- (UIBarButtonItem *)splitViewBarButtonItem
{
    return self.navItem.leftBarButtonItem;
}
@end
