//
//  SeminarSonCell.m
//  teachingliteApple
//
//  Created by admin on 15/9/25.
//  Copyright (c) 2015年 com.futian. All rights reserved.
//

#import "SeminarSonCell.h"
#import "SeminarSonViewController.h"
//#import "UIImageView+AsyncDownload.h"

@implementation SeminarSonCell

- (void)awakeFromNib {
        // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
}


+ (instancetype)seminarSonCellWithTableView:(UITableView *)tableView
{

    
    static NSString *ID = @"seminarSon_cell";
    SeminarSonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SeminarSonCell" owner:nil options:nil] firstObject];
    }
    return cell;
}


//赋值 and 自动换行,计算出cell的高度
-(void)setContentText:(NSString*)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.SeminarSonContent.text = text;
    //设置label的最大行数
    self.SeminarSonContent.numberOfLines = 40;
    CGSize size = CGSizeMake(320,2000); //设置一个行高上限
    CGSize labelSize = [self boundingRectWithSize:size :self.SeminarSonContent :text];
    //计算出自适应的高度
    frame.size.height = labelSize.height+90;
    
    self.frame = frame;
}

- (void)setTitleText:(NSString *)text{
    //获得当前cell高度
    CGRect frame = [self frame];
    //文本赋值
    self.SeminarSonTitle.text = text;
    //设置label的最大行数
    self.SeminarSonTitle.numberOfLines = 20;
    
    CGSize size = CGSizeMake(320,2000); //设置一个行高上限
    CGSize labelSize = [self boundingRectWithSize:size :_SeminarSonTitle :text];
    NSLog(@"label=%f",labelSize.height);
    //计算出自适应的高度
    frame.size.height = labelSize.height+65;
    
    self.frame = frame;

}

#pragma mark - 设置有照片时的cell高度
- (void)setImageCell:(UIImage *)image :(NSInteger)rowHeight{
    CGSize Imgsize = image.size;

    //计算出自适应的高度
    self.frame = CGRectMake(self.seminarSonImageView.frame.origin.x, self.seminarSonImageView.frame.origin.y,Imgsize.width,rowHeight + 100) ;
}




#pragma mark - 第一个参数为限定size 第二个为需要计算的label 第三个为label的内容 返回算出的size
- (CGSize)boundingRectWithSize:(CGSize)size :(UILabel *)label :(NSString *)text
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

//清空imageView的内容，防止cell重用时图片错乱
- (void)prepareForReuse {
    [super prepareForReuse];
       [self deallocByMyself];//手动释放
}

//cell显示
- (void)showSeminarSonCellWithDic:(NSDictionary *)dic
                     AndIndexPath:(NSIndexPath *)indexPath
                          AndSelf:(id)aSelf {
    [self deallocByMyself];
    
    //头像处理、小图
    [Util setRoundImageView:_SeminarSonIcon];
    if ([Util isBlankString:[dic objectForKey:USER_IMAGEURL]]) {
        if ([[dic objectForKey:USER_SEX] isEqual:USER_SEX_1]) {
            [_SeminarSonIcon setImage:[UIImage imageNamed:USER_ICON_MALE]];
        }else{
            [_SeminarSonIcon setImage:[UIImage imageNamed:USER_ICON_FEMALE]];
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

        [_SeminarSonIcon sd_setImageWithURL:imagePath
                           placeholderImage:[UIImage imageNamed:USER_ICON_NULL]];
    }
    
    //内容
    NSString *content = [dic objectForKey:SEMINAR_CONTENT];
    NSString *title = [dic objectForKey:SEMINAR_TITLE];

    //判断标题是否为空
    if (![Util isBlankString:title]) {
        _SeminarSonTitle.text= [Util decodeFromPercentEscapeString:title];//UTF-8解码
        if (![Util isBlankString:content]) {
            [_SeminarSonContent setText:[Util decodeFromPercentEscapeString:content]];

        } else{
            _SeminarSonContent.text = nil;
            
        }
        
    }else{
        _SeminarSonTitle.font = [UIFont fontWithName:@"Helvetica" size:12];
        _SeminarSonTitle.textColor = [UIColor blackColor];
        _SeminarSonContent.text = nil;
        
        if (![Util isBlankString:content]) {

            [_SeminarSonTitle setText:[Util decodeFromPercentEscapeString:content]];
           
        } else{
            _SeminarSonTitle.text = nil;
            
        }
        
    }
    //编写楼层
    if (indexPath.row == 0) {
        _SminarSonFloor.text = LOUZHU;
    }else{
        _SminarSonFloor.text = [NSString stringWithFormat:@"%ld楼",(long)indexPath.row];
    }
    
//    //判断是否为带图片的帖子
//    _seminarSonImageView.image = nil;
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
//        _seminarSonImageView.tag = [imagePath absoluteString];
//        _seminarSonImageView.image = [UIImage imageNamed:IMAGE_EMPTY];
//        UIImageView *imageView = [[UIImageView alloc]init];
//        [imageView sd_setImageWithURL:imagePath placeholderImage:[UIImage imageNamed:IMAGE_EMPTY]options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//            if ([_seminarSonImageView.tag isEqualToString:[imageURL absoluteString]]) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    _seminarSonImageView.image = imageView.image;
//                    
//                });
//                
//            }
//            
//            
//        }];
//        
//    } else {
//        _seminarSonImageView.tag = @"123";
//        _seminarSonImageView.image = nil;
//    }
    
        [_seminarSonImageView setUserInteractionEnabled:YES];

    
    _SeminarSonTime.text = [Util intervalSinceNow:[dic objectForKey:SEMINAR_CREATETIME]];//格式化时间
    _SeminarSonName.text = [dic objectForKey:USER_NAME];

}


//手动释放
- (void)deallocByMyself {
    _SeminarSonContent.text = nil;
    _SeminarSonIcon.image = nil;
    _seminarSonImageView.image = nil;
    _SeminarSonName.text = nil;
    _SeminarSonTime.text = nil;
    _SeminarSonTitle.text = nil;
    
}


@end
