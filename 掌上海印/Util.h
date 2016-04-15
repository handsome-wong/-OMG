//
//  util.h
//  Test-云课堂
//
//  Created by admin on 15/9/12.
//  Copyright (c) 2015年 handsome. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface Util : NSObject


+ (UIImage *)getImageFromURL:(NSString *)fileURL;

//判断是否为空
+ (BOOL) isBlankString:(NSString *)string;

+ (void)toastWithView:(UIView *)view AndText:(NSString *)text;

// 算出发布时间距离现在，如几分钟前
+ (NSString *)intervalSinceNow: (NSString *) theDate;

//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

//进度条
+ (id)progress:(UIView *)view :(NSString *)text ;


//圆头像
+ (void)setRoundImageView:(UIImageView *)imageView;

//获取版本
+ (float)getIOSVersion;

//utf8解码，空格解码
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;
//封装背景图片，传进imageView
+ (void)setImageBackgroundWithImageView:(UIImageView *)imageView;

//写进沙盒
+ (void)writeToFileWithImage:(UIImage *)image;

//图片大小压缩
+ (NSData *)imageWithImage:(UIImage*)image;

#pragma mark - 因为ios7和ios8、9获取superView的方式不同，所以做一个版本判断
+ (UITableViewCell *)handleCellSuperViewForIOSVersion :(UITapGestureRecognizer *)sender;

#pragma mark - 第一个参数为限定size 第二个为需要计算的label 第三个为label的内容 返回算出的size
+ (CGSize)boundingRectWithSize:(CGSize)size AndLabel:(UILabel *)label AndText:(NSString *)text;

//获取当前时间
+ (NSString *)getCurrentTime;

#pragma mark 正则表达式识别手机号码
+ (BOOL) validateMobile:(NSString *)phoneNumber;

@end

