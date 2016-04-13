//
//  YLWDetailTextViewController.m
//  推库iOS
//
//  Created by Mac on 16/2/23.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import "YLWDetailTextViewController.h"
#import "YLWDetailTextModel.h"
#import "UIBarButtonItem+CustomByButton.h"
#import "YLWImageModel.h"
//#import <SDWebImageManager.h>
//#import <Masonry.h>



@interface YLWDetailTextViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic,strong) UIToolbar *toolbar;

@property (nonatomic,strong) UIImage *shareImage;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) YLWDetailTextModel *webModel;

@end

@implementation YLWDetailTextViewController

#pragma mark - 创建webview
-(void)creatWebview{
    
    
    UIWebView *webview = [[UIWebView alloc]init];
    self.webView = webview;
    self.webView.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1];
    [self.view addSubview:webview];
    webview.opaque = YES;
    webview.delegate = self;
//    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.left.right.equalTo(super.view);
//        make.bottom.equalTo(super.view.mas_bottom).mas_offset(-38);
//        
//    }];
    
}

#pragma mark - 添加底部toolbar
-(void)creatToolBar{

    UIToolbar *toolbar = [[UIToolbar alloc]init];
    
    self.toolbar = toolbar;
    toolbar.backgroundColor = [UIColor whiteColor];
    toolbar.barTintColor = [UIColor whiteColor];
    [self.view addSubview:toolbar];
    toolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-38, [UIScreen mainScreen].bounds.size.width, 38);
    UIBarButtonItem *wait = [UIBarButtonItem barButtonItemByCustomButtonWithImage:@"article_detail_late" highlightedImage:@"" target:self action:@selector(waitreadItemClick:)];
    UIBarButtonItem *save = [UIBarButtonItem barButtonItemByCustomButtonWithImage:@"star1" highlightedImage:@"star-on" target:self action:@selector(saveItemClick:)];
    UIBarButtonItem *share = [UIBarButtonItem barButtonItemByCustomButtonWithImage:@"upload" highlightedImage:@"upload" target:self action:@selector(shareItemClick)];
    UIBarButtonItem *comment = [UIBarButtonItem barButtonItemByCustomButtonWithImage:@"bottom_bar_comment" highlightedImage:@"bottom_bar_comment" target:self action:@selector(commentItemClick)];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    toolbar.items = @[wait,fixedSpace,save,fixedSpace,share,fixedSpace,comment];

}

#pragma mark 待读按钮的点击事件
-(void)waitreadItemClick:(UIButton *)item{
    
    if(item.selected){
        NSLog(@"取消待读");
        item.selected = NO;
        [item setImage:[UIImage imageNamed:@"article_detail_late"] forState:UIControlStateNormal];
    }else{
        NSLog(@"待读");
        item.selected = YES;
        [item setImage:[UIImage imageNamed:@"article_detail_late_on"] forState:UIControlStateNormal];
        
        
    }
    
    
    
    
    
}
#pragma mark 收藏按钮的点击事件
-(void)saveItemClick:(UIButton *)item{

    
    if(item.selected){
        NSLog(@"取消收藏");
        item.selected = NO;
        [item setImage:[UIImage imageNamed:@"star1"] forState:UIControlStateNormal];
    }else{
        NSLog(@"收藏");
        item.selected = YES;
        [item setImage:[UIImage imageNamed:@"star-on"] forState:UIControlStateNormal];
        
        
    }
    
    

}
#pragma mark 分享按钮的点击事件
-(void)shareItemClick{

    NSLog(@"分享");
    //1、创建分享参数
    }
#pragma mark 评论按钮的点击事件
-(void)commentItemClick{

    NSLog(@"评论");

}

#pragma mark - 试图生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"正文";
    
    [self creatWebview];
    
    [self creatToolBar];
    
}



#pragma mark 获取数据
//赋值之后加载获取数据模型 拼接html webview加载html
-(void)setDetailTextId:(NSString *)detailTextId{
    
    _detailTextId = detailTextId;
    
    __weak typeof(self) weakself = self;
    [YLWDetailTextModel detileNewsModelGetWithdetailTextId:detailTextId success:^(YLWDetailTextModel *model) {
        
        weakself.webModel = model;
        
        NSURL *file = [[NSBundle mainBundle] URLForResource:@"article_detail.html" withExtension:nil];
        
        
        NSString *htmlstring = [NSString stringWithContentsOfURL:file encoding:NSUTF8StringEncoding error:nil];
        
        
        //替换内容中的img
        NSString *contensHtmlString = model.content;
        
        contensHtmlString = [self getImageWith:contensHtmlString imageArray:model.images];
        
        htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"%@title" withString:model.title];
        htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"%@feed" withString:model.feed_title];
        htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"%@time" withString:model.time];
        
        htmlstring = [htmlstring stringByReplacingOccurrencesOfString:@"%@content" withString:contensHtmlString];
        
        
        NSLog(@"%@",contensHtmlString);
        
        [self.webView loadHTMLString:htmlstring baseURL:file];
        
        
        
    }];
    
   
}


-(NSString *)getImageWith:(NSString *)contensHtmlString imageArray:(NSArray *)images{

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img\\ssrc[^>]*/>" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:contensHtmlString options:NSMatchingReportCompletion range:NSMakeRange(0, contensHtmlString.length)];
    
    NSMutableArray *num = [NSMutableArray array];
    
    for (NSTextCheckingResult *item in result) {
    
         NSString * imgHtml = [contensHtmlString substringWithRange:[item rangeAtIndex:0]];
        
        [num addObject:imgHtml];
    
    }
    
    //循环遍历得到的结果
    for (int i = 0; i < num.count; i++) {
        //从内容中截取出图片的url链接<img ars = ...> 用来匹配查找
        NSString *imgHtml = num[i];
        for (YLWImageModel *imageModel in images) {
            
            //说明找到了对应的模型数据
            if ([imgHtml rangeOfString:imageModel.image_id].location != NSNotFound) {
                
                
                CGFloat newW = imageModel.w > self.webView.bounds.size.width -20 ? self.webView.bounds.size.width -20 : imageModel.w;
                
                NSString *newimgHtml = [NSString stringWithFormat:@"<img src=\"%@\" width = '%.0f' class=\"alignCenter\" />",imageModel.src,newW];
                
                contensHtmlString = [contensHtmlString stringByReplacingOccurrencesOfString:imgHtml withString:newimgHtml];
                
           
            }
    
        }
    
    }

    return contensHtmlString;

}

#pragma mark - webview的代理方法

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    

    return YES;
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{


}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    




}

//-(void)text{

//#pragma mark - 在这里面的代码会造成重复加载的图片 webview会加载一次 然后自己又加载一次;
//    NSLog(@"--------------开始---------------");
//    //获取img url 的数组;
//    NSString *imagesArrayString = [self.webView stringByEvaluatingJavaScriptFromString:@"var imagearray = document.getElementsByTagName('img');var imgstr = '';function f(){for(var i = 0;i<imagearray.length;i++){imgstr +=imagearray[i].src;imgstr +=';';}return imgstr;}f();"];
//    NSLog(@"图片----%@",imagesArrayString);
//    NSMutableArray *images = (NSMutableArray *)[imagesArrayString componentsSeparatedByString:@";"];
//    [images removeLastObject];
//    
//    //
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    for (int i = 0; i < images.count; i++){
//        NSString *imgurlString = images[i];
//        NSLog(@"%@",imgurlString);
//        
//        for (YLWImageModel *imageModel in self.webModel.images) {
//            
//            if ([imgurlString containsString:imageModel.image_id]) {
//                NSURL *imageUrl = [NSURL URLWithString:imgurlString];
//                CGFloat newW = imageModel.w > (self.webView.bounds.size.width-15) ? (self.webView.bounds.size.width-15) :imageModel.w;
//                
//                
//                if ([manager diskImageExistsForURL:imageUrl]) {
//                    
//                    NSString *path = [manager.imageCache defaultCachePathForKey:[manager cacheKeyForURL:imageUrl]];
//                    NSString *js = [NSString stringWithFormat:@"var imagearray = document.getElementsByTagName('img');imagearray[%d].src = \"%@\";imagearray[%d].width=\"%0.f\";",i,path,i,newW];
//                    [self.webView stringByEvaluatingJavaScriptFromString:js];
//                    
//                    
//                }else{
//                    
//                    
//                    [manager downloadImageWithURL:imageUrl options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                        
//                        if (image && finished) {
//                            NSString *path = [manager.imageCache defaultCachePathForKey:[manager cacheKeyForURL:imageUrl]];
//                            NSString *js = [NSString stringWithFormat:@"var imagearray = document.getElementsByTagName('img');imagearray[%d].src = \"%@\";imagearray[%d].width=\"%0.f\";",i,path,i,newW];
//                            [self.webView stringByEvaluatingJavaScriptFromString:js];
//                            
//                        }
//                        
//                    }];
//                    
//                    
//                    
//                }
//                
//                
//                
//            }
//            
//        }
//        
//        
//        
//        
//        
//    }
//    
//    NSLog(@"--------------结束---------------");
//
//}


@end
