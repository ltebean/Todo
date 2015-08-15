//
//  SwipeToDeleteCell.h
//  Todo
//
//  Created by ltebean on 15/8/5.
//  Copyright (c) 2015年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CHANGE_POINT 180;

typedef NS_ENUM(NSInteger, CellState) {
    CELL_STATE_NORMAL,
    CELL_STATE_RIGHT_VIEW_SHOWN,
};

@interface SwipeToDeleteCell : UITableViewCell
@property (nonatomic) CellState state;
@property (nonatomic) BOOL scrollEnabled;
- (void)didWantToDelete;
- (void)showDeleteButton;
- (void)hideDeleteButton;
@end
