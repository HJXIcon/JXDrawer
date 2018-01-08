//
//  RightViewController.m
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import "RightViewController.h"
#import "NextTableViewController.h"
#import "UIViewController+JXDrawer.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *const cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"section == %ld,row == %ld",indexPath.section,indexPath.row];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NextTableViewController *vc = [[NextTableViewController alloc]init];
    [self jx_pushViewController:vc ];
    
}


@end
