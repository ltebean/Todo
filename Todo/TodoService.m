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

+(TodoService*) serviceWithType:(NSString*) type
{
    TodoService* service = [[TodoService alloc]init];
    service.type = type;
    return service;
}


-(NSArray*) loadAll
{
    NSArray* data=[NSArray arrayWithContentsOfFile:[self filePath]];
    return data;
}

-(void) saveAll:(NSArray*) todoList
{
    [todoList writeToFile:[self filePath] atomically:YES];
}

-(NSString*) filePath
{
    NSURL *documentsDirectoryURL = [fm URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    
    NSURL * dbDirectory = [documentsDirectoryURL URLByAppendingPathComponent:@"db"];
    
    BOOL exists=[fm fileExistsAtPath:dbDirectory.path];
    if (!exists) {
        [fm createDirectoryAtPath:dbDirectory.path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString* fileName = [self.type stringByAppendingString:@".plist"];
    
    NSLog(@"%@",[dbDirectory URLByAppendingPathComponent:fileName].path);
    return [dbDirectory URLByAppendingPathComponent:fileName].path;
  
}
@end
