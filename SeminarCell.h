//
//  SeminarCell.h
//  Test-云课堂
//
//  Created by admin on 15/9/18.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "util.h"
#import "BaseService.h"

@interface SeminarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *SeminarIcon;
@property (weak, nonatomic) IBOutlet UILabel *SeminarName;
@property (weak, nonatomic) IBOutlet UILabel *SeminarTitle;
@property (weak, nonatomic) IBOutlet UILabel *SeminarTime;
@property (weak, nonatomic) IBOutlet UILabel *SeminarContent;
@property (weak, nonatomic) IBOutlet UIImageView *SeminarImageView;
@property (strong, nonatomic) IBOutlet UILabel *seminarCount;
@property (weak, nonatomic) IBOutlet UILabel *seminarLikeCount;
@property (weak, nonatomic) IBOutlet UIButton *seminarLikeButton;


+ (instancetype)seminarCellWithTableView:(UITableView *)tableView AndIndex:(NSIndexPath *)indexPath;

//封装cell显示
- (void)showSeminarCellWithDic:(NSDictionary *)dic;

//点赞封装
+ (NSMutableArray *)addOrCancelLikeWithCell:(SeminarCell *)cell
                              AndSeminarDic:(NSMutableDictionary *)_seminarDic AndRow:(NSInteger)row AndArray:(NSMutableArray *)mutableArray;
@end
