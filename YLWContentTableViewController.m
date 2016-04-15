//
//  SeminarViewController.m
//  teachingliteApple
//
//  Created by admin on 15/9/24.
//  Copyright (c) 2015年 com.futian. All rights reserved.
//

#import "YLWContentTableViewController.h"
#import "MJRefresh.h"
#import "YLWHomeViewController.h"
#import "SeminarCell.h"
#import "util.h"
//#import "JSONKit.h"
#import "SeminarUrl.h"
#import "YLWNavigationController.h"
#import "EGOCache.h"//数据缓存
#import "UIImageView+WebCache.h"//图片缓存
#import "BaseService.h"
#import "SeminarService.h"
//#import "OtherUserInfoViewController.h"
#import "SeminarSonService.h"
#import "AFNetworking.h"
#import "SeminarSonViewController.h"

@interface YLWContentTableViewController ()<NSURLConnectionDataDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property NSMutableArray *seminarList;

@property NSMutableDictionary *seminarDic;

@property NSInteger rowDeleted;

@property UIButton *addLikeButton;
@end

@implementation YLWContentTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"8a2a820f4fde749b014fde7941cc0007" forKey:USER_ID];
    [defaults setValue:@"8aacc7f84fde7f68014fde819f2f0003"forKey:COURSE_ID];
    

    
    //    [_SeminarTableView registerNib:[UINib nibWithNibName:@"SeminarCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    //    [_SeminarTableView registerClass:[SeminarCell class] forCellReuseIdentifier:@"Cell"];
    
    //获取缓存
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"Coures_ID"];
    NSString *seminarKey = [NSString stringWithFormat:@"%@%@",key,@"Seminar"];
    if ([[EGOCache globalCache] hasCacheForKey:seminarKey]) {
        _seminarList = (NSMutableArray *)[self getSeminarCache:seminarKey];//没网显示缓存
    }
    
    //有网络时获取数据
//    if ([JudgeConnection isConnectionAvailable]) {
        //获取数据
        [self grabURLInBackground];
//    }
    
    //添加上下拉刷新
    [self refresh:self.tableView];
}


#pragma mark -  数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _seminarList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //获取模型数据
    _seminarDic = [_seminarList objectAtIndex:indexPath.row];
    
    //创建单元格/xib
    SeminarCell *cell = [SeminarCell seminarCellWithTableView:tableView AndIndex:indexPath];
    [cell.SeminarImageView setImage:nil];
    [cell.seminarLikeButton addTarget:self action:@selector(addLike:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //cell显示
    [cell showSeminarCellWithDic:_seminarDic];
    
    //图片
    if (![Util isBlankString:[_seminarDic objectForKey:SEMINAR_IMAGEURL]]) {
        cell.SeminarImageView.hidden = NO;
        
        NSMutableString *pathString = [[NSMutableString alloc] initWithString:[_seminarDic objectForKey:SEMINAR_IMAGEURL]];
        NSRange range = [pathString rangeOfString:@"." options:NSBackwardsSearch];
        NSURL* imagePath;//图片url
        if (range.location != NSNotFound && range.location > 60) {
            [pathString insertString:@"_small" atIndex:range.location];
            imagePath = [NSURL URLWithString:pathString];
        } else {
            imagePath = [NSURL URLWithString:[_seminarDic objectForKey:SEMINAR_IMAGEURL]];
        }
        
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imagePath.absoluteString];
        //        [cell.SeminarImageView setImage:image];
        
        if (!image) {
            [cell.SeminarImageView setImage:[UIImage imageNamed:IMAGE_EMPTY]];
            
            //有网络时获取数据
//            if ([JudgeConnection isConnectionAvailable]) {
                //获取数据
                [self downloadThumbnailImageThenReload:imagePath];
//            }
            
        } else {
            [cell.SeminarImageView setImage:image];
        }
        
        
    } else {
        cell.SeminarImageView.hidden = YES;
    }
    
    //返回单元格
    return cell;
    
}

#pragma mark - 下载图片

- (void)downloadThumbnailImageThenReload:(NSURL *)imagePath
{
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:imagePath
                                                        options:SDWebImageDownloaderUseNSURLCache
                                                       progress:nil
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                          
                                                          [[SDImageCache sharedImageCache] storeImage:image forKey:imagePath.absoluteString toDisk:YES];
                                                          
                                                          // 单独刷新某一行会有闪烁，全部reload反而较为顺畅
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              //                                                                                                                        tweet.cellHeight = 0;
                                                              [self.tableView reloadData];
                                                          });
                                                          
                                                      }];
    
}



#pragma mark - 头部长度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


#pragma mark - 修改颜色
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}

#pragma mark - 修改cell点击效果，制作cell之间的空隙
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //去掉高亮效果
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

#pragma mark - 动态调整rowheight高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取模型数据
    _seminarDic = [_seminarList objectAtIndex:indexPath.row];
    //获取cell的rect 因为这是属于OC语句，下面.size.henght 属于C的语句
    CGRect rect ;
    if ([Util isBlankString:[_seminarDic objectForKey:SEMINAR_IMAGEURL]] == NO) {
        
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 190);
        
    }else{
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 100);
        
    }
    return rect.size.height;
    
}

#pragma mark - 删除数据
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //获取模型数据
    _seminarDic = [_seminarList objectAtIndex:indexPath.row];
    
    NSInteger result = [SeminarService showSeminarDeleteTipsWithDic:_seminarDic];
    
    return result;
}

#pragma mark - 显示左滑文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  _DELETE;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //记录要删除的行
    _rowDeleted = indexPath.row;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:DELETE_CONFIRM message:nil delegate:self cancelButtonTitle:CANCEL otherButtonTitles:SURE, nil];
    [alertView show];
    
    
}


#pragma mark - 删除提示对话框点击
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    switch (buttonIndex) {
        case 0:
            break;
        case 1: {
            //获取模型数据
            _seminarDic = [_seminarList objectAtIndex:_rowDeleted];
            NSString *seminarId = [self.seminarDic objectForKey:SEMINAR_ID];
            [self deleteSeminar:seminarId];
            //清空
            _rowDeleted = (long)NULL;
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 网络获取数据
- (void)grabURLInBackground
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *courseId = @"8aacc7f84fde7f68014fde819f2f0003";
    NSString *userId = @"8a2a820f4fde749b014fde7941cc0007";
    
    // AFHTTPSessionManager内部包装了NSURLSession
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //请求参数
    NSDictionary *params =@{COURSE_ID:courseId, PAGESIZE:PAGE_SIZE_INT, USER_ID:userId};
    NSLog(@"params=%@",params);
    NSLog(@"url=%@",GET_ROOT_SEMINARS_BY_COURSE_ID_AND_PAGE_PARAMS);
    //请求成功
    [sessionManager POST:GET_ROOT_SEMINARS_BY_COURSE_ID_AND_PAGE_PARAMS parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *message = [responseObject objectForKey:MESSAGE];
        if ([message isEqualToString:SUCCESS] == YES) {
            NSDictionary *resultMap = [responseObject objectForKey:RESULTMAP];
            _seminarList = [resultMap objectForKey:SEMINAR_LIST];
            
            //缓存
            NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:COURSE_ID];
            NSString *seminarKey = [NSString stringWithFormat:@"%@%@",key,SEMINAR];
            EGOCache *cache = [EGOCache globalCache];
            [cache removeCacheForKey:seminarKey];//清空原来的
            [cache setObject:_seminarList forKey:seminarKey];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
        //请求失败
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Util toastWithView:self.view AndText:ERROR];
    }];
    
}




#pragma mark - 从网络删除帖子
- (void)deleteSeminar :(NSString *)seminarId {
    
    // AFHTTPSessionManager内部包装了NSURLSession
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //请求参数
    NSDictionary *params =@{SEMINAR_ID:seminarId};
    //请求成功
    [sessionManager POST:DELETE_SEMINAR parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *message = [responseObject objectForKey:MESSAGE];
        if ([message isEqualToString:SUCCESS] == YES) {
            [self grabURLInBackground];
        }
        
        //请求失败
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Util toastWithView:self.view.window AndText:ERROR];
    }];
    
    
}


#pragma mark - 跳转下一页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取模型数据
        NSDictionary *seminarDic = [_seminarList objectAtIndex:indexPath.row];
        //存储数据
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[seminarDic objectForKey:SEMINAR_ID] forKey:SEMINAR_ID];
        //设置同步
        [defaults synchronize];
        if (self.navigationController) {

            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Seminar" bundle:nil];
            SeminarSonViewController *vc = [story instantiateViewControllerWithIdentifier:@"SeminarSonViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:nil];
        }
        
    });
    
    
    
    
}

#pragma mark - 没从缓存获取
- (NSArray *)getSeminarCache:(NSString *)key{
    id array = nil;
    array = [[EGOCache globalCache] objectForKey:key];
    return array;
}


#pragma mark - 刷新
- (void)refresh:(UITableView *)tableView{
    // 下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self grabURLInBackground];
        });
        [tableView.header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self loadMoreSeminarByConnection];
        });
        [tableView.footer endRefreshing];
        
        
        
    }];
}

#pragma mark - 数据请求
- (void)loadMoreSeminarByConnection{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *courseId = [defaults valueForKey:COURSE_ID];
    NSString *userId = [defaults objectForKey:USER_ID];
    NSDictionary *seminarDic = _seminarList[_seminarList.count-1];
    NSString *seminarUpdateTime = [seminarDic objectForKey:SEMINAR_UPDATETIME];
    NSString *seminarId = [seminarDic objectForKey:SEMINAR_ID];
    
    // AFHTTPSessionManager内部包装了NSURLSession
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //请求参数
    NSDictionary *params =@{COURSE_ID:courseId, PAGESIZE:PAGE_SIZE_INT, USER_ID:userId, SEMINAR_UPDATETIME:seminarUpdateTime, SEMINAR_ID:seminarId};
    //请求成功
    [sessionManager POST:GET_ROOT_SEMINARS_BY_COURSE_ID_AND_PAGE_PARAMS parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *message = [responseObject objectForKey:MESSAGE];
        if ([message isEqualToString:SUCCESS] == YES) {
            NSDictionary *resultMap = [responseObject objectForKey:RESULTMAP];
            NSArray *moreArray = [resultMap objectForKey:SEMINAR_LIST];
            _seminarList = (NSMutableArray *)[_seminarList arrayByAddingObjectsFromArray:moreArray];
            if (!(moreArray.count >0) ) {
                [Util toastWithView:self.view.window AndText:LOAD_TIPS];
            }
            [self.tableView reloadData];
            
        }
        
        //请求失败
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Util toastWithView:self.view.window AndText:ERROR];
    }];
    
}

//点赞
- (void)addLike:(id)sender {
    
    //ios7获取父控件只需要
    _addLikeButton = (UIButton *)sender;
    SeminarCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] == 7) {
        cell = (SeminarCell *)_addLikeButton.superview.superview.superview;
    } else {
        cell = (SeminarCell *)_addLikeButton.superview.superview;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    _seminarDic = [_seminarList objectAtIndex:indexPath.row];
    NSString *semianrId = [_seminarDic valueForKey:SEMINAR_ID];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:USER_ID];
    
    // AFHTTPSessionManager内部包装了NSURLSession
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //请求参数
    NSDictionary *params =@{USER_ID:userId, SEMINAR_ID:semianrId};
    //请求成功
    [sessionManager POST:ADD_OR_DELETE_SEMINARLIKE_BY_SEMINARID_AND_USERID parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *message = [responseObject objectForKey:MESSAGE];
        if ([message isEqualToString:SUCCESS] == YES) {
            
            //本地点赞更新
            SeminarCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            _seminarList = [SeminarCell addOrCancelLikeWithCell:cell AndSeminarDic:_seminarDic AndRow:indexPath.row AndArray:_seminarList];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"row=%ld",indexPath.row);
                NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:reloadIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            });
            
            
        }
        //请求失败
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Util toastWithView:self.view.window AndText:ERROR];
    }];
    
    
}



#pragma mark - 发送帖子返回刷新
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:IS_REFRESH] isEqualToString:IS_YES]) {
        [defaults setObject:IS_NO forKey:IS_REFRESH];
        [self grabURLInBackground];
    }
    
}

#pragma mark - 返回course
- (IBAction)seminarBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 前往发送讨论
- (IBAction)seminarSend:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tabBarController.tabBar.hidden = YES;
        [self performSegueWithIdentifier:SEMINAR_GO_SEMINARSEND sender:nil];
    });
}

//视图将要消失时设置tabBar不显示
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
    
}

@end
