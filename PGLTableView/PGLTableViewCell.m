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
@property (nonatomic, weak) UIView *separatorLine;
@end

@implementation PGLTableViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        self.textLabel = label;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
        self.separatorLine = line;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.separatorLine.frame = CGRectMake(0, self.frame.size.height - .5, self.frame.size.width, .5);
    self.textLabel.frame = CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 20);
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        self.textLabel.text = text;
    }
}
@end
