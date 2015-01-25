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

#define CELL_HEIGHT 45;
#define TABLE_VIEW_TOP 35;

@interface TodoAreaView()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;
@property (nonatomic,strong) TodoService *todoService;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *todos;
@end

@implementation TodoAreaView

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];

    }
    return self;
}

- (void)setup
{
    [[NSBundle mainBundle] loadNibNamed:@"TodoAreaView" owner:self options:nil];
    self.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview: self.containerView];

    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.userInteractionEnabled = NO;
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];

    self.layer.borderWidth=0.5;
    self.layer.borderColor=[[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1] CGColor];
    self.clipsToBounds=YES;
    
    [self hideEmptyLabel];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGFloat tableViewHeight = CGRectGetHeight(self.bounds) - TABLE_VIEW_TOP;
    CGFloat count = tableViewHeight / CELL_HEIGHT;
    return  self.todos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
//    cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    cell.textLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];

    NSDictionary *todo = self.todos[indexPath.row];
    cell.textLabel.text = todo[@"content"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tableViewHeight = CGRectGetHeight(self.bounds) - TABLE_VIEW_TOP;
    return tableViewHeight / 5;
}

- (void)showEmptyLabel
{
    self.emptyLabel.hidden=NO;
    self.tableView.hidden=YES;
}

- (void)hideEmptyLabel
{
    self.emptyLabel.hidden=YES;
    self.tableView.hidden=NO;
}

- (void)setType:(NSString *)type
{
    _type = type;
    [self initTypeLabelAndService];
    [self refreshData];
}

-(void)refreshData
{
    self.todos = [self.todoService loadAll];
    if (!self.todos || self.todos.count == 0) {
        [self showEmptyLabel];
    }else {
        [self hideEmptyLabel];
        [self.tableView reloadData];
    }
}


- (void)initTypeLabelAndService
{
    if ([self.type isEqualToString:TODO_TYPE_A]) {
        TodoTypeLabel *importantLabel= [self generateLabelWithText:@"important"];
        TodoTypeLabel *urgentLabel = [self generateLabelWithText:@"urgent"];
        [self setOrigin:CGPointMake(10, 10) ForView:importantLabel];
        [self addSubview:importantLabel];
        [self setOrigin:CGPointMake(92, 10) ForView:urgentLabel];
        [self addSubview:urgentLabel];
    } else if ([self.type isEqualToString:TODO_TYPE_B]) {
        TodoTypeLabel* importantLabel = [self generateLabelWithText:@"important"];
        [self setOrigin:CGPointMake(10, 10) ForView:importantLabel];
        [self addSubview:importantLabel];
    } else if ([self.type isEqualToString:TODO_TYPE_C]) {
        TodoTypeLabel* urgentLabel = [self generateLabelWithText:@"urgent"];
        [self setOrigin:CGPointMake(10, 10) ForView:urgentLabel];
        [self addSubview:urgentLabel];
    } else if ([self.type isEqualToString:TODO_TYPE_D]) {
        TodoTypeLabel* neitherLabel = [self generateLabelWithText:@"neither"];
        [self setOrigin:CGPointMake(10, 10) ForView:neitherLabel];
        [self addSubview:neitherLabel];
    }
    self.todoService = [TodoService serviceWithType:self.type];

   
}

- (void)setOrigin:(CGPoint)origin ForView:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin=origin;
    view.frame=frame;
}


- (TodoTypeLabel *)generateLabelWithText:(NSString *)text
{
    TodoTypeLabel *label=[[TodoTypeLabel alloc]initWithFrame:CGRectMake(0, 0, 0, 26)];
    label.text = text;
    label.layer.cornerRadius=13.0f;
    label.clipsToBounds=YES;
    return label;
}


@end
