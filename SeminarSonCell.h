//
//  SeminarSonCell.h
//  teachingliteApple
//
//  Created by admin on 15/9/25.
//  Copyright (c) 2015年 com.futian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseService.h"
#import "util.h"
#import "SeminarSonService.h"
#import "SeminarSonViewController.h"

@interface SeminarSonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *SeminarSonIcon;
@property (weak, nonatomic) IBOutlet UILabel *SeminarSonName;
@property (weak, nonatomic) IBOutlet UILabel *SeminarSonTitle;
@property (weak, nonatomic) IBOutlet UILabel *SeminarSonTime;
@property (weak, nonatomic) IBOutlet UILabel *SeminarSonContent;
@property (weak, nonatomic) IBOutlet UILabel *SminarSonFloor;
@property (weak, nonatomic) IBOutlet UIImageView *seminarSonImageView;

+ (instancetype)seminarSonCellWithTableView:(UITableView *)tableView;

#pragma mark - 第一个参数为限定size 第二个为需要计算的label 第三个为label的内容 返回算出的size
- (CGSize)boundingRectWithSize:(CGSize)size :(UILabel *)label :(NSString *)text;


//自适应cell
-(void)setContentText:(NSString*)text;

- (void)setTitleText:(NSString *)text;

//设置有照片时的cell高度
- (void)setImageCell:(UIImage *)image :(NSInteger)rowHeight;

//cell显示
- (void)showSeminarSonCellWithDic:(NSDictionary *)dic
                     AndIndexPath:(NSIndexPath *)indexPath
                          AndSelf:(id)aSelf;

@end
