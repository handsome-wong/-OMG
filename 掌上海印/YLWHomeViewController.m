//
//  YLWHomeViewController.m
//  推库iOS
//
//  Created by Mac on 16/2/17.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import "YLWHomeViewController.h"
#import "YLWDetailTextViewController.h"
//#import "YLWSearchViewController.h"
#import "SeminarSonViewController.h"
@interface YLWHomeViewController ()

@end

@implementation YLWHomeViewController


#pragma mark - 视图的生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(push:) name:@"push" object:nil];
    
    self.titleModelArray = [YLWTitleModel titleModelGetModelArrayWith:@"titleArray.plist"];
    
    [self setUI];
    
    
    
}

- (void)push:(id *)arr {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Seminar" bundle:nil];
    SeminarSonViewController *vc = [story instantiateViewControllerWithIdentifier:@"SeminarSonViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}



#pragma mark - 设置导航栏
/**
 *  设置导航栏
 */
-(void)setNav{

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtn)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more1"] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtn)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;

}
///**
// *  导航栏搜索(左侧)按钮
// */
//-(void)searchBtn{
//    NSLog(@"搜索");
//    YLWSearchViewController *searchVC = [[YLWSearchViewController alloc]init];
//    
//    YLWNavigationController *nav = [[YLWNavigationController alloc]initWithRootViewController:searchVC];
//    
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
//
//}
/**
 *  导航栏更多(右侧)按钮
 */
-(void)moreBtn{

    NSLog(@"更多");
}

//#pragma mark - push到详细页面的通知方法
//-(void)pushToDetailText:(NSNotification *)notification{
//
//    YLWDetailTextViewController *detail = [[YLWDetailTextViewController alloc]init];
//    
//    detail.hidesBottomBarWhenPushed = YES;
//    
//    detail.detailTextId = notification.userInfo[YLWDetailTextIdKeyd];
//    
//    [self.navigationController pushViewController:detail animated:YES];
//    
//
//}


#pragma mark - contentCollectionView的代理方法和数据源方法


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
