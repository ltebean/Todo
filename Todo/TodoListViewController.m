//
//  TodoListViewController.m
//  Todo
//
//  Created by ltebean on 14/11/6.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "TodoListViewController.h"
#import "TodoCell.h"
#import "LTPopButton.h"
#import "TodoListViewTransition.h"
#import "TodoService.h"

@interface TodoListViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL animated;
@property (weak, nonatomic) IBOutlet LTPopButton *editButton;
@property (nonatomic,strong) UIPercentDrivenInteractiveTransition* interactivePopTransition;
@property (nonatomic,strong) NSMutableArray* todoList;
@property (nonatomic,strong) TodoService* todoService;
@end

@implementation TodoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.animated=NO;
    self.todoList=[[NSArray arrayWithObjects:@"todo1", @"todo2", @"todo3", @"todo4", @"todo5",@"todo6", nil] mutableCopy];
    
    [self.editButton setLineColor:[UIColor whiteColor]];
    
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
    popRecognizer.delegate=self;
    popRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:popRecognizer];
}

-(TodoService*) todoService
{
    if(!_todoService){
        _todoService = [TodoService serviceWithType:self.type];
    }
    return _todoService;
}

-(void) animateCellIn
{
    self.tableView.alpha = 0.0f;
    [self.tableView reloadData];
    
    // Store a delta timing variable so I can tweak the timing delay
    // between each row’s animation and some additional
    CGFloat diff = .05;
    CGFloat tableHeight = self.tableView.bounds.size.height;
    NSArray *cells = [self.tableView visibleCells];
    
    // Iterate across the rows and translate them down off the screen
    for (NSUInteger i = 0; i < [cells count]; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        cell.transform = CGAffineTransformMakeTranslation(0, tableHeight);
        //cell.transform = CGAffineTransformMakeScale(5, 5);

    }
    
    // Now that all rows are off the screen, make the tableview opaque again
    self.tableView.alpha = 1.0f;
    
    // Animate each row back into place
    for (NSUInteger i = 0; i < [cells count]; i++) {
        UITableViewCell *cell = [cells objectAtIndex:i];
        
        [UIView animateWithDuration:1.2 delay:diff*i usingSpringWithDamping:0.8
              initialSpringVelocity:0 options:0 animations:^{
                  cell.transform = CGAffineTransformIdentity;
              } completion:NULL];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    //self.todoList = [[self.todoService loadAll]mutableCopy];
    [self.tableView reloadData];

    [super viewWillAppear:animated];
    if(!self.animated){
        //[self animateCellIn];
        self.animated=YES;
    }
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

- (IBAction)edit:(id)sender {
    if(self.tableView.editing){
        [self.editButton animateToType:menuType];
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.tableView setEditing:YES animated:YES];
        [self.editButton animateToType:closeType];
    }
}

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.todoList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
     typedef NS_ENUM(NSInteger, UITableViewCellEditingStyle) {
     UITableViewCellEditingStyleNone,
     UITableViewCellEditingStyleDelete,
     UITableViewCellEditingStyleInsert
     };
     */
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TodoCell";
    TodoCell *cell = (TodoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.todoList[indexPath.row];
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    TodoListViewTransition* transiton = [[TodoListViewTransition alloc] init];
    transiton.push=NO;
    return transiton;
    
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    // Check if this is for our custom transition
    if ([animationController isKindOfClass:[TodoListViewTransition class]]) {
        return self.interactivePopTransition;
    }
    else {
        return nil;
    }
}

- (void)handlePopRecognizer:(UIScreenEdgePanGestureRecognizer*)recognizer {
    // Calculate how far the user has dragged across the view
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // Create a interactive transition and pop the view controller
        self.interactivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // Update the interactive transition's progress
        [self.interactivePopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // Finish or cancel the interactive transition
        if (progress > 0.3) {
            [self.interactivePopTransition finishInteractiveTransition];
        }
        else {
            [self.interactivePopTransition cancelInteractiveTransition];
        }
        
        self.interactivePopTransition = nil;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(![otherGestureRecognizer.view isDescendantOfView:self.view]){
        return YES;
    }
    return NO;
}

@end
