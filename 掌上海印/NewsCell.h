//
//  NewsCell.h
//  掌上海印
//
//  Created by admin on 16/4/14.
//  Copyright © 2016年 handsome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *userContent;
@property (weak, nonatomic) IBOutlet UIImageView *userContentImageView;
@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UIButton *userLikeButtom;
@property (weak, nonatomic) IBOutlet UILabel *userLikeCount;
@property (weak, nonatomic) IBOutlet UIButton *userCaiButton;
@property (weak, nonatomic) IBOutlet UILabel *userCaiCount;
@property (weak, nonatomic) IBOutlet UIButton *userCommentButton;
@property (weak, nonatomic) IBOutlet UILabel *userCommentCount;

- (id)initWithUserImageView:(UIImageView *)userimageView
                            AndUserName:(NSString *)userName
                         AndUserContent:(NSString *)userContent
                AnduserContentImageView:(UIImageView *)userContentImageView
                             AndUsetime:(NSString *)userTime
                       AndUserLikeCount:(NSString *)userLikeCount
                        AndUserCaiCount:(NSString *)userCaiCount;

@end
