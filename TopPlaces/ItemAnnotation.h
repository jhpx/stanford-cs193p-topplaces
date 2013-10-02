//
//  ItemAnnotation.h
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-28.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "DataRepresent.h"

@interface ItemAnnotation : NSObject <MKAnnotation>

+ (ItemAnnotation *)annotationForItem:(NSDictionary *)item;

@property (nonatomic, strong) NSDictionary *item;
@property (nonatomic, strong) id<DataRepresent> delegate;

@end
