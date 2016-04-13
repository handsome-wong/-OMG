//
//  YLWTitleScrollView.h
//  推库iOS
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YLWTitleScrollView;
@protocol YLWTitleScrollViewDelegate <NSObject>

-(void)titleScrollView:(YLWTitleScrollView *)titleScrollView WithTitleLabel:(UILabel *)titleLabel;

@end
@interface YLWTitleScrollView : UIScrollView

@property (nonatomic,strong) NSArray *titleModelArray;

@property (nonatomic,strong) id<YLWTitleScrollViewDelegate> titledelegate;

@end
