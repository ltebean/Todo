//
//  TodoInputView.h
//  Todo
//
//  Created by Yu Cong on 14-11-7.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoInputView : UIView
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property BOOL shown;
-(void) show;
-(void) hide;
-(void) toggle;
@end
