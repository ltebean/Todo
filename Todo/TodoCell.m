//
//  TodoCell.m
//  Todo
//
//  Created by ltebean on 14/11/6.
//  Copyright (c) 2014年 ltebean. All rights reserved.
//

#import "TodoCell.h"
#import "Settings.h"

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
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}



- (void)setup
{

}

- (void)setTodo:(NSDictionary *)todo
{
    _todo = todo;
    [self updateUI];
}

- (void)updateUI
{
    self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:self.todo[@"content"] attributes:[TodoCell textAttributes]];
}

- (void)didWantToDelete
{
    [self.delegate todoCell:self didRemoveTodo:self.todo];
}



+ (CGFloat)requriedHeightForTodo:(NSDictionary*) todo;
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, 9999);
    CGFloat height = [todo[@"content"] boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[TodoCell textAttributes] context:nil].size.height + 30;
    return MAX(60, ceil(height));
}

+ (NSDictionary *)textAttributes
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    return @{
             NSFontAttributeName: [UIFont fontWithName:[Settings fontFamily] size:16],
             NSParagraphStyleAttributeName: paragraphStyle
             };
}

@end
