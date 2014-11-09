//
//  AreaView.h
//  Todo
//
//  Created by ltebean on 14/11/5.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TodoAreaView;
@protocol AreaViewDelegate <NSObject>
- (void)  didTappedAreaView:(TodoAreaView*) areaView withTodo:(NSDictionary*) todo;
@end

typedef NS_ENUM(NSInteger, Type) {
    typeA,
    typeB,
    typeC,
    typeD,
};

@interface TodoAreaView : UIView
@property(nonatomic,weak) id<AreaViewDelegate> delegate;
@property(nonatomic) Type type;
-(void) refreshData;
@end;
