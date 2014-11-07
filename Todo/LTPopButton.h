//
//  LTPopButton.h
//  LTPopButton
//
//  Created by ltebean on 14-8-28.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LTPopButtonType) {
    plusType,
    minusType,
    closeType,
    menuType,
    backType,
    forwardType
};

@interface LTPopButton : UIButton
@property (nonatomic) LTPopButtonType currentType;
@property (nonatomic, strong) UIColor *lineColor;
-(void) animateToType:(LTPopButtonType) type;
@end
