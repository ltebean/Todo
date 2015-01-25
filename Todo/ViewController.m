//
//  ViewController.m
//  Todo
//
//  Created by ltebean on 14/11/5.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "ViewController.h"
#import "TodoAreaView.h"
#import "LTPopButton.h"
#import "TodoInputView.h"
#import "TodoListViewTransition.h"
#import "TodoListViewController.h"
#import "Settings.h"
#import "TodoService.h"

@interface ViewController ()<UIGestureRecognizerDelegate,AreaViewDelegate,UINavigationControllerDelegate,TodoInputViewDelegate>
@property (weak, nonatomic) IBOutlet LTPopButton *settingsButton;
@property (weak, nonatomic) IBOutlet LTPopButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,strong) TodoInputView* inputView;
@property(nonatomic,strong) NSDictionary* areas;
@property BOOL inputViewIsAnimating;
@property BOOL loaded;
@property(nonatomic,copy) NSString* currentEditingType;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.loaded=NO;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.inputView = [[TodoInputView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
    self.inputView.delegate=self;
    
    UISwipeGestureRecognizer* swipeDownGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeDown:)];
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownGesture];
    
    UISwipeGestureRecognizer* swipeUpGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeUp:)];
    swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpGesture];
}

- (void)handleSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    [self showInputViewWithType:nil];
}

- (void)handleSwipeUp:(UISwipeGestureRecognizer *)recognizer
{
    [self hideInputView];
}

- (TodoAreaView *)generateAreaViewWithType:(NSString *)type
{
    CGFloat width = CGRectGetWidth(self.containerView.bounds);
    CGFloat height = CGRectGetHeight(self.containerView.bounds);
    
    CGFloat areaWidth = width/2;
    CGFloat areaHeight = height/2;

    TodoAreaView* areaView = [[TodoAreaView alloc]initWithFrame:CGRectMake(0, 0, areaWidth, areaHeight)];
    
    if ([type isEqualToString:TODO_TYPE_A]) {
        areaView.center = CGPointMake(width/4, height/4);
    } else if ([type isEqualToString:TODO_TYPE_B]) {
        areaView.center = CGPointMake(width/4*3, height/4);
    } else if ([type isEqualToString:TODO_TYPE_C]) {
        areaView.center = CGPointMake(width/4, height/4*3);
    } else if ([type isEqualToString:TODO_TYPE_D]) {
        areaView.center = CGPointMake(width/4*3, height/4*3);
    }
    areaView.delegate=self;
    areaView.type=type;
    return areaView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (self.loaded) {
        if (self.currentEditingType) {
            TodoAreaView* area = self.areas[self.currentEditingType];
            [area refreshData];
        }
        return;
    }
    
    self.menuButton.lineColor = [UIColor whiteColor];
    [self.menuButton animateToType:plusType];
    self.settingsButton.lineColor = [UIColor whiteColor];
    
    TodoAreaView *areaA = [self generateAreaViewWithType:TODO_TYPE_A];
    TodoAreaView *areaB = [self generateAreaViewWithType:TODO_TYPE_B];
    TodoAreaView *areaC = [self generateAreaViewWithType:TODO_TYPE_C];
    TodoAreaView *areaD = [self generateAreaViewWithType:TODO_TYPE_D];
    
    self.areas = @{@"a":areaA,@"b":areaB,@"c":areaC,@"d":areaD};

    [self.containerView addSubview:areaA];
    [self.containerView addSubview:areaB];
    [self.containerView addSubview:areaC];
    [self.containerView addSubview:areaD];

    [self animateAreaViewIn:areaA delay:0];
    [self animateAreaViewIn:areaB delay:0.12];
    [self animateAreaViewIn:areaC delay:0.24];
    [self animateAreaViewIn:areaD delay:0.36];
    
    self.loaded = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate=self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.navigationController.delegate==self) {
        self.navigationController.delegate=nil;
    }
}

- (void)animateAreaViewIn:(UIView *)view delay:(NSTimeInterval)delay
{
    view.alpha = 0;
    view.transform = CGAffineTransformMakeScale(5, 5);
    [UIView animateWithDuration:1.0 delay:delay usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
        view.transform = CGAffineTransformIdentity;
        view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)todoInputView:(TodoInputView *)inputView didAddTodo:(NSDictionary*) todo withType:(NSString *) type;
{
    [self.menuButton animateToType:plusType];
    TodoAreaView *area = self.areas[type];
    [area refreshData];
}

- (void)todoInputViewDidShow
{
    self.inputViewIsAnimating = NO;
}

- (void)todoInputViewDidHide
{
    self.inputViewIsAnimating = NO;
}

- (void)didTappedAreaView:(TodoAreaView *)areaView withTodo:(NSDictionary *)todo
{
    if (self.inputView.shown) {
        return;
    }
    if (todo) {
        self.currentEditingType = areaView.type;
        [self performSegueWithIdentifier:@"detail" sender:areaView.type];
    } else {
        [self showInputViewWithType:areaView.type];
    }
    
}

- (IBAction)showMenu:(id)sender {
    if (self.inputView.shown) {
        [self hideInputView];
    }else{
        [self showInputViewWithType:nil];
    }
}

-(void) showInputViewWithType:(NSString*) type
{
    if (self.inputViewIsAnimating) {
        return;
    }
    if (!self.inputView.shown) {
        self.inputViewIsAnimating = YES;
        [self.menuButton animateToType:closeType];
        [self.inputView showInView:self.view withType:type];
    }
}

- (void)hideInputView
{
    if (self.inputViewIsAnimating) {
        return;
    }
    if (self.inputView.shown) {
        self.inputViewIsAnimating = YES;
        [self.menuButton animateToType:plusType];
        [self.inputView hide];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    TodoListViewTransition* transiton = [[TodoListViewTransition alloc] init];
    transiton.push = YES;
    return transiton;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detail"]) {
        TodoListViewController* vc = segue.destinationViewController;
        vc.type = sender;
    }
}

@end
