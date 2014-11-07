//
//  TodoListViewTransition.h
//  Todo
//
//  Created by ltebean on 14/11/7.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TodoListViewTransition : NSObject <UIViewControllerAnimatedTransitioning>
@property(nonatomic) BOOL push;
@end
