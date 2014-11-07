//
//  TodoListViewTransition.m
//  Todo
//
//  Created by ltebean on 14/11/7.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "TodoListViewTransition.h"
#define zoomMin 0.7
#define zoomMax 1.5

@implementation TodoListViewTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    UIView* sourceView = fromViewController.view;
    UIView* desticationView=toViewController.view;
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    
    desticationView.alpha=0;
    if(self.push){
        desticationView.transform = CGAffineTransformMakeScale(zoomMax, zoomMax);
    }else{
        desticationView.transform = CGAffineTransformMakeScale(zoomMin, zoomMin);
    }
    
    [containerView addSubview:desticationView];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0 options:0 animations:^{
        sourceView.alpha =0;
        desticationView.alpha=1;
        if(self.push){
            sourceView.transform = CGAffineTransformMakeScale(zoomMin, zoomMin);
        }else{
            sourceView.transform = CGAffineTransformMakeScale(zoomMax, zoomMax);
        }
        
        desticationView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        sourceView.alpha =1;
        sourceView.transform = CGAffineTransformIdentity;
        
        desticationView.alpha=1;
        desticationView.transform = CGAffineTransformIdentity;
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];

}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

@end
