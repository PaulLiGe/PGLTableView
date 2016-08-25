//
//  PGLTableViewCell.m
//  PGLTableView
//
//  Created by Paul on 16/8/23.
//  Copyright © 2016年 PGL. All rights reserved.
//

#import "PGLTableViewCell.h"

@interface PGLTableViewCell ()
@property (nonatomic, weak) UILabel *textLabel;
@end

@implementation PGLTableViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 10)];
        view.backgroundColor = [UIColor orangeColor];
        [self addSubview:view];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
        [self addSubview:label];
        self.textLabel = label;
//        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        self.textLabel.text = text;
    }
}
@end
