//
//  SwipeToDeleteCell.m
//  Todo
//
//  Created by ltebean on 15/8/5.
//  Copyright (c) 2015年 ltebean. All rights reserved.
//

#import "SwipeToDeleteCell.h"
#import "UIView+Helpers.h"
#import "Settings.h"
@interface SwipeToDeleteCell()
@property (nonatomic, weak) UIView *rightViewGroup;
@property (nonatomic, weak) UIButton *deleteButton;
@end

@implementation SwipeToDeleteCell

- (void)awakeFromNib {
    self.scrollEnabled = YES;
    // Initialization code
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    recognizer.delegate = self;
    [self.contentView addGestureRecognizer:recognizer];
    
    UIView *rightButtonsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.bounds))];
    rightButtonsView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self addSubview:rightButtonsView];
    self.rightViewGroup = rightButtonsView;
    [self bringSubviewToFront:self.contentView];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, CGRectGetHeight(self.bounds))];
    deleteButton.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    deleteButton.backgroundColor = [Settings themeColor];
    [deleteButton setTitle:@"Finish" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(didWantToDelete) forControlEvents:UIControlEventTouchUpInside];
    [self addRightView:deleteButton];
    self.deleteButton = deleteButton;
    
    self.state = CELL_STATE_NORMAL;
}

# pragma mark - drag to delete
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.rightViewGroup.bounds);
    self.rightViewGroup.frame = CGRectMake(CGRectGetWidth(self.bounds) - width, 0, width, CGRectGetHeight(self.bounds));
}

- (void)addRightView:(UIView *)view
{
    view.frame = CGRectMake(CGRectGetWidth(self.rightViewGroup.bounds), 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    CGFloat totalWidth = CGRectGetWidth(view.bounds) + CGRectGetWidth(self.rightViewGroup.bounds);
    self.rightViewGroup.frame = CGRectMake(CGRectGetWidth(self.bounds) - totalWidth, 0, totalWidth, CGRectGetHeight(self.bounds));
    [self.rightViewGroup addSubview:view];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if (!self.scrollEnabled) {
        return;
    }
    CGFloat rightThreshold = CGRectGetWidth(self.rightViewGroup.bounds);
    CGPoint translation = [recognizer translationInView:self];
    
    CGFloat centerX = CGRectGetMidX(self.bounds);
    
    CGFloat offset = self.contentView.center.x - centerX;
    
    if (offset <= 0) {
        self.contentView.center = CGPointMake(self.contentView.center.x + translation.x, self.contentView.center.y);
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    
    CGFloat changPoint = CHANGE_POINT;
    
    if (fabs(offset) > changPoint) {
        [self.deleteButton setTitle:@"Release to finish" forState:UIControlStateNormal];
    } else {
        [self.deleteButton setTitle:@"Finish" forState:UIControlStateNormal];
    }
    
    if (fabs(offset) > self.rightViewGroup.width) {
        self.rightView.left = - (fabs(offset) - self.rightViewGroup.width);
        self.rightView.width = fabs(offset);
    } else {
        self.rightView.left = 0;
        self.rightView.width = self.rightViewGroup.width;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (fabs(offset) > changPoint) {
            [self didWantToDelete];
            return;
        }
        if (fabs(offset) > rightThreshold / 2){
            [self animateContentViewCenterXTo:centerX - rightThreshold];
            self.state = CELL_STATE_RIGHT_VIEW_SHOWN;
        } else {
            [self animateContentViewCenterXTo:centerX];
            self.state = CELL_STATE_NORMAL;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
        if (self.state == CELL_STATE_NORMAL && translation.x >= 0) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (UIView *)rightView
{
    UIView *view = (UIView *)self.rightViewGroup.subviews[0];
    return view;
}

- (void)animateContentViewCenterXTo:(CGFloat)centerX
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8
          initialSpringVelocity:0 options:0 animations:^{
              self.contentView.centerX = centerX;
              self.rightView.left = 0;
              self.rightView.width = self.rightViewGroup.width;
              [self.deleteButton setTitle:@"Finish" forState:UIControlStateNormal];
          } completion:nil];
}

- (void)showDeleteButton
{
    CGFloat rightThreshold = CGRectGetWidth(self.rightViewGroup.bounds);
    CGFloat centerX = CGRectGetMidX(self.bounds);
    [self animateContentViewCenterXTo:centerX - rightThreshold];
    self.state = CELL_STATE_RIGHT_VIEW_SHOWN;
    
}

- (void)hideDeleteButton
{
    [self animateContentViewCenterXTo:CGRectGetMidX(self.bounds)];
    self.state = CELL_STATE_NORMAL;
    
}

- (void)didWantToDelete
{
    
}
@end
