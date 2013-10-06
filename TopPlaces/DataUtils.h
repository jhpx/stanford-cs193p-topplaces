//
//  DataUtils.h
//  TopPlaces
//
//  Created by 姜孟冯 on 13-10-6.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtils : NSObject
+ (void)updateByMethod:(id(^)())updateMethod target:(id)target callback:(SEL)callback;
@end
