//
//  YLWBasesHomeViewController.m
//  推库iOS
//
//  Created by Mac on 16/3/3.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import "YLWBasesHomeViewController.h"



#define contentIdentifier @"contentCollectionViewIdentifier"
@interface YLWBasesHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,YLWTitleScrollViewDelegate>




@end

@implementation YLWBasesHomeViewController

#pragma mark - 懒加载
-(NSArray *)titleModelArray{
    
    if (_titleModelArray == nil) {
        _titleModelArray = [[NSArray alloc]init];
        
    }
    return _titleModelArray;
    
}

-(YLWTitleScrollView *)titleScrollView{
    
    if (_titleScrollView == nil) {
        _titleScrollView = [[YLWTitleScrollView alloc]initWithFrame:CGRectMake(5, 64, YLWScreenWidth, 37)];
        _titleScrollView.titleModelArray = self.titleModelArray;
        _titleScrollView.titledelegate = self;
    }
    
    return _titleScrollView;
}

-(UICollectionViewFlowLayout *)flowLayout{
    
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize = self.contentCollectionView.bounds.size;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
    }
    return  _flowLayout;
}

-(YLWContentCollectionView *)contentCollectionView{
    
    if (_contentCollectionView == nil) {
        _contentCollectionView = [[YLWContentCollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleScrollView.frame), YLWScreenWidth, YLWScreenheight-CGRectGetMaxY(self.titleScrollView.frame)-49) collectionViewLayout:self.flowLayout];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.pagingEnabled = YES;
        //        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        NSLog(@"%ld",self.titleModelArray.count);
        for (int i = 0; i <self.titleModelArray.count; i ++) {
            [_contentCollectionView registerClass:[YLWCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%d",contentIdentifier,i]];
            
        }
        //        [_contentCollectionView registerClass:[YLWCollectionViewCell class] forCellWithReuseIdentifier:contentIdentifier];
        
    }
    return _contentCollectionView;
}

#pragma mark - 视图的生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
}



#pragma mark - 设置子控件
-(void)setUI{
    
    
    [self.view addSubview:self.titleScrollView];
    
    [self.view addSubview:self.contentCollectionView];
    
}


#pragma mark - contentCollectionView的代理方法和数据源方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%ld",(unsigned long)self.titleModelArray.count);
    return self.titleModelArray.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YLWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%d",contentIdentifier,(int)indexPath.row] forIndexPath:indexPath];
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor yellowColor];
    }else{
        cell.backgroundColor = [UIColor greenColor];
    }
    
    YLWTitleModel *model = self.titleModelArray[indexPath.row];
    
    cell.urlstring = model.urlstring;
    cell.title = model.title;
    
    NSLog(@"%@",model.urlstring);
    
    return cell;
    
    
}

#pragma mark - titleScrollViewDelegate的代理方法

-(void)titleScrollView:(YLWTitleScrollView *)titleScrollView WithTitleLabel:(UILabel *)titleLabel{
//    titleLabel.frame = CGRectMake(100, titleLabel.frame.origin.y, titleLabel.frame.size.width, titleLabel.frame.size.height);
    NSInteger i = titleLabel.tag;
    UILabel *lastlabel = self.titleScrollView.subviews[self.lastIndex];
    lastlabel.textColor = [UIColor blackColor];
    titleLabel.textColor = [UIColor colorWithRed:22.0/255.0 green:147.0/255.0 blue:114.0/255.0 alpha:1.0];
    self.lastIndex = i;
    [self.contentCollectionView setContentOffset:CGPointMake(i *YLWScreenWidth, 0) animated:NO];
    
}


#pragma mark - 上下联动的实现


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    int currentIndex = self.contentCollectionView.contentOffset.x /self.contentCollectionView.bounds.size.width;
    NSLog(@"%d",currentIndex);
    
    UILabel *lastlabel = self.titleScrollView.subviews[self.lastIndex];
    lastlabel.textColor = [UIColor blackColor];
    UILabel *titlelabel = self.titleScrollView.subviews[currentIndex];
    titlelabel.textColor = [UIColor colorWithRed:22.0/255.0 green:147.0/255.0 blue:114.0/255.0 alpha:1.0];
    self.lastIndex = currentIndex;
    //选中的label居中
    CGFloat needscrollX = titlelabel.center.x - self.titleScrollView.bounds.size.width*0.5;
    NSLog(@"needscrollX=%f",needscrollX);
    //最大的偏移量
//    CGFloat maxScrollX = self.titleScrollView.contentSize.width - self.titleScrollView.bounds.size.width/3;
    CGFloat maxScrollX = 0.0;
    NSLog(@"maxScrollX=%f",maxScrollX);
    
    if (needscrollX < 0) {
        
        needscrollX = 0;
    }
    
    if (needscrollX > maxScrollX) {
        needscrollX = maxScrollX;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(needscrollX, 0) animated:NO];
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

