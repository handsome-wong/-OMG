//
//  util.m
//  Test-云课堂
//
//  Created by admin on 15/9/12.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "Util.h"
#import "MBProgressHUD.h"
#define DURATION 0.7f

@implementation Util


+ (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}


+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//toast
+ (void)toastWithView:(UIView *)view AndText:(NSString *)text{
     MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
//        HUD.yOffset = 80.0f;
//        HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

//进度条
+ (id)progress:(UIView *)view :(NSString *)text{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.progress = 0.5;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(5);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    return HUD;
}
//
//+ (id)showProgressWithView:(UIView *)view AndText:(NSString *)text {
//
////    hud.labelText = @"text";
////    [hud show:YES];
////    [MBProgressHUD showHUDAddedTo:view animated:YES];
//
//}


+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        if ([timeString  isEqual: @"0分钟前"]) {
            timeString = @"刚刚";
        }
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha/86400>1)
    {
//        timeString = [NSString stringWithFormat:@"%f", cha/86400];
//        timeString = [timeString substringToIndex:timeString.length-7];
//        timeString=[NSString stringWithFormat:@"%@天前", timeString];
        timeString = theDate;
        
    }
    return timeString;
}

#pragma mark - 压缩图片大小
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark - 圆头像 imageViewFloat 为
+ (void)setRoundImageView:(UIImageView *)imageView {
    //圆头像
//    imageView.image = nil;
//    imageView.layer.masksToBounds = YES;
//    imageView.layer.cornerRadius = imageViewFloat;
    CALayer  *lay = imageView.layer;
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:imageView.bounds.size.width/2];

}

#pragma mark - 获取IOS版本
+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


//utf8解码，空格解码
+ (NSString *)decodeFromPercentEscapeString:(NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


+ (void)setImageBackgroundWithImageView:(UIImageView *)imageView {
    imageView = nil;
    NSString *imageUrl = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"background.png"];
    [imageView setImage:[UIImage imageWithContentsOfFile:imageUrl]];

}

+ (void)writeToFileWithImage:(UIImage *)image {
    NSString *imagePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"background.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:imagePath atomically:NO];

}

+ (NSData *)imageWithImage:(UIImage*)image
{

    CGSize newSize = CGSizeMake(image.size.width/2, image.size.height/2);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}

#pragma mark - 因为ios7和ios8、9获取superView的方式不同，所以做一个版本判断
+ (UITableViewCell *)handleCellSuperViewForIOSVersion :(UITapGestureRecognizer *)sender{
    UITableViewCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] integerValue] == 7) {
        cell = (UITableViewCell *)[[[sender.view superview] superview] superview];
    } else{
        cell = (UITableViewCell *)[[sender.view superview] superview];
    }
    
    return cell;
}


#pragma mark - 第一个参数为限定size 第二个为需要计算的label 第三个为label的内容 返回算出的size
+ (CGSize)boundingRectWithSize:(CGSize)size AndLabel:(UILabel *)label AndText:(NSString *)text
{
    NSDictionary *attribute = @{NSFontAttributeName: label.font};
    
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}

+ (NSString *)getCurrentTime {
    NSDateFormatter *foematter = [[NSDateFormatter alloc] init];
    [foematter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateTime = [foematter stringFromDate:[NSDate date]];
    return dateTime;
}

#pragma mark 正则表达式识别手机号码
+ (BOOL) validateMobile:(NSString *)phoneNumber{
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}


@end
