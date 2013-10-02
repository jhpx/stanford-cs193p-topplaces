//
//  ItemAnnotation.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-28.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "ItemAnnotation.h"

@implementation ItemAnnotation

+ (ItemAnnotation *)annotationForItem:(NSDictionary *)item
{
    ItemAnnotation *annotation = [[ItemAnnotation alloc] init];
    annotation.item = item;
    return annotation;
}

#pragma mark - MKAnnotation

- (NSString *)title
{
    return [self.delegate titleForItem:self.item];
}

- (NSString *)subtitle
{
    return [self.delegate subtitleForItem:self.item];
}

- (CLLocationCoordinate2D)coordinate
{
    return [self.delegate coordinateForItem:self.item];
}

@end

