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

-(NSInteger)numberOfSection
{
    return 3;
}


- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)heightForRowInPGLTableViewIndexPath:(NSIndexPath*)indexPath {
    return 250;
}

- (PGLTableViewCell *)pgtableView:(PGLTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static int i = 0;
    PGLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ligeceshi"];
    if (cell == nil) {
        cell = [[PGLTableViewCell alloc] init];
        cell.reuseIdentifier = @"ligeceshi";
        
        i++;
        cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1.0];
    }
    
    return cell;
}
@end
