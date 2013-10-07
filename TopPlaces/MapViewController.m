//
//  MapViewController.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-28.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "MapViewController.h"
#import "DataUtils.h"

@interface MapViewController() <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;

@end

@implementation MapViewController

-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.titleBarButtonItem.title = title;
}



#pragma mark - Synchronize Model and View

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
    if ([self.delegate respondsToSelector:@selector(performAnnotationSegue:)]) {
        [self.navigationController popViewControllerAnimated:NO];
        [self.delegate performSelector:@selector(performAnnotationSegue:) withObject:view.annotation];
       
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
    [self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - SplitViewBarButtonItemPresenter

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}
@end
