//
//  PGLTableViewCell.h
//  PGLTableView
//
//  Created by Paul on 16/8/23.
//  Copyright © 2016年 PGL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGLTableViewCell : UIView
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic, copy) NSString *text;
@end
