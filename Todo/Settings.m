//
//  SettingService.m
//  Todo
//
//  Created by ltebean on 14/11/7.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "Settings.h"
#import "TodoService.h"
#import "CommonUtils.h"

#define USED_KEY @"USED"
#define FONT_KEY @"FONT_FAMILY"

#define FM  [NSFileManager defaultManager]
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

@implementation Settings
+ (UIColor *)themeColor
{
    return [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
}

+ (void)migrateDataToContainer
{
    NSURL *documentsDirectoryURL = [FM URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];;
    NSURL * db = [documentsDirectoryURL URLByAppendingPathComponent:@"db"];
    
    //NSLog(@"%@",db.path);
    NSURL *contanierURL = [FM containerURLForSecurityApplicationGroupIdentifier:@"group.todotrix"];
    NSURL * containerDB = [contanierURL URLByAppendingPathComponent:@"db"];
    //NSLog(@"%@",containerDB.path);

    if ([FM fileExistsAtPath:db.path]) {
        [FM copyItemAtPath:db.path toPath:containerDB.path error:nil];
        [FM removeItemAtPath:db.path error:nil];
    }
    
}

+ (void)initFirstUseData
{
    BOOL used = [USER_DEFAULTS boolForKey:USED_KEY];
    if (used) {
        return;
    }
    [USER_DEFAULTS setBool:YES forKey:USED_KEY];
    
    TodoService *todoServiceB = [TodoService serviceWithType:@"b"];
    [todoServiceB saveAll:@[@{@"id":[CommonUtils uuid],@"content":@"Long press on me then swipe to finish"}]];
    
    TodoService *todoServiceA = [TodoService serviceWithType:@"a"];
    [todoServiceA saveAll:@[@{@"id":[CommonUtils uuid],@"content":@"Tap to view the to-do list"},@{@"id":[CommonUtils uuid],@"content":@"Long press to reorder the to-do list"},@{@"id":[CommonUtils uuid],@"content":@"Swipe left to finish a to-do"}]];
    
    TodoService *todoServiceC = [TodoService serviceWithType:@"c"];
    [todoServiceC saveAll:@[@{@"id":[CommonUtils uuid],@"content":@"Swipe down on this screen to create a to-do"}]];
}

+ (NSString *)fontFamily;
{
    NSString *fontFamily = [USER_DEFAULTS stringForKey:FONT_KEY];
    if (!fontFamily) {
        return @"HelveticaNeue-Light";
    } else {
        return fontFamily;
    }
}

+ (void)useFontFamily:(NSString *)fontFamily
{
    [USER_DEFAULTS setValue:fontFamily forKey:FONT_KEY];
    [USER_DEFAULTS synchronize];
}



@end
