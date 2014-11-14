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

#define lableZoom 1.15

@interface TodoAreaView()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (nonatomic,strong) TodoService* todoService;
@property (atomic) BOOL longPressed;
@property (atomic) BOOL panning;
@property CGPoint centerPoint;
@property (nonatomic) CGRect pullBackArea;
@property(nonatomic,strong) NSDictionary *todo;
@end

@implementation TodoAreaView

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"TodoAreaView" owner:self options:nil];
        self.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview: self.containerView];
        [self setup];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"TodoAreaView" owner:self options:nil];
        self.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        [self addSubview: self.containerView];
        [self setup];

    }
    return self;
}

-(void) setup
{

    self.centerPoint = self.label.center;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.containerView addGestureRecognizer:recognizer];
    
    self.layer.borderWidth=0.5;
    self.layer.borderColor=[[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] CGColor];
    
    self.label.userInteractionEnabled=YES;

    
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.minimumPressDuration = 0.3;
    longPressGesture.numberOfTouchesRequired=1;
    longPressGesture.allowableMovement=10;
    longPressGesture.delegate=self;
    [self.label addGestureRecognizer:longPressGesture];
    
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate=self;
    [self.label addGestureRecognizer:panGesture];
    
    self.longPressed = NO;
    self.panning = NO;
    self.clipsToBounds=YES;
    
    self.pullBackArea= CGRectMake(self.frame.size.width/4, self.frame.size.height/4, self.frame.size.width/2, self.frame.size.height/2);
    
    [self hideEmptyLabel];
    
}

-(void) showEmptyLabel
{
    self.emptyLabel.hidden=NO;
    self.label.hidden=YES;
}

-(void) hideEmptyLabel
{
    self.emptyLabel.hidden=YES;
    self.label.hidden=NO;
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        self.longPressed=YES;
        [UIView animateWithDuration:0.1 animations:^{
            self.label.transform = CGAffineTransformMakeScale(lableZoom, lableZoom);
        }];
       
    } else if(recognizer.state == UIGestureRecognizerStateEnded)  {
        self.longPressed=NO;
        if(!self.panning){
            [self animateLabelBack];
        }
    }
}




-(void) handlePan:(UIPanGestureRecognizer *) recognizer{
    if(!self.longPressed && !self.panning){
        return;
    }
    self.panning=YES;
    CGPoint translation = [recognizer translationInView:self];

    UIView *view = recognizer.view;
    view.center = CGPointMake(view.center.x + translation.x,
                              view.center.y + translation.y);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
    
    
    CGPoint center = self.centerPoint;
    
    CGFloat offset = MAX(fabs(center.x-view.center.x), fabs(center.y-view.center.y));
    
    CGFloat percent = offset/(CGRectGetWidth(self.bounds));
    
    self.label.alpha = 1-1*percent;
    CGFloat scale = lableZoom - lableZoom*percent/2;
    self.label.transform = CGAffineTransformMakeScale(scale,scale);

    if(recognizer.state == UIGestureRecognizerStateEnded) {
        if(CGRectContainsPoint(self.pullBackArea, recognizer.view.center)){
            [self animateLabelBack];
        }else{
            [self showNext];
        }
    }
}

-(void) showNext
{
    [self.todoService deleteFirst];
    [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
        self.label.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        self.label.alpha=1;
        self.label.center = self.centerPoint;
        [self refreshData];
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:0 animations:^{
            self.label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.panning=NO;
        }];
    }];
    
}

-(void) animateLabelBack
{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:0 animations:^{
        self.label.alpha=1;
        self.label.center = [self centerPoint];
        self.label.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.panning=NO;
        self.longPressed=NO;
    }];
}



-(void) setType:(Type)type
{
    _type = type;
    [self initTypeLabelAndService];
    [self refreshData];
}

-(void) refreshData
{
    self.todo = [self.todoService loadFirst];
    if(!self.todo){
        [self showEmptyLabel];
    }else {
        [self hideEmptyLabel];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        paragraphStyle.alignment = self.label.textAlignment;
        NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.todo[@"content"] attributes:attributes];
        self.label.attributedText = attributedText;
    }
}


-(void) initTypeLabelAndService
{
    switch (self.type) {
        case typeA:{
            TodoTypeLabel* importantLabel=[self generateImportantLabel];
            TodoTypeLabel* urgentLabel=[self generateUrgentLabel];
            [self setOrigin:CGPointMake(10, 10) ForView:importantLabel];
            [self addSubview:importantLabel];
            [self setOrigin:CGPointMake(92, 10) ForView:urgentLabel];
            [self addSubview:urgentLabel];
            self.todoService = [TodoService serviceWithType:@"a"];
            break;

        }
        case typeB:{
            TodoTypeLabel* importantLabel=[self generateImportantLabel];
            [self setOrigin:CGPointMake(10, 10) ForView:importantLabel];
            [self addSubview:importantLabel];
            self.todoService = [TodoService serviceWithType:@"b"];
            break;
        }
        case typeC:{
            TodoTypeLabel* urgentLabel=[self generateUrgentLabel];
            [self setOrigin:CGPointMake(10, 10) ForView:urgentLabel];
            [self addSubview:urgentLabel];
            self.todoService = [TodoService serviceWithType:@"c"];
            break;

        }
        case typeD:
            self.todoService = [TodoService serviceWithType:@"d"];
            break;
            
        default:
            break;
    }
   
}

-(void) setOrigin:(CGPoint) origin ForView:(UIView*) view
{
    CGRect frame = view.frame;
    frame.origin=origin;
    view.frame=frame;
}


- (TodoTypeLabel*) generateImportantLabel
{
    TodoTypeLabel* label=[[TodoTypeLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 26)];
    label.text = @"important";
    label.layer.cornerRadius=13.0f;
    label.clipsToBounds=YES;
    return label;
}

-(TodoTypeLabel*) generateUrgentLabel
{
    TodoTypeLabel* label=[[TodoTypeLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 26)];
    label.text = @"urgent";
    label.layer.cornerRadius=13.0f;
    label.clipsToBounds=YES;
    return label;
}

-(void) tapped:(UITapGestureRecognizer*) recognizer
{
    if(self.longPressed){
        return;
    }
    [self.delegate didTappedAreaView:self withTodo:self.todo];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(!self.panning && [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]){
        return YES;
    }
    if(![otherGestureRecognizer.view isDescendantOfView:self]){
        return NO;
    }
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        return YES;
    }


    return NO;
}




@end
