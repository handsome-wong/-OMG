//
//  SeminarSonViewController.m
//  teachingliteApple
//
//  Created by admin on 15/9/25.
//  Copyright (c) 2015年 com.futian. All rights reserved.
//

#import "SeminarSonViewController.h"
#import "MJRefresh.h"

#import "SeminarSonService.h"
#import "SeminarSonCell.h"
#import "util.h"
//#import "JSONKit.h"
#import "SeminarUrl.h"
//#import "UIImage+WM.h"
//#import "JudgeConnection.h"

#import "EGOCache.h"//数据缓存
#import "UIImageView+WebCache.h"//图片缓存

//#import "FCXRefreshHeaderView.h"
//#import "UIScrollView+FCXRefresh.h"
#import "BaseService.h"
//#import "OtherUserInfoViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#define  kCompressionQuality  0.4
@interface SeminarSonViewController ()<UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

@property NSArray *seminarSonList;

@property NSDictionary *seminarSonDic;

//记录要删除的行
@property (assign, nonatomic) NSInteger rowDeleted;

//帖子选择图片的image
@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) CGRect oldframe;
@property (weak, nonatomic) NSString *originImagePathString;
@property CGFloat originHight;

//键盘高度
@property (assign, nonatomic) NSInteger keyboardHeight;
@end

@implementation SeminarSonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //设置背景图片
//    [util setImageBackgroundWithImageView:_seminarSon_bg];
    
    //隐藏tabBar，sb的隐藏不知道为何会延时的
    self.tabBarController.tabBar.hidden = YES;
    
    //缓存
    NSString *courseKey = [[NSUserDefaults standardUserDefaults] objectForKey:COURSE_ID];
    NSString *parentKey = [[NSUserDefaults standardUserDefaults] objectForKey:SEMINAR_ID];
    NSString *seminarKey = [NSString stringWithFormat:@"%@%@%@",courseKey,parentKey,SEMINARSON];
    if ([[EGOCache globalCache] hasCacheForKey:seminarKey]) {
        _seminarSonList = [self getSeminarSonCache:seminarKey];//没网显示缓存
    }
    
//    if ([JudgeConnection isConnectionAvailable]) {
        //获取数据
        [self grabURLInBackground];
//    }
    
    //设置键盘监听
    [self setKeyboardAction];
    
    //监听背景图片，点击课缩回键盘
    [self.view setUserInteractionEnabled:YES];
    [self setSeminaerSonBackgroudImageViewClickWithView:self.view];
    
    //刷新
    [self refresh:self.seminarSonTableView];
}

#pragma mark -  数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _seminarSonList.count;
}

#pragma mark - cell显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //倒叙获取模型数据
    _seminarSonDic = [_seminarSonList objectAtIndex:indexPath.row];
    //创建单元格/xib
    SeminarSonCell *cell = [SeminarSonCell seminarSonCellWithTableView:tableView];
    
    [cell showSeminarSonCellWithDic:_seminarSonDic AndIndexPath:indexPath AndSelf:self];
    
    //判断是否为带图片的帖子,监听图片点击
    if (![Util isBlankString:[_seminarSonDic objectForKey:SEMINAR_IMAGEURL]]) {
      [self setImageClickWirhView:nil OrImageView:cell.seminarSonImageView];

    }
    
    cell.SeminarSonIcon.userInteractionEnabled = YES;
    [self setAvatorClickWithImageView:cell.SeminarSonIcon];
    
    
    //图片
    if (![Util isBlankString:[_seminarSonDic objectForKey:SEMINAR_IMAGEURL]]) {
        cell.seminarSonImageView.hidden = NO;
        
        NSMutableString *pathString = [[NSMutableString alloc] initWithString:[_seminarSonDic objectForKey:SEMINAR_IMAGEURL]];
        NSRange range = [pathString rangeOfString:@"." options:NSBackwardsSearch];
        NSURL* imagePath;//图片url
        if (range.location != NSNotFound && range.location > 60) {
            [pathString insertString:@"_small" atIndex:range.location];
            imagePath = [NSURL URLWithString:pathString];
        } else {
            imagePath = [NSURL URLWithString:[_seminarSonDic objectForKey:SEMINAR_IMAGEURL]];
        }
        
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imagePath.absoluteString];
        
        if (!image) {
            [cell.seminarSonImageView setImage:[UIImage imageNamed:IMAGE_EMPTY]];
            [self downloadThumbnailImageThenReload:imagePath];
        } else {
            [cell.seminarSonImageView setImage:image];
        }
        
        
    } else {
        cell.seminarSonImageView.hidden = YES;
    }
    
    //返回单元格
    return cell;
    
}


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
                                                              [_seminarSonTableView reloadData];
                                                          });
                                                          
                                                      }];
    
}

#pragma mark - 动态调整rowheight高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取模型数据
    _seminarSonDic = [_seminarSonList objectAtIndex:indexPath.row];
    NSString *title = [_seminarSonDic objectForKey:SEMINAR_TITLE];
    NSString *content = [Util decodeFromPercentEscapeString:[_seminarSonDic objectForKey:SEMINAR_CONTENT]];
    
    SeminarSonCell *cell = [SeminarSonCell seminarSonCellWithTableView:tableView];
    CGSize size = CGSizeMake(320,2000); //设置一个行高上限
    
    
    CGFloat textheight = 0;
      CGSize contentSize = [Util boundingRectWithSize:size
                                             AndLabel:cell.SeminarSonContent
                                              AndText:content];
    textheight = contentSize.height;
    if (![Util isBlankString:title]) {
        CGSize titleSize = [Util boundingRectWithSize:size
                                             AndLabel:cell.SeminarSonTitle
                                              AndText:[Util decodeFromPercentEscapeString:title]];
        textheight += titleSize.height;
    }

    //获取cell的rect 因为这是属于OC语句，下面.size.henght 属于C的语句
    CGRect rect;
    if ([Util isBlankString:[_seminarSonDic objectForKey:SEMINAR_IMAGEURL]] == NO) {
        NSLog(@"textheight=%f",textheight);
        if (textheight >= 600) {
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 300);
        } else {
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 180);
        }
        
    } else{
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 75);
        
    }
    return rect.size.height + textheight;
}




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
    //删除帖子的提示框
    if (alertView.tag == 0) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1: {
                //获取模型数据
                self.seminarSonDic = [self.seminarSonList objectAtIndex:_rowDeleted];
                NSString *seminarId = [self.seminarSonDic objectForKey:SEMINAR_ID];
                [self deleteSeminar:seminarId];
                //清空
                _rowDeleted = (long)NULL;
            }
                break;
                
            default:
                break;
        }

    }
    
    //发送帖子选择图片后的是否压缩的提示框
    if (alertView.tag == 1) {
        _deletePhotoBtn.hidden = NO;
        _photoView.hidden = NO;
        switch (buttonIndex) {
            case 0:
                _photoView.image = _image;
                _image = nil;//清空
                break;
            case 1: {
                [_photoView setImage:[UIImage imageWithData:[Util imageWithImage:_image]]];

                _image = nil;//清空
            }
                break;
                
            default:
                break;
        }

    }
    
}


#pragma mark - 删除数据
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取模型数据
    _seminarSonDic = [_seminarSonList objectAtIndex:indexPath.row];
    
    NSInteger result = [SeminarSonService showSeminarDeleteTipsWithDic:_seminarSonDic];
    
    return result;
}

#pragma mark - 头部长度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark - 修改颜色
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
}

#pragma mark - 修改cell点击效果，制作cell之间的空隙
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //去掉高亮效果
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
}


#pragma mark - cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.seminarSon_content resignFirstResponder];
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
        if ([message isEqualToString:SUCCESS]) {
            [self grabURLInBackground];
        }else{
            [Util toastWithView:self.view.window AndText:DELETE_FAILE];
        }
        //请求失败
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Util toastWithView:self.view.window AndText:ERROR];
    }];

    
}

#pragma mark - 从网络增加子贴
- (void)addSeminar : (NSString *)title :(NSString *)content :(NSString *)userId :(NSString *)courseId :(NSString *)parentId :(UIImage *)image {
    
    // AFHTTPSessionManager内部包装了NSURLSession
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //请求参数
    NSDictionary *params =@{COURSE_ID:courseId, SEMINAR_CONTENT:content, USER_ID:userId, SEMINAR_PARENT_ID:parentId};
    
    [sessionManager POST:ADD_SEMINAR_BY_FORM parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传图片
        if (image != nil) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:FILE fileName:@".jpg" mimeType:@"image/jpeg"];
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *message = [responseObject objectForKey:MESSAGE];
        if ([message isEqualToString:SUCCESS] == YES) {
            [Util toastWithView:self.view.window AndText:SUCCESS_SEND];
            [self grabURLInBackground];//刷新
            _photoView.image = nil;//清空
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [Util toastWithView:self.view.window AndText:ERROR];

    }];
    
}

#pragma mark - 网络获取数据
- (void)grabURLInBackground
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *parentId = [defaults objectForKey:SEMINAR_ID];
    
    // AFHTTPSessionManager内部包装了NSURLSession
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //请求参数
    NSDictionary *params =@{PARENT_ID:parentId, PAGESIZE:PAGE_SIZE_INT};
    //请求成功
    [sessionManager POST:GET_ROOT_AND_CHILD_SEMINARS_BY_PARENT_ID_AND_PAGE_PARAMS parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *message = [responseObject objectForKey:MESSAGE];
        if ([message isEqualToString:SUCCESS] == YES) {
            NSDictionary *resultMap = [responseObject objectForKey:RESULTMAP];
            _seminarSonList = [resultMap objectForKey:SEMINAR_LIST];
            //缓存
            NSString *courseKey = [[NSUserDefaults standardUserDefaults] objectForKey:COURSE_ID];
            NSString *parentKey = [[NSUserDefaults standardUserDefaults] objectForKey:SEMINAR_ID];
            NSString *seminarKey = [NSString stringWithFormat:@"%@%@%@",courseKey,parentKey,SEMINARSON];
            EGOCache *cache = [EGOCache globalCache];
            [cache removeCacheForKey:seminarKey];
            [cache setObject:_seminarSonList forKey:seminarKey];
            [_seminarSonTableView reloadData];
        }
        
        //请求失败
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Util toastWithView:self.view.window AndText:ERROR];
    }];
    
}


#pragma mark - 刷新
- (void)refresh:(UITableView *)tableView{
    // 下拉刷新
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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



#pragma mark - 加载更多数据
- (void)loadMoreSeminarByConnection{
    
    NSDictionary *seminarDic = [self.seminarSonList objectAtIndex:self.seminarSonList.count-1];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *parentId = [defaults objectForKey:SEMINAR_ID];
    NSString *seminarUpdateTime = [seminarDic objectForKey:SEMINAR_UPDATETIME];
    NSString *seminarId = [seminarDic objectForKey:SEMINAR_ID];
    
    // AFHTTPSessionManager内部包装了NSURLSession
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //请求参数
    NSDictionary *params =@{PARENT_ID:parentId, PAGESIZE:PAGE_SIZE_INT, SEMINAR_UPDATETIME:seminarUpdateTime, SEMINAR_ID:seminarId};
    //请求成功
    [sessionManager POST:GET_ROOT_AND_CHILD_SEMINARS_BY_PARENT_ID_AND_PAGE_PARAMS parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *message = [responseObject objectForKey:MESSAGE];
        if ([message isEqualToString:SUCCESS] == YES) {
            NSDictionary *resultMap = [responseObject objectForKey:RESULTMAP];
            NSMutableArray *moreArray = [resultMap objectForKey:SEMINAR_LIST];
            NSMutableArray *arrayHandle = [[NSMutableArray alloc] init];
            
            //删除多返回的主贴
            for (int i=0; i<moreArray.count; i++) {
                if (i != 0) {
                    [arrayHandle addObject:[moreArray objectAtIndex:i]];
                }
            }
            
            if (arrayHandle.count == 0 ) {
                [Util toastWithView:self.view.window AndText:LOAD_FINISH];
            }
            else{
                _seminarSonList = [_seminarSonList arrayByAddingObjectsFromArray:arrayHandle];
                [_seminarSonTableView reloadData];
            }
            
            
        }
        
        //请求失败
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [Util toastWithView:self.view.window AndText:ERROR];
    }];

    
}


#pragma mark - 缓存获取
- (NSArray *)getSeminarSonCache:(NSString *)key{
    id array = nil;
    array = [[EGOCache globalCache] objectForKey:key];
    return array;
}


#pragma mark - 发送帖子
- (IBAction)seminarSon_send:(id)sender {
    if ([Util isBlankString:_seminarSon_content.text]) {
        [Util toastWithView:self.view.window AndText:CONTENT_SPACE];
        //弹出toast
    }else{
        [self sendSemianrSonWithContent:_seminarSon_content.text];
    }
}


#pragma mark -注册键盘事件
- (void)setKeyboardAction{
    //增加监听，当键进入时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}



#pragma mark - 键盘进入时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    _keyboardHeight = keyboardHeight;
    
    float offset = -keyboardHeight;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    self.view.frame = rect;
    [UIView  commitAnimations];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    float offset = 0;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    self.view.frame = rect;
    [UIView  commitAnimations];
}

#pragma mark - 设置图头像可以点击并监听
- (void)setAvatorClickWithImageView:(UIImageView *)imageView{
    
    //单指单击
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerAvatorEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    //        singleFingerOne.delegate= self;
    [imageView addGestureRecognizer:singleFingerOne];
}


#pragma mark - 设置背景图片可以点击并监听
- (void)setSeminaerSonBackgroudImageViewClickWithView:(UIView *)UIView {
    //单指单击
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerBGEvent:)];
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    [UIView addGestureRecognizer:singleFingerOne];
}

//处理单指事件
- (void)handleSingleFingerBGEvent:(UITapGestureRecognizer *)sender
{
    if (sender.numberOfTapsRequired == 1) {
        [_seminarSon_content resignFirstResponder];
    }
}


#pragma mark - 设置图片可以点击并监听
- (void)setImageClickWirhView:(UIView *)myUIView OrImageView:(UIImageView *)imageView{
    
    //单指单击
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    //        singleFingerOne.delegate= self;
    [imageView addGestureRecognizer:singleFingerOne];
}


#pragma mark - 处理单指事件
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    if(sender.numberOfTapsRequired == 1) {
        UITableViewCell *cell = [SeminarSonService handleCellSuperViewForIOSVersion:sender];
        NSIndexPath *indexPath = [_seminarSonTableView indexPathForCell:cell];
        SeminarSonCell *seminarSonCell = (SeminarSonCell *)[_seminarSonTableView cellForRowAtIndexPath:indexPath];
        NSDictionary *dic = [_seminarSonList objectAtIndex:indexPath.row];
        NSString *imagePathString = [dic objectForKey:SEMINAR_IMAGEURL];
        _originImagePathString = imagePathString;
        //单指单击
        [self showImageWithImageView:seminarSonCell.seminarSonImageView AndImagePathString:imagePathString];
    } 
    
}


#pragma mark - 显示照片,传路径，加载大图
-(void)showImageWithImageView:(UIImageView *)photoImageView
           AndImagePathString:(NSString *)imagePathString {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                                     [UIScreen mainScreen].bounds.size.width,
                                                                     [UIScreen mainScreen].bounds.size.height)];
    self.oldframe = [photoImageView convertRect:photoImageView.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    backgroundView.tag = 10;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.oldframe];
    imageView.image = photoImageView.image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [self.view addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [self addGestureRecognizerToView:imageView];
    //如果处理的是图片，要
    [imageView setUserInteractionEnabled:YES];
    [imageView setMultipleTouchEnabled:YES];

    //添加保存按钮
    UIButton *saveAction = [[UIButton alloc]init];
    [saveAction setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-45, [UIScreen mainScreen].bounds.size.height-45, 30, 30)];
    [saveAction setImage:[UIImage imageNamed:@"saveImage_normal"] forState:UIControlStateNormal];
    [saveAction setImage:[UIImage imageNamed:@"saveImage_pressed"] forState:UIControlStateHighlighted];
    [saveAction addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:saveAction];
    
    //查看原图按钮
    UIButton *OriginPhotoAction = [[UIButton alloc]init];
    [OriginPhotoAction setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, [UIScreen mainScreen].bounds.size.height-70, 100, 75)];
    [OriginPhotoAction setTag:2];
    [OriginPhotoAction setTitle:@"查看原图" forState:UIControlStateNormal];
    [OriginPhotoAction setBackgroundImage:[UIImage imageNamed:@"btn_background"]  forState:UIControlStateNormal];
    [OriginPhotoAction addTarget:self action:@selector(showOriginImage) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:OriginPhotoAction];

    
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = CGRectMake(0,
                                   ([UIScreen mainScreen].bounds.size.height-photoImageView.image.size.height*[UIScreen mainScreen].bounds.size.width/photoImageView.image.size.width)/2,
                                   [UIScreen mainScreen].bounds.size.width,
                                   photoImageView.image.size.height*[UIScreen mainScreen].bounds.size.width/photoImageView.image.size.width);
        backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    //加载大图
    NSMutableString *pathString = [[NSMutableString alloc] initWithString:imagePathString];
    NSRange range = [pathString rangeOfString:@"." options:NSBackwardsSearch];
    if (range.location != NSNotFound && range.location > 60) {
        MBBarProgressView *progressView = [Util progress:self.view :nil];
        [pathString insertString:@"_large" atIndex:range.location];
       NSURL *imagePath = [NSURL URLWithString:pathString];
        [imageView sd_setImageWithURL:imagePath
                     placeholderImage:photoImageView.image options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         [imageView setImage:image];
                         progressView.hidden = YES;
                     }];
    }
 
}

#pragma mark - 隐藏
- (void)hideImage:(UITapGestureRecognizer*)tap {
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=self.oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

// 添加所有的手势
- (void) addGestureRecognizerToView:(UIImageView *)view
{
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    UIView *originView = pinchGestureRecognizer.view;
    NSLog(@"~~~~%f",originView.frame.size.height);

    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    
    if (_originHight == 0) {
        _originHight = view.frame.size.height;
    }

    if (pinchGestureRecognizer.scale > 1) {
        if (view.frame.size.height / _originHight <2 ) {
            if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
                view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
                pinchGestureRecognizer.scale = 1;
            }

        }
        
    } else {
        
        if (view.frame.size.height / _originHight >0.7) {
            
            if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
                view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
                pinchGestureRecognizer.scale = 1;
            }
            
        }

    }
    
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

//保存照片
- (void)saveImage:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [self.view viewWithTag:10];
        UIImageView *imageView = (UIImageView *)[view viewWithTag:1];
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
    });
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    if (error == nil) {
        [Util toastWithView:self.view.window AndText:@"保存成功"];
    }
    
}


//查看原图
- (void)showOriginImage {
    UIView *view = [self.view viewWithTag:10];
    UIImageView *imageView = [view viewWithTag:1];
    MBBarProgressView *progressView = [Util progress:self.view :nil];//加载原图进度条
    [imageView sd_setImageWithURL:[NSURL URLWithString:_originImagePathString]
                 placeholderImage:imageView.image options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                     if (imageURL != nil) {
                         [imageView setImage:image];
                     }
                     progressView.hidden = YES;
                     [view viewWithTag:2].hidden = YES;
                 }];
}


#pragma mark - 发送帖子方法
- (void)sendSemianrSonWithContent:(NSString *)contentText{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *parentId = [defaults objectForKey:SEMINAR_ID];
    NSString *userId = [defaults objectForKey:USER_ID];
    NSString *courseId = [defaults objectForKey:COURSE_ID];
    NSString *title = nil;
    NSString *content = [contentText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//加码
    [self addSeminar:title :content :userId :courseId :parentId :_photoView.image];
    
    _photoView.image = nil;
    _photoView.hidden = YES;
    _deletePhotoBtn.hidden = YES;
    _seminarSon_content.text = nil;

    [_seminarSon_content resignFirstResponder];//退出键盘
    
}

#pragma mark - 打开photo
- (void)getPhoto{
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:CANCEL
                                    destructiveButtonTitle:nil
                                    otherButtonTitles: PHOTO_CHOOSE, PHOTO_TAKE,nil];
    [myActionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self LocalPhoto];
            break;
        case 1:
            //拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}


//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
//    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
    } ];
}

//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        } ];
    }else {
        NSLog(PHOTO_TAKE_TIPS);
    }
}


#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    _image = image;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:IS_COMPRESS message:nil delegate:self cancelButtonTitle:ORIGIN otherButtonTitles:COMPRESS , nil];
    alertView.tag = 1;
    [alertView show];

    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
}


- (void)textViewDidChange:(UITextView *)textView {
//     CGSize size = CGSizeMake(320,2000); //设置一个行高上限
//    NSDictionary *attribute = @{NSFontAttributeName: textView.font};
//    CGFloat oldHeight = textView.frame.size.height/2;
//    CGSize retSize = [textView.text boundingRectWithSize:size
//                                        options:\
//                      NSStringDrawingTruncatesLastVisibleLine |
//                      NSStringDrawingUsesLineFragmentOrigin |
//                      NSStringDrawingUsesFontLeading
//                                     attributes:attribute
//                                        context:nil].size;
//    NSLog(@"----%f",retSize.height);
//    NSLog(@"====%f",oldHeight);
//    CGFloat newHeight = retSize.height - oldHeight;
//    
//    CGRect frame = textView.frame;
//    int offset = frame.origin.y +200- (self.view.frame.size.height - 120);//键盘高度216
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    float width = self.view.frame.size.width;
//    float height = self.view.frame.size.height;
////    if(offset > 0)
////    {
//    
//    CGRect rect = CGRectMake(0.0f, -_keyboardHeight - 20,width,height);
//        self.view.frame = rect;
////
//        CGRect barRect = CGRectMake(0.0f, _sendBarView.frame.origin.y, _sendBarView.frame.size.width, _sendBarView.frame.size.height+20);
//        _sendBarView.frame = barRect;
////    }
//    [UIView commitAnimations];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.view = nil;//清空view

}

- (IBAction)getSeminarSonPhoto:(id)sender {
    [_seminarSon_content resignFirstResponder];
    [self getPhoto];
}

- (IBAction)deletePhoto:(id)sender {
    _photoView.image = nil;
    _photoView.hidden = YES;
    _deletePhotoBtn.hidden = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


@end
