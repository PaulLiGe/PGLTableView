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

@interface ViewController () <PGLTableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PGLTableView *tableView = [[PGLTableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource = self;
    [tableView reloadData];
    [self.view addSubview:tableView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

- (NSInteger)numberOfRows {
    return 60;
}

- (CGFloat)heightForRowInPGLTableView {
    return 60;
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
    cell.text = [NSString stringWithFormat:@"%@", cell];
    return cell;
}


@end
