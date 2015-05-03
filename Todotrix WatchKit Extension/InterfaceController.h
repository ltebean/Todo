//
//  InterfaceController.h
//  Todotrix WatchKit Extension
//
//  Created by ltebean on 15/5/2.
//  Copyright (c) 2015年 ltebean. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "TodoService.h"
#import "CommonUtils.h"
#import "LabelRow.h"

@interface InterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceTable *table;
@property (nonatomic, strong) NSArray *todoList;
@property (nonatomic, strong) TodoService *service;
@property (nonatomic, copy) NSString* todoType;
- (IBAction)addButtonPressed;
- (IBAction)menuAddPressed;
@end
