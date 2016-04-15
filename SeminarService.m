//
//  SeminarService.m
//  teachingliteApple
//
//  Created by admin on 15/11/4.
//  Copyright (c) 2015年 com.huagongguangzhouxueyuan. All rights reserved.
//

#import "SeminarService.h"

@implementation SeminarService

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

@end
