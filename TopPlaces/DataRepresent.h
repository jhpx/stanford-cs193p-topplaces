//
//  DataRepresent.h
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-27.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol DataRepresent <NSObject>
@required
- (NSString *)titleForItem:(NSDictionary*)item;
- (NSString *)subtitleForItem:(NSDictionary*)item;
- (NSString *)cellIdentifier;
- (NSDictionary *)itemByIndexPath:(NSIndexPath*)indexPath;
@optional
- (CLLocationCoordinate2D)coordinateForItem:(NSDictionary*)item;
- (UIImage*)thumbImageForItem:(NSDictionary*)item;
@end
