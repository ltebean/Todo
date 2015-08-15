//
//  TodayViewController.m
//  TodoExtenstion
//
//  Created by ltebean on 14/11/13.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TodoService.h"
#import "Settings.h"


#define CELL_HEIGHT 30
#define SECTION_HEIGHT 25

@interface TodayViewController () <NCWidgetProviding,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary* data;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource =self;
    self.tableView.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self loadData];
}

-(void) loadData
{
    self.data = [NSMutableDictionary dictionary];

    NSArray *types = @[@"a",@"b",@"c"];
    
    for (NSString *type in types) {
        TodoService *todoService = [TodoService serviceWithType:type];
        NSDictionary *todo = [todoService loadFirst];
        if (todo) {
            self.data[type] = todo[@"content"];
        }
    }
    [self.tableView reloadData];
    
    if ([self.data allKeys].count ==0) {
         self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CELL_HEIGHT);
    } else {
         self.preferredContentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), [self.data allKeys].count * (CELL_HEIGHT + SECTION_HEIGHT));
    }
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(defaultMarginInsets.top, defaultMarginInsets.left-30, defaultMarginInsets.bottom, defaultMarginInsets.right);
 
}

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data allKeys].count == 0 ? 1 : [self.data allKeys].count;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.data allKeys].count == 0) {
        return 0;
    }else{
        return SECTION_HEIGHT;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.data allKeys].count == 0 ) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    label.textColor = [Settings themeColor];
    label.font = [UIFont systemFontOfSize:14];
    /* Section header is in 0th index... */
    NSString *type = [self.data allKeys][section];
    label.text = [self titleOfType:type];
    [view addSubview:label];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if([self.data allKeys].count == 0 ){
        cell.textLabel.text = @"empty";
    }else{
        NSString* todoType = [self.data allKeys][indexPath.section];
        NSString* content = self.data[todoType];
        cell.textLabel.text = content;
    }
    return cell;
}


-(NSString *)titleOfType:(NSString *)type
{
    if ([type isEqualToString:@"a"]) {
        return @"important & urgent";
    } else if([type isEqualToString:@"b"]) {
        return @"important";
    } else if([type isEqualToString:@"c"]) {
        return @"urgent";
    } else if([type isEqualToString:@"d"]) {
        return @"neither";
    }
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.extensionContext openURL:[NSURL URLWithString:@"todotrix://"] completionHandler:^(BOOL success) {
    
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
