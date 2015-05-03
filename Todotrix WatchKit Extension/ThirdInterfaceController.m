//
//  ThirdInterfaceController.m
//  Todo
//
//  Created by ltebean on 15/5/2.
//  Copyright (c) 2015年 ltebean. All rights reserved.
//

#import "ThirdInterfaceController.h"


@interface ThirdInterfaceController()

@end


@implementation ThirdInterfaceController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.todoType = TODO_TYPE_B;
    }
    return self;
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



