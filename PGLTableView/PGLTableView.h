//
//  PGLTableView.h
//  PGLTableView
//
//  Created by Paul on 16/8/12.
//  Copyright © 2016年 PGL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGLTableView, PGLTableViewCell;

@protocol PGLTableViewDataSource <NSObject>

- (NSInteger)numberOfSection;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (CGFloat)heightForRowInPGLTableViewIndexPath:(NSIndexPath*)indexPath;

- (PGLTableViewCell *)pgtableView:(PGLTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PGLTableView : UIScrollView
@property (nonatomic, weak) id <PGLTableViewDataSource> dataSource;

- (void)reloadData;

- (PGLTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
