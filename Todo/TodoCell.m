//
//  TodoCell.m
//  Todo
//
//  Created by ltebean on 14/11/6.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "TodoCell.h"
@interface TodoCell()


@end

@implementation TodoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}



-(void) setup
{
 
    
}

-(void) setTodo:(NSDictionary *)todo
{
    _todo = todo;
    [self updateUI];
}

-(void) updateUI
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = self.textLabel.textAlignment;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName: paragraphStyle};
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.todo[@"content"]
                                                                         attributes:attributes];
    self.textLabel.attributedText = attributedText;
    
    CGRect frame = self.textLabel.frame;
    frame.size.height = [self requriedHeightForTodo:self.todo];
    self.textLabel.frame=frame;
}

-(CGFloat) requriedHeightForTodo:(NSDictionary*) todo;
{
    CGSize maximumLabelSize = CGSizeMake(self.textLabel.bounds.size.width,9999);
    
    CGSize expectedLabelSize = [todo[@"content"] sizeWithFont:[self.textLabel font] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    return expectedLabelSize.height+20;
    

}



@end
