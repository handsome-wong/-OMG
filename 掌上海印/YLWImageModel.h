//
//  YLWImageModel.h
//  推库iOS
//
//  Created by Mac on 16/2/25.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLWImageModel : NSObject

@property (nonatomic,copy) NSString *image_id;

@property (nonatomic,assign) float w;

@property (nonatomic,assign) float h;

@property (nonatomic,copy) NSString *src;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

+(instancetype)imageModelWithDictionary:(NSDictionary *)dic;

@end
