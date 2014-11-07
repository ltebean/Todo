//
//  TodoService.h
//  Todo
//
//  Created by ltebean on 14/11/7.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoService : NSObject

@property(nonatomic,strong) NSString* type;

+(TodoService*) serviceWithType:(NSString*) type;
-(NSArray*) loadAll;
-(void) saveAll:(NSArray*) todoList;

@end
