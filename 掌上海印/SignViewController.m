//
//  SignViewController.m
//  掌上海印
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 handsome. All rights reserved.
//

#import "SignViewController.h"
#import "SYQRCodeViewController.h"
@implementation SignViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];



}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    [cell.imageView setImage:[UIImage imageNamed:@"discover-scan"]];
    [cell.textLabel setText:@"扫一扫"];
    cell.selected = YES;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
        //扫描二维码
        SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
        qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
            //        self.saomiaoLabel.text = qrString;
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
        };
        qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
            //        self.saomiaoLabel.text = @"fail~";
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
        };
        qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
            [aqrvc dismissViewControllerAnimated:NO completion:nil];
            //        self.saomiaoLabel.text = @"cancle~";
        };
    [self.navigationController pushViewController:qrcodevc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
