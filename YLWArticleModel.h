//
//  YLWArticleModel.h
//  推库iOS
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^successBlack) (NSArray *modelArray);
@interface YLWArticleModel : NSObject<NSCoding>
/*
 "id": "zMNN3iu",
 "title": "JBL Pulse 2 review - CNET",
 "time": "02-18 17:00",
 "rectime": "02-18 17:15",
 "uts": 1455786911704,
 "feed_title": "CNET Reviews",
 "img": "http://aimg0.tuicool.com/zURJNj.jpg!middle",
 "abs": "",
 "cmt": 0,
 "st": 0,
 "go": 0
 
 */
@property (nonatomic,copy) NSString *id;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *rectime;

@property (nonatomic,copy) NSString *uts;

@property (nonatomic,copy) NSString *feed_title;

@property (nonatomic,copy) NSString *img;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

+(instancetype)articleModelWithDictionary:(NSDictionary *)dic;

+(void)articleModelGetDataWithURLString:(NSString *)URLString title:(NSString *)title parameters:par successblack:(successBlack)successblack;
@end
