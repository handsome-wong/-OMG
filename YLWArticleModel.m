//
//  YLWArticleModel.m
//  推库iOS
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import "YLWArticleModel.h"
//#import <AFNetworking.h>
//#import "YLWHttpTool.h"
//#import "YLWArticalTool.h"
@implementation YLWArticleModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{

    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dic];
        
    }
    
    return self;

}

+(instancetype)articleModelWithDictionary:(NSDictionary *)dic{

    return [[self alloc]initWithDictionary:dic];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

-(void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.rectime forKey:@"rectime"];
    [aCoder encodeObject:self.uts forKey:@"uts"];
    [aCoder encodeObject:self.feed_title forKey:@"feed_title"];
    [aCoder encodeObject:self.img forKey:@"img"];

}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super init]) {
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.rectime = [aDecoder decodeObjectForKey:@"rectime"];
        self.uts = [aDecoder decodeObjectForKey:@"uts"];
        self.feed_title = [aDecoder decodeObjectForKey:@"feed_title"];
        self.img = [aDecoder decodeObjectForKey:@"img"];
        
    }
    return self;

}


+(void)articleModelGetDataWithURLString:(NSString *)URLString title:(NSString *)title parameters:par successblack:(successBlack)successblack{
//
//    [SVProgressHUD show];
//    
//    [YLWHttpTool getWithURLString:URLString parameter:par progress:nil success:^(id responseObject) {
//        
//        NSDictionary *responseObjectDic = (NSDictionary *)responseObject;
//        
//        NSArray *articles = responseObjectDic[@"articles"];
//        
//        NSMutableArray *num = [NSMutableArray array];
//        for (NSDictionary *dic in articles) {
//            
//            YLWArticleModel *articleModel = [self articleModelWithDictionary:dic];
//            [num addObject:articleModel];
//            
//        }
//        
//        if ([title isEqualToString:@"热门"]) {
//            [YLWArticalTool addArticalWithArray:num.copy];
//        }
//        
//        
//        
//        successblack(num.copy);
//        [SVProgressHUD dismiss];
//    } failure:^(NSError *error) {
//        
//        [SVProgressHUD showImage:[UIImage imageNamed:@"fail_result"] status:@"加载失败"];
//        NSLog(@"%@",error);
//    }];
//    
//
}

@end
