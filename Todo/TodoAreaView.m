//
//  AreaView.m
//  Todo
//
//  Created by ltebean on 14/11/5.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "TodoAreaView.h"
#import "TodoTypeLabel.h"
#import "TodoService.h"
#import "Settings.h"
#import <Crashlytics/Crashlytics.h>

#define LABEL_ZOOM 1.15
#define BORDER_COLOR [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]

@interface TodoAreaView()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (nonatomic,strong) TodoService *todoService;
@property (nonatomic,strong) NSDictionary *todo;
@property (nonatomic) CGPoint dragBeginPoint;
@end

@implementation TodoAreaView

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self load];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self load];

    }
    return self;
}

- (void)load
{
    [[NSBundle bundleForClass:[self class]] loadNibNamed:@"TodoAreaView" owner:self options:nil];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.containerView.frame = self.bounds;
    [self addSubview: self.containerView];
    [self setup];
}

- (CGPoint)centerPoint
{
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (UIFont *)textFont
{
    return [UIFont fontWithName:[Settings fontFamily] size:16];
}

- (void)setup
{
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.containerView addGestureRecognizer:recognizer];
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = BORDER_COLOR.CGColor;
    
    self.label.userInteractionEnabled = YES;

    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.minimumPressDuration = 0.3;
    longPressGesture.numberOfTouchesRequired = 1;
    longPressGesture.allowableMovement = 10;
    longPressGesture.delegate=self;
    [self.label addGestureRecognizer:longPressGesture];

    self.clipsToBounds=YES;
    [self hideEmptyLabel];
}

- (void)setType:(NSString *)type
{
    _type = type;
    [self initTypeLabelAndService];
    [self refreshData];
}

- (void)refreshData
{
    self.label.font = [self textFont];
    self.emptyLabel.font = [self textFont];
    NSArray *todoList = [self.todoService loadAll];
    if (!todoList || todoList.count == 0) {
        [self showEmptyLabel];
    }else {
        [self hideEmptyLabel];
        self.todo = todoList[0];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        paragraphStyle.alignment = self.label.textAlignment;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.todo[@"content"] attributes:attributes];
        self.label.attributedText = attributedText;
        
        if (todoList.count > 1) {
            self.moreLabel.text = [NSString stringWithFormat:@"%lu more", todoList.count - 1];
        } else {
            self.moreLabel.text = @"";
        }
    }
}


- (void)showEmptyLabel
{
    self.emptyLabel.hidden = NO;
    self.label.hidden = YES;
    self.moreLabel.hidden = YES;
}

- (void)hideEmptyLabel
{
    self.emptyLabel.hidden=YES;
    self.label.hidden = NO;
    self.moreLabel.hidden = NO;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        self.dragBeginPoint = [recognizer locationInView:self];
        [UIView animateWithDuration:0.1 animations:^{
            self.label.transform = CGAffineTransformMakeScale(LABEL_ZOOM, LABEL_ZOOM);
        }];
       
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect pullBackArea = CGRectMake(self.frame.size.width / 4, self.frame.size.height / 4, self.frame.size.width / 2, self.frame.size.height / 2);
        if (CGRectContainsPoint(pullBackArea, recognizer.view.center)) {
            [self animateLabelBack];
        }else{
            [self showNext];
            [Answers logCustomEventWithName:@"home_finish_todo" customAttributes:@{@"type": self.type}];
        }
    } else {
        CGPoint location = [recognizer locationInView:self];
        
        UIView *view = recognizer.view;
        CGPoint center = self.centerPoint;

        CGFloat translationX = location.x - self.dragBeginPoint.x;
        CGFloat translationY = location.y - self.dragBeginPoint.y;
        view.center = CGPointMake(center.x + translationX,
                                  center.y + translationY);
        
        CGFloat offset = MAX(fabs(center.x - view.center.x), fabs(center.y - view.center.y));
        
        CGFloat percent = offset / (CGRectGetWidth(self.bounds));
        
        self.label.alpha = 1 - 1 * percent;
        CGFloat scale = LABEL_ZOOM - LABEL_ZOOM * percent / 2;
        self.label.transform = CGAffineTransformMakeScale(scale, scale);

    }
}


- (void)showNext
{
    [self.todoService deleteFirst];
    [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
        self.label.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        self.label.alpha = 1;
        self.label.center = self.centerPoint;
        [self refreshData];
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:0 animations:^{
            self.label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {

        }];
    }];
    
}

- (void)animateLabelBack
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:0 animations:^{
        self.label.alpha = 1;
        self.label.center = [self centerPoint];
        self.label.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {

    }];
}

- (void)initTypeLabelAndService
{
    if ([self.type isEqualToString:TODO_TYPE_A]) {
        TodoTypeLabel* importantLabel = [self generateImportantLabel];
        TodoTypeLabel* urgentLabel = [self generateUrgentLabel];
        [self setOrigin:CGPointMake(10, 10) ForView:importantLabel];
        [self addSubview:importantLabel];
        [self setOrigin:CGPointMake(92, 10) ForView:urgentLabel];
        [self addSubview:urgentLabel];
    } else if ([self.type isEqualToString:TODO_TYPE_B]) {
        TodoTypeLabel* importantLabel = [self generateImportantLabel];
        [self setOrigin:CGPointMake(10, 10) ForView:importantLabel];
        [self addSubview:importantLabel];
    } else if ([self.type isEqualToString:TODO_TYPE_C]) {
        TodoTypeLabel* urgentLabel = [self generateUrgentLabel];
        [self setOrigin:CGPointMake(10, 10) ForView:urgentLabel];
        [self addSubview:urgentLabel];
    } else if ([self.type isEqualToString:TODO_TYPE_D]) {

    }
    self.todoService = [TodoService serviceWithType:self.type];
}

- (void)setOrigin:(CGPoint)origin ForView:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin = origin;
    view.frame = frame;
}


- (TodoTypeLabel *)generateImportantLabel
{
    TodoTypeLabel *label= [[TodoTypeLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 26)];
    label.text = @"important";
    label.layer.cornerRadius = 13.0f;
    label.clipsToBounds=YES;
    return label;
}

- (TodoTypeLabel *)generateUrgentLabel
{
    TodoTypeLabel* label= [[TodoTypeLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 26)];
    label.text = @"urgent";
    label.layer.cornerRadius = 13.0f;
    label.clipsToBounds = YES;
    return label;
}

- (void)tapped:(UITapGestureRecognizer*)recognizer
{
    [self.delegate didTappedAreaView:self withTodo:self.todo];
}

@end
