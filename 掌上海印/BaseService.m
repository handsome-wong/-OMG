//
//  BaseService.m
//  teachingliteApple
//
//  Created by admin on 15/11/4.
//  Copyright (c) 2015年 com.huagongguangzhouxueyuan. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService

//头像显示问题
+ (void)showAvatarWithDic:(NSDictionary *)dic
             forImageView:(UIImageView *)imageView {
    if ([Util isBlankString:[dic objectForKey:USER_IMAGEURL]]) {
        if ([[dic objectForKey:USER_SEX] isEqual:USER_SEX_1]) {
            [imageView setImage:[UIImage imageNamed:USER_ICON_MALE]];
        }else{
            [imageView setImage:[UIImage imageNamed:USER_ICON_FEMALE]];
        }
    }else{
        NSURL* imagePath = [NSURL URLWithString:[dic objectForKey:USER_IMAGEURL]];
        [imageView sd_setImageWithURL:imagePath placeholderImage:[UIImage imageNamed:USER_ICON_NULL]];
    }
}

//头像显示问题
+ (void)showAvatarWithUserSex:(NSString *)userSex
                 UserImageUrl:(NSString *)userImageUrl
             forImageView:(UIImageView *)imageView {
    if ([userImageUrl isEqualToString:@" "]) {
        if ([userSex isEqual:USER_SEX_1]) {
            [imageView setImage:[UIImage imageNamed:USER_ICON_MALE]];
        }else{
            [imageView setImage:[UIImage imageNamed:USER_ICON_FEMALE]];
        }
    }else{
//        NSURL* imagePath = [NSURL URLWithString:userImageUrl];
//        [imageView sd_setImageWithURL:imagePath];
        
        NSMutableString *pathString = [[NSMutableString alloc] initWithString:userImageUrl];
        NSRange range = [pathString rangeOfString:@"." options:NSBackwardsSearch];
        NSURL* imagePath;//图片url
        if (range.location != NSNotFound && range.location > 60) {
            [pathString insertString:@"_small" atIndex:range.location];
            imagePath = [NSURL URLWithString:pathString];
        } else {
            imagePath = [NSURL URLWithString:userImageUrl];
        }
        
        [imageView sd_setImageWithURL:imagePath placeholderImage:[UIImage imageNamed:IMAGE_EMPTY]];
        
    }
}


#pragma mark - 设置性别
+ (NSString *)getUserSexWithSexString:(NSString *)sex{
    if([sex isEqualToString:USER_SEX_0]){
        return FEMALE;
    }else{
        return MALE;
    }
}
@end
