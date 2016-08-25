//
//  PGLTableView.m
//  PGLTableView
//
//  Created by Paul on 16/8/12.
//  Copyright © 2016年 PGL. All rights reserved.
//

#import "PGLTableView.h"
#import "PGLTableViewCell.h"
#import "PGLRowDetail.h"

@interface PGLTableView ()
//@property (nonatomic, strong) NSMutableDictionary *reusePool;
@property (nonatomic, strong) NSMutableArray *rowRecords;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableIndexSet *visibleRows;
@property (nonatomic, strong) NSMutableDictionary *visibleCells;


@property (nonatomic, strong) NSMutableSet *reusePool;
@end

@implementation PGLTableView
#warning 在何时调用加载所有高度的方法最合适？
#warning nsset跟nsarray的区别是啥？


#pragma mark - public
- (PGLTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    PGLTableViewCell *reuseCell = nil;
    for (PGLTableViewCell *cell in self.reusePool) {
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            reuseCell = cell;
            break;
        }
    }
    if (reuseCell) {
        [self.reusePool removeObject:reuseCell];
    }
    return reuseCell;
}

- (void)reloadData {
    [self countRowsPosition];
//    [self layoutPGLTableView];
}

#pragma mark - private
- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutPGLTableView];
}

- (void)layoutPGLTableView {
    CGFloat startY = self.contentOffset.y;
    CGFloat endY = self.contentOffset.y + self.bounds.size.height;
    
    NSRange range = [self searchRowNumberWillShowInPGLTableView:startY y:endY];
    
    for (NSUInteger i = range.location; i < range.location + range.length; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PGLTableViewCell *cell = [self.visibleCells objectForKey:@(i)];
        if (cell == nil) {
            // 如果取自重用池，就从重用池出列
            cell = [self.dataSource pgtableView:self cellForRowAtIndexPath:indexPath];
            [self.visibleCells setObject:cell forKey:@(i)];
            PGLRowDetail *detail = self.rowRecords[i];
            cell.frame = CGRectMake(0, detail.startY, self.frame.size.width, detail.rowHeight);
            [self addSubview:cell];
        }
        
    }
    NSDictionary *visibleCells = [self.visibleCells copy];
    
    
    NSArray *allVisibleCells = [visibleCells allKeys];
    for (NSNumber *numb in allVisibleCells) {
        if (!NSLocationInRange([numb intValue], range)) {
            PGLTableViewCell *cell = [self.visibleCells objectForKey:numb];
            [self.reusePool addObject:cell];
            [self.visibleCells removeObjectForKey:numb];
            [cell removeFromSuperview];
        }
    }
    
    
    
//    for (int i = 0; i < allVisibleCells.count; i++) {
////        NSIndexPath *indexPath = ;
//        PGLRowDetail *detail = self.rowRecords[[allVisibleCells[i] intValue]];
//        UITableViewCell *cell = [visibleCells objectForKey:allVisibleCells[i]];
//        NSLog(@"%@", [NSThread currentThread]);
//        if (detail.startY + detail.rowHeight < startY || detail.startY > endY) {
//            
//            [self.reusePool addObject:cell];
//            [self.visibleCells removeObjectForKey:@(i)];
//            [cell removeFromSuperview];
//        }
//    }
    
    
    // 计算当下需要显示的cell的行数
//    do {
//        PGLRowDetail *rowDetail = self.rowRecords[rowToDisplay];
//        UITableViewCell *cell = [self.dataSource pgtableView:self cellForRowAtIndexPath:nil];
//        cell.frame = CGRectMake(0, rowDetail.startY, self.bounds.size.width, rowDetail.rowHeight);
//        [self addSubview:cell];
//        rowToDisplay++;
//    } while ();
    
//    for (NSInteger i = rowToDisplay; i < self.rowRecords.count; i ++) {
//        PGLRowDetail *rowDetail = self.rowRecords[i];
//        if (rowDetail.startY <= endY) {
//            UITableViewCell *cell = [self.dataSource pgtableView:self cellForRowAtIndexPath:nil];
//            cell.frame = CGRectMake(0, rowDetail.startY, self.bounds.size.width, rowDetail.rowHeight);
//            [self addSubview:cell];
//        }
//    }
    

    // 离开屏幕的放入缓存池
}

- (void)countRowsPosition {
    CGFloat startY = self.contentOffset.y;
    CGFloat totalHeight = startY;
    if ([self.dataSource respondsToSelector:@selector(numberOfRows)]) {
        NSInteger rowCount = [self.dataSource numberOfRows];
        for (int i = 0; i < rowCount; i++) {
            CGFloat height = 44;
            if ([self.dataSource respondsToSelector:@selector(heightForRowInPGLTableView)]) {
                height = [self.dataSource heightForRowInPGLTableView];
            }
            totalHeight += height;
            PGLRowDetail *rowDetail = [[PGLRowDetail alloc] init];
            rowDetail.startY = startY;
            rowDetail.rowHeight = height;
            startY = startY + height;
            [self.rowRecords addObject:rowDetail];
        }
    }
    self.contentSize = CGSizeMake(self.frame.size.width, totalHeight);
}

- (void)putIntoReusePool {
    
}

// 计算将要显示的是第几行
- (NSRange)searchRowNumberWillShowInPGLTableView:(CGFloat)x y:(CGFloat)y {
    
//    CGFloat offSetY = self.contentOffset.y;
//    NSUInteger i = 0, j = self.rowRecords.count;
//    NSUInteger middle = (i + j) / 2;
//    
//    // 二分查找
//    do {
//        PGLRowDetail *leftRow = self.rowRecords[i];
//        PGLRowDetail *middleRow = self.rowRecords[middle];
//        PGLTableView *rightRow = self.rowRecords[j];
//        if (offSetY > middleRow.startY) {
//            
//        }
//    } while (i < j);
//
//    return 8;
    CGFloat startY = x;
    CGFloat endY = y;
    __block NSUInteger startIndex = 0;
    __block NSUInteger endIndex = 0;
    
    [self.rowRecords enumerateObjectsUsingBlock:^(PGLRowDetail *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.startY + obj.rowHeight > startY) {
            startIndex = idx;
            *stop = YES;
        }
    }];

    [self.rowRecords enumerateObjectsUsingBlock:^(PGLRowDetail *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.startY + obj.rowHeight >= endY) {
            endIndex = idx;
            *stop = YES;
        }
    }];

    return NSMakeRange(startIndex, endIndex - startIndex + 1);
}

#pragma mark - property
- (NSMutableSet *)reusePool {
    if (_reusePool == nil) {
        _reusePool = [NSMutableSet set];
    }
    return _reusePool;
}

- (NSMutableArray *)rowRecords {
    if (_rowRecords == nil) {
        _rowRecords = [NSMutableArray array];
    }
    return _rowRecords;
}

- (NSMutableDictionary *)visibleCells {
    if (_visibleCells == nil) {
        _visibleCells = [NSMutableDictionary dictionary];
    }
    return _visibleCells;
}
@end
