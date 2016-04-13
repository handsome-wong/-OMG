//
//  YLWDetailTextModel.m
//  推库iOS
//
//  Created by Mac on 16/2/23.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import "YLWDetailTextModel.h"
#import "YLWImageModel.h"
//#import <SDImageCache.h>
@implementation YLWDetailTextModel

-(instancetype)initWithDictionary:(NSDictionary *)dic{

    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dic];
        
        
        if (dic[@"images"]) {
            NSMutableArray *imagesArray = [NSMutableArray array];
            for (NSDictionary *d in dic[@"images"]) {
                
                YLWImageModel *imageModel = [YLWImageModel imageModelWithDictionary:d];
                [imagesArray addObject:imageModel];
            }
            self.images = imagesArray;
            
        }
        
        
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    
}

+(instancetype)detailTextModelWithDictionary:(NSDictionary *)dic{

    return [[self alloc]initWithDictionary:dic];

}

+(void)detileNewsModelGetWithdetailTextId:(NSString *)detailTextId success:(successBlock)successback{

//    NSString *urlstring = [NSString stringWithFormat:@"http://api.tuicool.com/api/articles/%@.json?is_pad=1&need_image_meta=1",detailTextId];
    
//    [YLWHttpTool getWithURLString:urlstring parameter:nil progress:nil success:^(id responseObject) {
//        
//        NSDictionary *responseObjectDic = (NSDictionary *)responseObject;
//        
//        NSDictionary *modelDic = responseObjectDic[@"article"];
//        
//        YLWDetailTextModel *model = [self detailTextModelWithDictionary:modelDic];
//        
//        
//        successback(model);
//        
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
    


}




@end
