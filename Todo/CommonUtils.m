//
//  CommonUtils.m
//  Todo
//
//  Created by Yu Cong on 14-11-8.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+ (NSString*)uuid
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidString;
}
@end
