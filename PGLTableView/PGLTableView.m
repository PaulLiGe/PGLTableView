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
@property (nonatomic, strong) NSMutableArray *rowRecords;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableIndexSet *visibleRows;
@property (nonatomic, strong) NSMutableDictionary *visibleCells;


@property (nonatomic, strong) NSMutableSet *reusePool;
@end

@implementation PGLTableView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutPGLTableView];
}

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
}

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
}

#pragma mark - private
// 布局cell
- (void)layoutPGLTableView {
    // 计算要显示的是哪些行
    CGFloat startY = self.contentOffset.y;
    CGFloat endY = self.contentOffset.y + self.bounds.size.height;
    NSRange range = [self numberOfRowsWillShowInPGLTableView:startY end:endY];
    // 放置需要显示的cell
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PGLTableViewCell *cell = [self.visibleCells objectForKey:@(i)];
        if (cell == nil) {
            cell = [self.dataSource pgtableView:self cellForRowAtIndexPath:indexPath];
            [self.visibleCells setObject:cell forKey:@(i)];
            PGLRowDetail *detail = self.rowRecords[i];
            cell.frame = CGRectMake(0, detail.startY, self.frame.size.width, detail.rowHeight);
            [self addSubview:cell];
            [self sendSubviewToBack:cell];//防止一开始cell会挡住滚动条
        }
        
    }
    
    // 移除离开屏幕的cell,同时放入重用池
    NSArray *allVisibleCells = [self.visibleCells allKeys];
    for (NSNumber *numb in allVisibleCells) {
        if (!NSLocationInRange([numb integerValue], range)) {
            PGLTableViewCell *cell = [self.visibleCells objectForKey:numb];
            [self.reusePool addObject:cell];
            [self.visibleCells removeObjectForKey:numb];
            [cell removeFromSuperview];
        }
    }
}

// 计算cell的行数，以及cell的开始位置和高度，同时修改scrollview的contentsize
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

// 计算将要显示的是第几行到第几行
- (NSRange)numberOfRowsWillShowInPGLTableView:(CGFloat)start end:(CGFloat)end {
    PGLRowDetail *startDetail = [[PGLRowDetail alloc] init];
    startDetail.startY = start;
    PGLRowDetail *endDetail = [[PGLRowDetail alloc] init];
    endDetail.startY = end;
    
    NSInteger startIndex = [self.rowRecords indexOfObject:startDetail inSortedRange:NSMakeRange(0, self.rowRecords.count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(PGLRowDetail * obj1, PGLRowDetail * obj2) {
        if (obj1.startY < obj2.startY) return NSOrderedAscending;
        return NSOrderedDescending;
    }];
    if (startIndex > 0) startIndex--;
    
    NSInteger endIndex = [self.rowRecords indexOfObject:endDetail inSortedRange:NSMakeRange(0, self.rowRecords.count - 1) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(PGLRowDetail * obj1, PGLRowDetail * obj2) {
        if (obj1.startY < obj2.startY) return NSOrderedAscending;
        return NSOrderedDescending;
    }];
//    if (endIndex > 0) endIndex--; //防止cell少一行
    
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


/*
 // C语言级别的二分查找(时间复杂度可以表示O()==log2n(2为底数)=O(logn))，查找数值的左右界限
 // 左边
 int locationLeftIndexWithArray(float *array) {
 int low = 0, high = sizeof(array) / sizeof(float);
 int middle = (high+low+1)/2;
 
 while (low < high) {
 if (array[middle] >= 1.5) {
 high = middle - 1;
 } else if (array[middle] < 1.5) {
 low = middle;
 }
 middle = (high+low+1)/2;
 }
 return middle;
 }
 // 右边
 int locationRightIndexWithArray(float *array) {
 int low = 0, high = 3;
 int middle = sizeof(array) / sizeof(float);
 
 while (low < high) {
 if (array[middle] >= 1.5) {
 high = middle;
 } else if (array[middle] < 1.5) {
 low = middle + 1;
 }
 middle = (low + high) / 2;
 }
 return middle;
 }
 // oc版本
 - (NSInteger)indexWithArray:(NSArray *)array {
 NSInteger index = [array indexOfObject:@8 inSortedRange:NSMakeRange(0, array.count - 1) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
 if (obj1 < obj2) {
 return NSOrderedAscending;
 }
 return NSOrderedDescending;
 }];
 if (index == 0) return 0;
 return index - 1;
 }
 */
@end
