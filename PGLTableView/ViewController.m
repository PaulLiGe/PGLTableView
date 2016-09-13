//
//  ViewController.m
//  PGLTableView
//
//  Created by Paul on 16/8/12.
//  Copyright © 2016年 PGL. All rights reserved.
//

#import "ViewController.h"
#import "PGLTableView.h"
#import "PGLTableViewCell.h"

@interface ViewController () <PGLTableViewDataSource, UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PGLTableView *tableView = [[PGLTableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView reloadData];
    [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfRows {
    return 61;
}

- (CGFloat)heightForRowInPGLTableView {
    return 54;
}

- (PGLTableViewCell *)pgtableView:(PGLTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static int i = 0;
    PGLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ligeceshi"];
    if (cell == nil) {
        cell = [[PGLTableViewCell alloc] init];
        cell.reuseIdentifier = @"ligeceshi";
        i++;
        NSLog(@"______%d", i);
    }
    
    return cell;
}
@end
