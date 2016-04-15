//
//  SeminarCell.m
//  Test-云课堂
//
//  Created by admin on 15/9/18.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "SeminarCell.h"
//#import "SeminarViewController.h"
//#import "UIImageView+AsyncDownload.h"

@implementation SeminarCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (instancetype)seminarCellWithTableView:(UITableView *)tableView AndIndex:(NSIndexPath *)indexPath
{
    static NSString *ID = @"Cell";
    
    SeminarCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    SeminarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SeminarCell" owner:nil options:nil] firstObject];
    }
    return cell;
}


//清空imageView的内容，防止cell重用时图片错乱
- (void)prepareForReuse {
    [super prepareForReuse];
    self.SeminarImageView.image = nil;
    //    [self deallocByMyself];//手动释放
}

//封装cell显示
- (void)showSeminarCellWithDic:(NSDictionary *)dic {
    //圆头像
    [Util setRoundImageView:_SeminarIcon];
    //头像缓存

    if ([Util isBlankString:[dic objectForKey:USER_IMAGEURL]]) {
        if ([[dic objectForKey:USER_SEX] isEqual:USER_SEX_1]) {
            [_SeminarIcon setImage:[UIImage imageNamed:USER_ICON_MALE]];
        }else{
            [_SeminarIcon setImage:[UIImage imageNamed:USER_ICON_FEMALE]];
        }
    }else{
        NSMutableString *pathString = [[NSMutableString alloc] initWithString:[dic objectForKey:USER_IMAGEURL]];
        NSRange range = [pathString rangeOfString:@"." options:NSBackwardsSearch];
        NSURL* imagePath;//图片url
        if (range.location != NSNotFound && range.location > 60) {
            [pathString insertString:@"_small" atIndex:range.location];
            imagePath = [NSURL URLWithString:pathString];
        } else {
            imagePath = [NSURL URLWithString:[dic objectForKey:USER_IMAGEURL]];
        }
        
        [_SeminarIcon sd_setImageWithURL:imagePath placeholderImage:[UIImage imageNamed:USER_ICON_NULL]];
    }
    
    NSString *userLikeFlag = [NSString stringWithFormat:@"%@",[dic valueForKey:@"userLikeFlag"]];
    //判断是否已经点赞，y更换背景
    if ([userLikeFlag isEqualToString:@"1"]) {
        [_seminarLikeButton setImage:[UIImage imageNamed:@"seminar_like_pressed"] forState:UIControlStateNormal];
    } else {
        [_seminarLikeButton setImage:[UIImage imageNamed:@"seminar_like_normal"] forState:UIControlStateNormal];
    }
    
    _seminarLikeCount.text = [NSString stringWithFormat:@"%@", [dic objectForKey:SEMINAR_LIKE_COUNT] ];
    _seminarCount.text =  [NSString stringWithFormat:@"%@", [dic objectForKey:SEMINAR_CHILD_COUNT] ];
    _SeminarName.text = [dic objectForKey:USER_NAME];
    _SeminarTitle.text = [Util decodeFromPercentEscapeString:[dic objectForKey:SEMINAR_TITLE]];//UTF-8解码
    ;
    _SeminarTime.text = [Util intervalSinceNow:[dic objectForKey:SEMINAR_CREATETIME]];
    if ([Util isBlankString:[dic objectForKey:SEMINAR_CONTENT]] == NO) {
        _SeminarContent.text =  [Util decodeFromPercentEscapeString:[dic objectForKey:SEMINAR_CONTENT]];//UTF-8解码
        ;
    }else{
        _SeminarContent.text = nil;
    }
    
//    //图片
//    if (![util isBlankString:[dic objectForKey:SEMINAR_IMAGEURL]]) {
//        NSMutableString *pathString = [[NSMutableString alloc] initWithString:[dic objectForKey:SEMINAR_IMAGEURL]];
//        NSRange range = [pathString rangeOfString:@"." options:NSBackwardsSearch];
//        NSURL* imagePath;//图片url
//        if (range.location != NSNotFound && range.location > 60) {
//            [pathString insertString:@"_small" atIndex:range.location];
//            imagePath = [NSURL URLWithString:pathString];
//        } else {
//            imagePath = [NSURL URLWithString:[dic objectForKey:SEMINAR_IMAGEURL]];
//        }
//        _SeminarImageView.tag = [imagePath absoluteString];
        
//         UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:IMAGE_EMPTY]];
//        [imageView sd_setImageWithURL:imagePath placeholderImage:[UIImage imageNamed:IMAGE_EMPTY] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            
//            _SeminarImageView.image = imageView.image;
//
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//            if ([_SeminarImageView.tag isEqualToString:[imageURL absoluteString]]) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    _SeminarImageView.image = image;
//                    
//                });
//                
//            }
//
//        }];
//        
//    } else {
//        _SeminarImageView.tag = @"123";
//        _SeminarImageView.image = nil;
//    }
    
    
//                                                      }];
//        }
    
}




//点赞封装
+ (NSMutableArray *)addOrCancelLikeWithCell:(SeminarCell *)cell
                              AndSeminarDic:(NSMutableDictionary *)_seminarDic AndRow:(NSInteger)row AndArray:(NSMutableArray *)mutableArray {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[mutableArray objectAtIndex:row]];
    
    //一个cell刷新
    NSInteger count;//点赞数
    NSString *userLikeFlag = [NSString stringWithFormat:@"%@",[_seminarDic valueForKey:@"userLikeFlag"]];//是否点赞
    
    if ([userLikeFlag isEqualToString:@"1"]) {
        count = ([cell.seminarLikeCount.text intValue] - 1);//点赞数加一
        [dict setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:SEMINAR_LIKE_COUNT];//改变数组的点赞数
        [dict setObject:@"0" forKey:@"userLikeFlag"];
    } else {
        count = ([cell.seminarLikeCount.text intValue] + 1);//点赞数减一
        [dict setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:SEMINAR_LIKE_COUNT];//改变数组的点赞数
        [dict setObject:@"1" forKey:@"userLikeFlag"];
        
    }
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:mutableArray];
    [mutableArr replaceObjectAtIndex:row withObject:dict];
    
    return mutableArr;
    
}


//手动释放
- (void)deallocByMyself {
    //    _SeminarContent.text = nil;
    //    _seminarCount.text = nil;
    //    _SeminarIcon.image = nil;
    //    if (_SeminarImageView.image != nil) {
    _SeminarImageView.image = nil;
    
    //    }
    //    _seminarLikeButton.imageView.image = nil;
    //    _seminarLikeCount.text = nil;
    //    _SeminarName.text = nil;
    //    _SeminarTime.text = nil;
    //    _SeminarTitle.text = nil;
    
}





@end
