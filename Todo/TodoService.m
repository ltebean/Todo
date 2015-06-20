//
//  TodoService.m
//  Todo
//
//  Created by ltebean on 14/11/7.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "TodoService.h"
#define fm [NSFileManager defaultManager]

@implementation TodoService

+ (TodoService *) serviceWithType:(NSString *)type
{
    TodoService *service = [[TodoService alloc] init];
    service.type = type;
    return service;
}


- (NSArray *)loadAll
{
    NSArray* data = [NSArray arrayWithContentsOfFile:[self filePath]];
    if (!data) {
        data = [NSArray array];
    }
    return data;
}

- (NSDictionary *)loadFirst
{
    NSArray *todoList = [self loadAll];
    if (todoList.count > 0) {
        return todoList[0];
    } else {
        return nil;
    }
}

- (void)add:(NSDictionary *)todo
{
    NSMutableArray *todoList = [[self loadAll] mutableCopy];
    [todoList addObject:todo];
    [self saveAll:todoList];
}

- (void)deleteFirst
{
    NSMutableArray *todoList = [[self loadAll] mutableCopy];
    if (todoList && todoList.count>0) {
        [todoList removeObjectAtIndex:0];
        [self saveAll:todoList];
    }
}

- (void)deleteById:(NSString*)todoId
{
    NSMutableArray *todoList = [[self loadAll] mutableCopy];
    if (!todoList||todoList.count ==0) {
        return;
    }
    NSDictionary* todoToDelete;
    for (NSDictionary *todo in todoList) {
        if ([todo[@"id"] isEqualToString:todoId]) {
            todoToDelete = todo;
        }
    }
    if (todoToDelete) {
        [todoList removeObject:todoToDelete];
        [self saveAll:todoList];
    }
}



- (void)saveAll:(NSArray *)todoList
{
    [todoList writeToFile:[self filePath] atomically:YES];
}

- (NSString *)filePath
{
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.todotrix"];
    
    NSURL *dbDirectory = [documentsDirectoryURL URLByAppendingPathComponent:@"db"];
    
    BOOL exists=[fm fileExistsAtPath:dbDirectory.path];
    if (!exists) {
        [fm createDirectoryAtPath:dbDirectory.path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* fileName = [self.type stringByAppendingString:@".plist"];
    
    // NSLog(@"%@",[dbDirectory URLByAppendingPathComponent:fileName].path);
    return [dbDirectory URLByAppendingPathComponent:fileName].path;
  
}
@end
