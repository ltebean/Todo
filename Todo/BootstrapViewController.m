//
//  BootstrapViewController.m
//  Todo
//
//  Created by ltebean on 14/11/6.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "BootstrapViewController.h"
#import "LTSlidingViewCoverflowTransition.h"
#import "LTSlidingViewZoomTransition.h"

@interface BootstrapViewController ()

@end

@implementation BootstrapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.animator = [[LTSlidingViewZoomTransition alloc]init]; // set the animator
    
    UIViewController *vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"main"];
    UIViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];

    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
