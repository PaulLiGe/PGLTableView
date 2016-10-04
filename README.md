# iOS开发-UITableView的底层实现
平时比较忙，十一闲下来终于有时间写点东西，这篇文章记录对tableView的一些思考。提到tableView相信大家都非常熟悉，它是我们开发中最常见的控件之一,继承自scrollView（ [UIScrollView的底层实现看这里](http://www.jianshu.com/p/a9a1ca54ca54) ）。它是个非常神奇的控件，仿佛有无穷无尽的子控件，在它之上可以显示成千上万行cell，却不会导致内存飙升，界面卡顿。但如果tableView真的创建了成千上万个cell，就可能导致各种问题。它是如何做到盛放成千上万的子控件而不卡顿、内存不爆表? 

相信大家都知道它的核心在于使用了重用机制，但是它是如何实现的？相信大部分人还是理解的不太清楚、不够深刻。下面我将带大家一起实现一个简易的tableView，重点放在 **重用机制** 的实现。读完这篇文章相信大家能对tableView有一个更加深刻的认识。

###cell 的重用
cell的重用，使用**享元模式**。下边带领大家一步步实现重用机制，由于本人能力有限，我尽量用简短的语言写的通俗易懂，如果您觉得写的不好，也请不要喷我。
> 首先tableView肯定继承自UIScrollView，在UIScrollView滑动的时候我们需要不停的检查是否有新的cell进入界面需要显示，旧的cell离开界面需要移除。这一步我们可以通过重写layoutSubviews或者setContentOffset方法来实现，然后在此方法中首先我们需要计算当下要显示第几行到第几行的cell，然后拿到需要显示的cell放在界面,最后移除离开屏幕的cell。下面我们来一步一步实现。

* 计算需要显示第几行:一个全局的数组中存放的是一个个存储cell信息的对象，这些对象中包括cell开始位置、高度、以及所属的indexPath。我们能通过遍历或者二分查找快速找到当下需要显示的cell的开始行和结束行。二分查找的时间复杂度是：O()=O(logn)，10000次查找最多也只需要14次，所以我们采用二分查找，因为在Foundation框架中有对二分查找的封装，我们直接采用就行，当然也可以自己实现。代码如下：

````
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
if (endIndex > 0) endIndex--;

return NSMakeRange(startIndex, endIndex - startIndex + 1);
}
````

* 判断要显示的cell是否已经在界面上，如不在从cellForRow方法中获取cell，cellForRow首先会从重用池中查找对应标识符的cell，如果找到从缓存池中移除，如果找不到重新创建，然后添加在界面上，代码如下：

````
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
}

}
// 从重用池中获取cell
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

````

* 判断cell是否已经离开屏幕，如果离开就从屏幕上移除，加入重用池。代码如下：

````
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

````

以上就是**重用机制**的实现，如果不懂可以在[这里](https://github.com/PaulLiGe/PGLTableView)看详细代码。

**总结：**当然tableView有许多强大的功能，我们只是演示了一个简单的重用机制，比如各种代理以及数据源方法，有时间我会尽量补充，如果感兴趣你可以尝试去实现它，我相信对你来说应该是个小问题。