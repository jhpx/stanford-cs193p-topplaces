//
//  DataUtils.m
//  TopPlaces
//
//  Created by 姜孟冯 on 13-10-6.
//  Copyright (c) 2013年 姜孟冯. All rights reserved.
//

#import "DataUtils.h"

@implementation DataUtils
// 异步刷新数据，以任意block方式在后台线程刷新，刷新完成后回主线程调用target的callback方法
+ (void)updateByMethod:(id(^)())updateMethod target:(id)target callback:(SEL)callback;
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
        //        id something = @[updateMethod()[0]];
        id something = updateMethod();
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([target respondsToSelector:callback]) {
                _Pragma("clang diagnostic push") \
                _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
                [target performSelector:callback withObject:something];
                _Pragma("clang diagnostic pop") \
            }
        });
    });
}
@end
