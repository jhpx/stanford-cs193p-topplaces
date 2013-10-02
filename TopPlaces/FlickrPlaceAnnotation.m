//
//  FlickrPlaceAnnotation.m
//  Shutterbug
//
//  Created by 姜孟冯 on 13-9-28.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "FlickrPlaceAnnotation.h"
#import "FlickrFetcher.h"

@implementation FlickrPlaceAnnotation

+ (FlickrPlaceAnnotation *)annotationForPhoto:(NSDictionary *)place
{
    FlickrPlaceAnnotation *annotation = [[FlickrPlaceAnnotation alloc] init];
    annotation.place = place;
    return annotation;
}

#pragma mark - MKAnnotation

- (NSString *)title
{
    return (self.place)[FLICKR_PLACE_WOE];
}

- (NSString *)subtitle
{
    return [self.place valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [(self.place)[FLICKR_LATITUDE] doubleValue];
    coordinate.longitude = [(self.place)[FLICKR_LONGITUDE] doubleValue];
    return coordinate;
}

@end

