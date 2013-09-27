//
//  DataRepresent.h
//  TopPlaces
//
//  Created by 姜孟冯 on 13-9-27.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataRepresent <NSObject>
- (NSString *)titleForIndexPath:(NSIndexPath*)indexPath;
- (NSString *)subtitleForIndexPath:(NSIndexPath*)indexPath;
- (NSString *)cellIdentifier;
@end
