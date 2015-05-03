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

@interface InterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *label;
@property (nonatomic, strong) NSDictionary *todo;
@property (nonatomic, strong) TodoService *service;
@property (nonatomic, copy) NSString* todoType;

@property (weak, nonatomic) IBOutlet WKInterfaceButton *doneButton;

- (IBAction)doneButtonPressed;
@end
