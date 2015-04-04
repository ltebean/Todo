//
//  TodoCell.m
//  Todo
//
//  Created by ltebean on 14/11/6.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "TodoCell.h"
#import "Settings.h"

#define originLableWidth 150

typedef NS_ENUM(NSInteger, CellState) {
    normalState,
    rightRevealedState,
};

@interface TodoCell()
@property CellState state;
@property(nonatomic,strong) UIView* rightView;
@property(nonatomic,strong) UILabel* rightLabel;
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
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}



- (void)setup
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    recognizer.delegate = self;
    [self.contentView addGestureRecognizer:recognizer];
    
    self.rightView = [[UIView alloc] initWithFrame:CGRectZero];
    self.rightView.backgroundColor = [Settings themeColor];
    
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.rightLabel.textColor = [UIColor whiteColor];
    self.rightLabel.text = @"drag to remove";
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.font = [UIFont fontWithName:@"Heiti SC" size:16];
    self.rightLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.rightLabel.numberOfLines = 0;
    
    [self.rightView addSubview:self.rightLabel];

    [self addSubview:self.rightView];
    [self bringSubviewToFront:self.contentView];
}

- (void)setTodo:(NSDictionary *)todo
{
    _todo = todo;
    [self updateUI];
}

- (void)updateUI
{
    self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:self.todo[@"content"] attributes:[TodoCell textAttributes]];
    
    [self updateRightViewWidthTo:300];
    [self updateRightLabelPositionTo:(300 - originLableWidth)];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGFloat rightThreshold = originLableWidth;
    CGPoint translation = [recognizer translationInView:self];
    
    CGFloat centerX = CGRectGetMidX(self.bounds);
    
    CGFloat offset = self.contentView.center.x - centerX;
    
    if (offset >= -300 && offset <=0 ) {
        self.contentView.center = CGPointMake(self.contentView.center.x+translation.x, self.contentView.center.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
        
        if (offset < -originLableWidth -5) {
            self.rightLabel.text=@"release to finish";
            [self updateRightLabelPositionTo: originLableWidth + (offset+originLableWidth)+5];
        }else{
            self.rightLabel.text=@"drag to finish";
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (-offset > rightThreshold) {
            [self animateCenterXTo:centerX forView:self.contentView];
            self.state = rightRevealedState;
            [self.delegate todoCell:self didRemoveTodo:self.todo];
        } else {
            [self animateCenterXTo:centerX forView:self.contentView];
            self.state = normalState;
        }
        self.rightLabel.text=@"drag to finish";
        [self updateRightLabelPositionTo: originLableWidth ];

    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view.superview];
    if (fabsf(translation.x) < fabsf(translation.y)) {
        return NO;
    }
    if (self.state == normalState && translation.x >0) {
        return NO;
    }
    return YES;
}

- (void)updateRightViewWidthTo:(CGFloat)width
{
    CGRect frame =  self.rightView.frame;
    frame.origin.x = CGRectGetWidth(self.bounds) - width;
    frame.origin.y = 0;
    frame.size.width = width;
    frame.size.height = CGRectGetHeight(self.bounds);
    self.rightView.frame = frame;
}

- (void)updateRightLabelPositionTo:(CGFloat)x
{
    CGRect frame=  self.rightLabel.frame;
    frame.origin.x = x;
    frame.origin.y = 0;
    frame.size.width = originLableWidth;
    frame.size.height = CGRectGetHeight(self.bounds);
    self.rightLabel.frame = frame;

}


- (void)animateCenterXTo:(CGFloat)centerX forView:(UIView *)view
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8
          initialSpringVelocity:0 options:0 animations:^{
              view.center=CGPointMake(centerX, view.center.y);
          } completion:nil];
    
}

+ (CGFloat)requriedHeightForTodo:(NSDictionary*) todo;
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, 9999);
    CGFloat height = [todo[@"content"] boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[TodoCell textAttributes] context:nil].size.height + 30;
    return MAX(60, ceil(height));
}

+ (NSDictionary *)textAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    return @{
             NSFontAttributeName: [UIFont fontWithName:[Settings fontFamily] size:16],
             NSParagraphStyleAttributeName: paragraphStyle
             };
}

@end
