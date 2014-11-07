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
#import "LTBounceSheet.h"
#import "TodoListViewTransition.h"
#import "TodoListViewController.h"
#import "Settings.h"

@interface ViewController ()<UIGestureRecognizerDelegate,AreaViewDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet LTPopButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,strong) LTBounceSheet* sheet;
@property(nonatomic,strong) TodoAreaView* areaA;
@property(nonatomic,strong) TodoAreaView* areaB;
@property(nonatomic,strong) TodoAreaView* areaC;
@property(nonatomic,strong) TodoAreaView* areaD;
@property BOOL loaded;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.loaded=NO;
    [self initInputSheet];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
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
        return;
    }
    self.areaA = [self generateAreaViewWithType:typeA];
    self.areaB = [self generateAreaViewWithType:typeB];
    self.areaC = [self generateAreaViewWithType:typeC];
    self.areaD = [self generateAreaViewWithType:typeD];
    
    
    [self.containerView addSubview:self.areaA];
    [self.containerView addSubview:self.areaB];
    [self.containerView addSubview:self.areaC];
    [self.containerView addSubview:self.areaD];
    
    self.menuButton.lineColor=[UIColor whiteColor];
    [self.menuButton animateToType:plusType];
    
    
    NSLog(@"%@",NSStringFromCGRect(self.containerView.frame));

    [self animateAreaViewIn:self.areaA delay:0];
    [self animateAreaViewIn:self.areaB delay:0.12];
    [self animateAreaViewIn:self.areaC delay:0.24];
    [self animateAreaViewIn:self.areaD delay:0.36];
    
    self.loaded = YES;
}

-(void) initInputSheet
{
    self.sheet = [[LTBounceSheet alloc]initWithHeight:250 bgColor:[Settings themeColor]];

    [self.sheet addSubview:self.inputView];
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


-(void) didTappedAreaView:(TodoAreaView *)areaView
{
    [self performSegueWithIdentifier:@"detail" sender:areaView];
}

- (IBAction)showMenu:(id)sender {
    if(self.sheet.shown){
        [self.menuButton animateToType:plusType];
    }else{
        [self.menuButton animateToType:closeType];
    }
    [self.sheet toggle];

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
        vc.type=@"a";
    }
}





@end
