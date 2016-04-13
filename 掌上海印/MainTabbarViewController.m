//
//  MainTabbarViewController.m
//  掌上海印
//
//  Created by admin on 16/4/13.
//  Copyright © 2016年 handsome. All rights reserved.
//

#import "MainTabbarViewController.h"

@implementation MainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addChildViewControllers];
    
    
}

-(void)addChildViewControllers{
    

    
    MessageViewController *message = [[MessageViewController alloc]init];
    [self addChildViewController:message WithTitle:@"消息" image:@"tab_site"];
    
    DepartmentViewController *depart = [[DepartmentViewController alloc]init];
    [self addChildViewController:depart WithTitle:@"部门" image:@"tab_dis"];

    
    SignViewController *sign = [[SignViewController alloc]init];
    [self addChildViewController:sign WithTitle:@"签到" image:@"tab_topic"];
    
    YLWHomeViewController *homeVc = [[YLWHomeViewController alloc]init];
    [self addChildViewController:homeVc WithTitle:@"论坛" image:@"toolbar-barSwitch"];
    
    
    UserViewController *user = [[UserViewController alloc]init];
    [self addChildViewController:user WithTitle:@"我" image:@"tab_user"];
    
    
}


-(void)addChildViewController:(UIViewController *)childController WithTitle:(NSString *)title image:(NSString *)imageName{
    
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    
    childController.title = title;
    
    YLWNavigationController *nav = [[YLWNavigationController alloc]initWithRootViewController:childController];
    
    [self addChildViewController:nav];
    
}


@end
