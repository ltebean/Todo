//
//  TodoCell.h
//  Todo
//
//  Created by ltebean on 14/11/6.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TodoCell;

@protocol TodoCellDelegate <NSObject>
- (void)todoCell:(TodoCell *)cell didRemoveTodo:(NSDictionary *)todo;
@end


@interface TodoCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *todo;
@property (nonatomic, weak) id<TodoCellDelegate> delegate;
+ (CGFloat)requriedHeightForTodo:(NSDictionary *)todo;
@end
