//
//  TodoCell.m
//  Todo
//
//  Created by ltebean on 14/11/6.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "TodoCell.h"
@interface TodoCell()


@end

@implementation TodoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}



-(void) setup
{
 
    
}

-(void) updateUI
{
//    self.todoTitleLabel.text=self.title;
}

@end
