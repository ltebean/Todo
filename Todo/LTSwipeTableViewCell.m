//
//  LTSwipeTableViewCell.m
//  LTSwipeTableViewCell
//
//  Created by ltebean on 14/10/14.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "LTSwipeTableViewCell.h"

typedef NS_ENUM(NSInteger, CellState) {
    normalState,
    rightRevealedState,
};

@interface LTSwipeTableViewCell()<UIScrollViewDelegate>
@property(nonatomic,weak) UIView* rightViewGroup;
@property CellState state;
@end

@implementation LTSwipeTableViewCell

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

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    recognizer.delegate = self;
    [self.contentView addGestureRecognizer:recognizer];
    
    
    UIView *rightButtonsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGRectGetHeight(self.bounds))];
    [self addSubview:rightButtonsView];
    self.rightViewGroup=rightButtonsView;
    [self bringSubviewToFront:self.contentView];
    
    self.state = normalState;
    
}


-(void) layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.rightViewGroup.bounds);
    self.rightViewGroup.frame = CGRectMake(CGRectGetWidth(self.bounds)-width, 0, width, CGRectGetHeight(self.bounds));
}

-(void) addRightView:(UIView *)view
{
    view.frame = CGRectMake(CGRectGetWidth(self.rightViewGroup.bounds), 0, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    CGFloat totalWidth = CGRectGetWidth(view.bounds) + CGRectGetWidth(self.rightViewGroup.bounds);
    self.rightViewGroup.frame = CGRectMake(CGRectGetWidth(self.bounds)-totalWidth, 0, totalWidth, CGRectGetHeight(self.bounds));
    
    [self.rightViewGroup addSubview:view];
}

-(void) animateBack
{
    [self animateCenterXTo:CGRectGetMidX(self.bounds) forView:self.contentView];
}


- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGFloat rightThreshold = CGRectGetWidth(self.rightViewGroup.bounds);
    CGPoint translation = [recognizer translationInView:self];

    CGFloat centerX = CGRectGetMidX(self.bounds);

    CGFloat offset = self.contentView.center.x - centerX;

    if(offset <= 0){
        self.contentView.center = CGPointMake(self.contentView.center.x+translation.x, self.contentView.center.y);
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        
        if(-offset > rightThreshold/2){
            [self animateCenterXTo:centerX-rightThreshold forView:self.contentView];
            self.state = rightRevealedState;
        }else{
            [self animateCenterXTo:centerX forView:self.contentView];
            self.state = normalState;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view.superview];
    if (fabsf(translation.x) < fabsf(translation.y)){
        return false;
    }
    
    if(self.state == normalState && translation.x >0){
        return false;
    }
        
    return true;
}


-(void) animateCenterXTo:(CGFloat) centerX forView:(UIView *)view
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8
          initialSpringVelocity:0 options:0 animations:^{
              view.center=CGPointMake(centerX, view.center.y);
          } completion:nil];

}


@end
