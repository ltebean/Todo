//
//  InterfaceController.m
//  Todotrix WatchKit Extension
//
//  Created by ltebean on 15/5/2.
//  Copyright (c) 2015年 ltebean. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.todoType = TODO_TYPE_A;
    }
    return self;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.service = [TodoService serviceWithType:self.todoType];
    [self loadFirst];

    // Configure interface objects here.
}

- (void)loadFirst
{
    self.todo = [self.service loadFirst];
    if (self.todo) {
        [self.label setText:self.todo[@"content"]];
        [self.doneButton setEnabled:YES];
    } else {
        [self.label setTextColor:[UIColor lightGrayColor]];
        [self.label setText:@"empty"];
        [self.doneButton setTitle:@"Add"];
        
    }
}

- (IBAction)doneButtonPressed {
    if (self.todo) {
        [self.service deleteById:self.todo[@"id"]];
        [self loadFirst];
    } else {
        [self presentTextInputControllerWithSuggestions:@[] allowedInputMode:WKTextInputModeAllowAnimatedEmoji completion:^(NSArray *results) {
            if (results && results[0]) {
                NSDictionary* todo =@{@"id":[CommonUtils uuid], @"content":results[0]};
                [self.service add:todo];
                [self loadFirst];
            }
        }];
    }
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



