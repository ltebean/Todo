//
//  TodoTypeLabel.m
//  Todo
//
//  Created by ltebean on 14/11/6.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "TodoTypeLabel.h"
#import "Settings.h"

@implementation TodoTypeLabel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void) setup
{
    self.backgroundColor = [Settings themeColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont fontWithName:@"Heiti SC" size:12.0];
}

-(void) setText:(NSString *)text
{
    [super setText:text];
    NSDictionary *userAttributes = @{NSFontAttributeName: self.font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    self.bounds=CGRectMake(0, 0, [text sizeWithAttributes:userAttributes].width+18, CGRectGetHeight(self.bounds));
}

@end
