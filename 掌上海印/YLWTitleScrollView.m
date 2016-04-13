//
//  YLWTitleScrollView.m
//  推库iOS
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import "YLWTitleScrollView.h"
#import "YLWTitleModel.h"
#define titleCount 7
//#define titleLabelWidth [UIScreen mainScreen].bounds.size.width *1.0/ titleCount

@implementation YLWTitleScrollView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
       
//        self.backgroundColor = [UIColor redColor];
        self.showsHorizontalScrollIndicator = NO;
        
    }

    return self;
}

-(void)setTitleModelArray:(NSArray *)titleModelArray{

    _titleModelArray = titleModelArray;
    CGFloat titleLabelWidth = 0;
    if (titleModelArray.count == 3) {
        titleLabelWidth  = [UIScreen mainScreen].bounds.size.width *1.0/ 3;
        
    }else{
    
        titleLabelWidth  = [UIScreen mainScreen].bounds.size.width *1.0/ 7;
    
    }
    
    for (int i = 0; i <titleModelArray.count; i++) {
        YLWTitleModel *titleModel = titleModelArray[i];
        
        CGFloat titleLabelX = i * titleLabelWidth;
        CGFloat titleLabelY = 0;
        CGFloat titleLabelHight = self.frame.size.height;
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.tag = i;
        titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelWidth, titleLabelHight);
        titleLabel.text = titleModel.title;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)]];
        if (i == 0) {
            titleLabel.textColor = [UIColor colorWithRed:22.0/255.0 green:147.0/255.0 blue:114.0/255.0 alpha:1.0];
        }
        
        [self addSubview:titleLabel];
        
    }
    
    self.contentSize = CGSizeMake(titleModelArray.count *titleLabelWidth, self.frame.size.height);
    

}

-(void)titleLabelClick:(UITapGestureRecognizer *)recognizer{

    UILabel *label = (UILabel *)recognizer.view;
    
    if ([self.titledelegate respondsToSelector:@selector(titleScrollView:WithTitleLabel:)]) {
        
        [self.titledelegate titleScrollView:self WithTitleLabel:label];
        
    }

}


@end
