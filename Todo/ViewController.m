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

@interface ViewController ()<UIGestureRecognizerDelegate,AreaViewDelegate,UINavigationControllerDelegate,TodoInputViewDelegate>
@property (weak, nonatomic) IBOutlet LTPopButton *settingsButton;
@property (weak, nonatomic) IBOutlet LTPopButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,strong) TodoAreaView* areaA;
@property(nonatomic,strong) TodoAreaView* areaB;
@property(nonatomic,strong) TodoAreaView* areaC;
@property(nonatomic,strong) TodoAreaView* areaD;
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

-(void)handleSwipeDown:(UISwipeGestureRecognizer*) recognizer
{
    [self showInputViewWithType:nil];
}

-(void)handleSwipeUp:(UISwipeGestureRecognizer*) recognizer
{
    [self hideInputView];
}

-(TodoAreaView*) generateAreaViewWithType:(Type) type
{
    CGFloat width = CGRectGetWidth(self.containerView.bounds);
    CGFloat height = CGRectGetHeight(self.containerView.bounds);
    
    CGFloat areaWidth = width/2;
    CGFloat areaHeight = height/2;

    TodoAreaView* areaView = [[TodoAreaView alloc]initWithFrame:CGRectMake(0, 0, areaWidth, areaHeight)];
    
    if(typeA == type){
        areaView.center = CGPointMake(width/4, height/4);
    }else if(typeB == type){
        areaView.center = CGPointMake(width/4*3, height/4);
    }else if(typeC == type){
        areaView.center = CGPointMake(width/4, height/4*3);
    }else if(typeD == type){
        areaView.center = CGPointMake(width/4*3, height/4*3);
    }
    areaView.delegate=self;
    areaView.type=type;
    return areaView;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    if(self.loaded){
        if(self.currentEditingType){
            TodoAreaView* area = self.areas[self.currentEditingType];
            [area refreshData];
        }
        return;
    }
    
    self.areaA = [self generateAreaViewWithType:typeA];
    self.areaB = [self generateAreaViewWithType:typeB];
    self.areaC = [self generateAreaViewWithType:typeC];
    self.areaD = [self generateAreaViewWithType:typeD];
    
    self.areas=@{@"a":self.areaA,@"b":self.areaB,@"c":self.areaC,@"d":self.areaD};

    [self.containerView addSubview:self.areaA];
    [self.containerView addSubview:self.areaB];
    [self.containerView addSubview:self.areaC];
    [self.containerView addSubview:self.areaD];
    
    self.menuButton.lineColor=[UIColor whiteColor];
    [self.menuButton animateToType:plusType];
    
    self.settingsButton.lineColor=[UIColor whiteColor];

    [self animateAreaViewIn:self.areaA delay:0];
    [self animateAreaViewIn:self.areaB delay:0.12];
    [self animateAreaViewIn:self.areaC delay:0.24];
    [self animateAreaViewIn:self.areaD delay:0.36];
    
    self.loaded = YES;
}




-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate=self;
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(self.navigationController.delegate==self){
        self.navigationController.delegate=nil;
    }
}

-(void) animateAreaViewIn:(UIView*) view delay:(NSTimeInterval) delay
{
    view.alpha=0;
    view.transform = CGAffineTransformMakeScale(5, 5);
    [UIView animateWithDuration:1.0 delay:delay usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
        view.transform=CGAffineTransformIdentity;
        view.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)todoInputView:(TodoInputView*)inputView didAddTodo:(NSDictionary*) todo withType:(NSString*) type;
{
    [self.menuButton animateToType:plusType];
    TodoAreaView* area = self.areas[type];
    [area refreshData];
}

-(void)todoInputViewDidShow
{
    self.inputViewIsAnimating = NO;
}

-(void)todoInputViewDidHide
{
    self.inputViewIsAnimating = NO;
}


-(void) didTappedAreaView:(TodoAreaView *)areaView withTodo:(NSDictionary *)todo
{
    if(self.inputView.shown){
        return;
    }
    NSString* type;
    switch (areaView.type) {
        case typeA: type = @"a";break;
        case typeB: type = @"b";break;
        case typeC: type = @"c";break;
        case typeD: type = @"d";break;
        default:
            break;
    }
    if(todo){
        self.currentEditingType = type;
        [self performSegueWithIdentifier:@"detail" sender:type];
    }else{
        [self showInputViewWithType:type];
    }
    
}

- (IBAction)showMenu:(id)sender {
    if(self.inputView.shown){
        [self hideInputView];
    }else{
        [self showInputViewWithType:nil];
    }
}

-(void) showInputViewWithType:(NSString*) type
{
    if(self.inputViewIsAnimating){
        return;
    }
    if(!self.inputView.shown){
        self.inputViewIsAnimating=YES;
        [self.menuButton animateToType:closeType];
        [self.inputView showInView:self.view withType:type];
    }
}

-(void) hideInputView
{
    if(self.inputViewIsAnimating){
        return;
    }
    if(self.inputView.shown){
        self.inputViewIsAnimating=YES;
        [self.menuButton animateToType:plusType];
        [self.inputView hide];
    }
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    TodoListViewTransition* transiton = [[TodoListViewTransition alloc] init];
    transiton.push=YES;
    return transiton;
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"detail"]){
        TodoListViewController* vc = segue.destinationViewController;
        vc.type=sender;
    }
}


@end
