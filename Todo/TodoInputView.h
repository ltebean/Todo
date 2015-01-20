//
//  TodoInputView.h
//  Todo
//
//  Created by Yu Cong on 14-11-7.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TodoInputView;

@protocol TodoInputViewDelegate <NSObject>
- (void)todoInputView:(TodoInputView *)inputView didAddTodo:(NSDictionary *)todo withType:(NSString *) type;
- (void)todoInputViewDidShow;
- (void)todoInputViewDidHide;
@end

@interface TodoInputView : UIView
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (nonatomic) BOOL shown;
@property (nonatomic,weak) id<TodoInputViewDelegate> delegate;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view withType:(NSString *)type;

- (void)hide;
@end
