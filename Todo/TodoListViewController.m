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
#import "LTPopButton.h"
#import "TodoInputView.h"
#import "Settings.h"

@interface TodoListViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,TodoCellDelegate,TodoInputViewDelegate>
@property (weak, nonatomic) IBOutlet LTPopButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) TodoInputView *inputView;
@property BOOL inputViewIsAnimating;

@property BOOL animated;
@property (nonatomic,strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@property (nonatomic,strong) NSMutableArray *todoList;
@property (nonatomic,strong) TodoService *todoService;
@end

@implementation TodoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.animated = NO;
    
    self.inputView = [[TodoInputView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
    self.inputView.delegate = self;

    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePopRecognizer:)];
    popRecognizer.delegate = self;
    popRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:popRecognizer];
    
}

- (TodoService *)todoService
{
    if (!_todoService) {
        _todoService = [TodoService serviceWithType:self.type];
    }
    return _todoService;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.todoList = [[self.todoService loadAll] mutableCopy];
    [self.tableView reloadData];
    
    if ([self.type isEqualToString:@"a"]) {
        self.title = @"important & urgent";
    } else if ([self.type isEqualToString:@"b"]) {
        self.title = @"important";
    } else if ([self.type isEqualToString:@"c"]) {
        self.title = @"urgent";
    } else if ([self.type isEqualToString:@"d"]) {
        self.title = @"neither";
    }
    self.addButton.lineColor=[UIColor whiteColor];
    [self.addButton animateToType:plusType];


    [super viewWillAppear:animated];
    if (!self.animated) {
        //[self animateCellIn];
        self.animated=YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

- (IBAction)addTodo:(LTPopButton *)sender {
    if (self.inputView.shown) {
        [self hideInputView];
    } else {
        [self showInputViewWithType:self.type];
    }
}

- (void)showInputViewWithType:(NSString*) type
{
    if (self.inputViewIsAnimating) {
        return;
    }
    if (!self.inputView.shown) {
        self.inputViewIsAnimating = YES;
        [self.addButton animateToType:closeType];
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
        [self.addButton animateToType:plusType];
        [self.inputView hide];
    }
}

- (void)todoInputView:(TodoInputView *)inputView didAddTodo:(NSDictionary *)todo withType:(NSString *)type;
{
    [self.addButton animateToType:plusType];
    self.todoList = [[self.todoService loadAll]mutableCopy];
    [self.tableView reloadData];
}

- (void)todoInputViewDidShow
{
    self.inputViewIsAnimating = NO;
}

- (void)todoInputViewDidHide
{
    self.inputViewIsAnimating = NO;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TodoCell";
    TodoCell *cell = (TodoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.todo = self.todoList[indexPath.row];
    cell.delegate = self;
    return cell;
    
}

- (void)todoCell:(TodoCell *)cell didRemoveTodo:(NSDictionary *)todo
{
    [self.todoList removeObject:todo];
    [self.todoService saveAll:self.todoList];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TodoCell requriedHeightForTodo:self.todoList[indexPath.row]];
}

- (id)saveObjectAndInsertBlankRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *todo = self.todoList[indexPath.row];

    [self.todoList replaceObjectAtIndex:indexPath.row withObject:@{@"content":@""}];
    return todo;
}

- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSDictionary* todo = self.todoList[fromIndexPath.row];
    [self.todoList removeObjectAtIndex:fromIndexPath.row];
    [self.todoList insertObject:todo atIndex:toIndexPath.row];
}

- (void)finishReorderingWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath; {
    [self.todoList replaceObjectAtIndex:indexPath.row withObject:object];
    [self.todoService saveAll:self.todoList];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (![otherGestureRecognizer.view isDescendantOfView:self.view]) {
        return YES;
    }
    return NO;
}


@end
