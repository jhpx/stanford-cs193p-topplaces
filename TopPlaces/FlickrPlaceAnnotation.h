//
//  FlickrPlaceAnnotation.h
//  Shutterbug
//
//  Created by 姜孟冯 on 13-9-28.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrPlaceAnnotation : NSObject <MKAnnotation>

+ (FlickrPlaceAnnotation *)annotationForPlace:(NSDictionary *)place; // Flickr place dictionary

@property (nonatomic, strong) NSDictionary *place;

@end
