//
//  YLWDetailTextModel.h
//  推库iOS
//
//  Created by Mac on 16/2/23.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YLWDetailTextModel : NSObject
typedef void (^successBlock) (YLWDetailTextModel *);
@property (nonatomic,copy) NSString *id;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *time;

@property (nonatomic,copy) NSString *feed_title;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,strong) NSArray *images;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

+(instancetype)detailTextModelWithDictionary:(NSDictionary *)dic;

+(void)detileNewsModelGetWithdetailTextId:(NSString *)detailTextId success:(successBlock)successback;


@end
