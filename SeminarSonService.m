//
//  SeminarSonService.m
//  teachingliteApple
//
//  Created by admin on 15/11/4.
//  Copyright (c) 2015年 com.huagongguangzhouxueyuan. All rights reserved.
//

#import "SeminarSonService.h"

@implementation SeminarSonService

//封装显示左滑样式
+ (NSInteger)showSeminarDeleteTipsWithDic:(NSDictionary *)dic {
    NSInteger result;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *UserId = [dic objectForKey:USER_ID];
    
    if ([UserId isEqual:[defaults objectForKey:USER_ID]]) {
        result = UITableViewCellEditingStyleDelete;
    }else{
        result = UITableViewCellAccessoryNone;
    }
    
    return result;
}

#pragma mark - 第一个参数为限定size 第二个为需要计算的textView 第三个为textView的内容 返回算出的size
+ (CGSize)boundingRectWithSize:(CGSize)size :(UITextView *)textView :(NSString *)text
{
    NSDictionary *attribute = @{NSFontAttributeName: textView.font};
    
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
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



@end
