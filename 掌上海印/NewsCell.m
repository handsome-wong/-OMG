//
//  NewsCell.m
//  掌上海印
//
//  Created by admin on 16/4/14.
//  Copyright © 2016年 handsome. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithUserImageView:(UIImageView *)userimageView
                            AndUserName:(NSString *)userName
                         AndUserContent:(NSString *)userContent
                AnduserContentImageView:(UIImageView *)userContentImageView
                             AndUsetime:(NSString *)userTime
                       AndUserLikeCount:(NSString *)userLikeCount
                        AndUserCaiCount:(NSString *)userCaiCount
{
    if (self = [super init]) {
        self.userImageView = userimageView;
        self.UserName.text = userName;
        self.userContent.text = userContent;
        self.userContentImageView = userContentImageView;
        self.userTime.text = userTime;
        self.userLikeCount.text = userLikeCount;
        self.userCaiCount.text = userCaiCount;
    }
    
    return self;

}

@end
