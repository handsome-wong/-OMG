//
//  YLWContentTableViewController.m
//  推库iOS
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import "YLWContentTableViewController.h"
#import "YLWArticleModel.h"
#import "YLWNewsTableViewCell.h"
#import "YLWDetailTextViewController.h"
//#import <Masonry.h>
@interface YLWContentTableViewController ()
@property (nonatomic,strong) NSMutableArray *articleModelArray;

@property (nonatomic,assign) BOOL islogin;

@property (nonatomic,strong) UIView *coverView;
@end

@implementation YLWContentTableViewController

-(UIView *)coverView{

    if (_coverView == nil) {
        _coverView = [[UIView alloc]init];
        _coverView.backgroundColor = [UIColor redColor];
        _coverView.frame = self.view.bounds;
        
    }
    return _coverView;
}

#pragma mark - 懒加载
-(NSMutableArray *)articleModelArray{

    if (_articleModelArray == nil) {
        _articleModelArray = [[NSMutableArray alloc]init];
    }
    return _articleModelArray;
}

#pragma mark - 视图生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.islogin = [YLWUserLoginModel sharedUserLoginModel].isLogin;

    self.tableView.rowHeight = 73;
    
    
     
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        [self getData];
//        [self.tableView.mj_header endRefreshing];
//        
//    }];
    
//    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        
//        [self footGetData];
//        
//        [self.tableView.mj_footer endRefreshing];
//        
//    }];

//    [self getNetWorkstate];
//    
//    [self getData];
    
}
//
//-(void)getNetWorkstate{
//    
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"未识别的网络");
//                break;
//                
//            case AFNetworkReachabilityStatusNotReachable:{
//                NSLog(@"不可达的网络(未连接)");
//                UIAlertController *ale = [UIAlertController alertControllerWithTitle:@"网络不正常" message:@"当前无网络" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *ac = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//                [ale addAction:ac];
//                [self presentViewController:ale animated:YES completion:nil];
//            break;}
//        
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"2G,3G,4G...的网络");
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"wifi的网络");
//                break;
//            default:
//                break;
//        }
//        
//        
//        
//    }];
//    [manager startMonitoring];
//    
//    
//    
//}


-(void)footGetData{
    
    YLWArticleModel *lastModel = [self.articleModelArray lastObject];
    
    NSDictionary *par = [[NSDictionary alloc]init];
    if (lastModel) {
        
        par = @{
                @"last_id":lastModel.id,
                @"last_time":lastModel.uts
                };
        
    }
    
    if (!self.urlstring) {
        return;
    }
    
    __weak typeof(self) weakself = self;
    [YLWArticleModel articleModelGetDataWithURLString:self.urlstring title:self.titlename parameters:nil successblack:^(NSArray *modelArray) {
        
        [weakself.articleModelArray  addObjectsFromArray:modelArray];
        
        [weakself.tableView reloadData];
        
    }];
    
    
    
}


-(void)viewDidAppear:(BOOL)animated{
//只是在第一次显示的时候加载  之后都是重用
    [super viewDidAppear:animated];
    NSLog(@"显示");
    
    
        
    
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    NSLog(@"消失");
}

//-(void)getData{
//
//    __weak typeof(self) weakself = self;
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    if (!manager.isReachable) {
//        
//        if ([self.titlename isEqualToString:@"热门"]) {
//            
//            [self.articleModelArray addObjectsFromArray:[YLWArticalTool Articalsback]];
//            
//            [self.tableView reloadData];
//            
//        }
//        
//        
//    }else {
//
//        if (!self.urlstring) {
//            return;
//        }
//        [YLWArticleModel articleModelGetDataWithURLString:self.urlstring title:self.titlename parameters:nil successblack:^(NSArray *modelArray) {
//            
//            if (self.coverView) {
//                [weakself.coverView removeFromSuperview];
//            }
//            
//            [weakself.articleModelArray removeAllObjects];
//            [weakself.articleModelArray addObjectsFromArray:modelArray];
//            
//            [weakself.tableView reloadData];
//
//            
//            
//        }];
//    
//    
//    }
//    
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.articleModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YLWArticleModel *model = self.articleModelArray[indexPath.item];
    
    NSString *ID = @"";
    if (model.img.length > 0) {
        
        ID = @"YLWNewsTableViewCell";
        
    }else{
    
        ID = @"YLWNewsTableViewCell1";
    
    }
    YLWNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        if ([ID isEqualToString:@"YLWNewsTableViewCell"]) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YLWNewsTableViewCell" owner:nil options:nil] lastObject];
        }else{
        
            cell = [[[NSBundle mainBundle] loadNibNamed:@"YLWNewsTableViewCell" owner:nil options:nil] firstObject];
            
        }
        
    }
    
    
    cell.articleModel = model;
    
    return cell;
}

#pragma mark 按钮的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    YLWArticleModel *model = self.articleModelArray[indexPath.row];
    
    
    
    if (self.navigationController) {
        
        YLWDetailTextViewController *detail = [[YLWDetailTextViewController alloc]init];
        
//        detail.hidesBottomBarWhenPushed = YES;
        
        detail.detailTextId = model.id;
        
        [self.navigationController pushViewController:detail animated:YES];

        
    }else{
    
//        [[NSNotificationCenter defaultCenter]postNotificationName:YLWPushToDetailTextVCNotification object:nil userInfo:@{YLWDetailTextIdKeyd:model.id}];
    
    }
    
    
    
    
    
    
}





@end
