//
//  SeminarSonService.h
//  teachingliteApple
//
//  Created by admin on 15/11/4.
//  Copyright (c) 2015年 com.huagongguangzhouxueyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "util.h"
#import "BaseService.h"

@interface SeminarSonService : NSObject

//封装显示左滑样式
+ (NSInteger)showSeminarDeleteTipsWithDic:(NSDictionary *)dic;


#pragma mark - 第一个参数为限定size 第二个为需要计算的textView 第三个为textView的内容 返回算出的size
+ (CGSize)boundingRectWithSize:(CGSize)size :(UITextView *)textView :(NSString *)text;

#pragma mark - 因为ios7和ios8、9获取superView的方式不同，所以做一个版本判断
+ (UITableViewCell *)handleCellSuperViewForIOSVersion :(UITapGestureRecognizer *)sender;

@end
