//
//  YLWNewsTableViewCell.m
//  推库iOS
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import "YLWNewsTableViewCell.h"
#import "YLWArticleModel.h"
//#import <SDWebImage/UIImageView+WebCache.h>
@interface YLWNewsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *feed_titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


@end
@implementation YLWNewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
}

-(void)setArticleModel:(YLWArticleModel *)articleModel{

    _articleModel = articleModel;
    
    self.titleLabel.text = articleModel.title;
    self.feed_titleLabel.text = articleModel.feed_title;
    self.timeLabel.text = articleModel.time;
    
    if (articleModel.img) {
     
//        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:articleModel.img] placeholderImage:[UIImage imageNamed:@"abs_pic"]];
        
//        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:articleModel.img] placeholderImage:[UIImage imageNamed:@"abs_pic"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//            if (error) {
//                self.iconImageView.image = [UIImage imageNamed:@"abs_pic_broken"];
//            }
//            
//        }];

    }
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
