//
//  InterfaceController.m
//  Todotrix WatchKit Extension
//
//  Created by ltebean on 15/5/2.
//  Copyright (c) 2015年 ltebean. All rights reserved.
//

#import "InterfaceController.h"

@interface InterfaceController()
@property (nonatomic, weak) NSDictionary *todoSelected;
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
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self reloadAll];
    [self updateUI];
    
}

- (void)reloadAll
{
    self.todoList = [self.service loadAll];
}

- (void)updateUI
{
    [self.table setNumberOfRows:self.todoList.count withRowType:@"mainRowType"];
    for (NSInteger i = 0; i < self.table.numberOfRows; i++) {
        LabelRow* theRow = [self.table rowControllerAtIndex:i];
        [theRow.label setText:self.todoList[i][@"content"]];
    }
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
//    self.todoSelected = self.todoList[rowIndex];

}

- (IBAction)menuAddPressed {
    [self promptAdd];
}

- (IBAction)addButtonPressed {
    [self promptAdd];
}

- (void)promptAdd
{
    [self presentTextInputControllerWithSuggestions:@[] allowedInputMode:WKTextInputModeAllowAnimatedEmoji completion:^(NSArray *results) {
        if (results && results[0]) {
            if (![results[0] isKindOfClass:[NSString class]]) {
                return;
            }
            NSDictionary* todo = @{@"id":[CommonUtils uuid], @"content":results[0]};
            [self.service add:todo];
            [self reloadAll];
        }
    }];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



