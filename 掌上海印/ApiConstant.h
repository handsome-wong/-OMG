//
//  ApiConstant.h
//  teachingliteApple
//
//  Created by admin on 15/9/22.
//  Copyright (c) 2015年 com.futian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiConstant : NSObject

/**
 * 备用服务器
 */
//#define SERVER_URL @"http://120.24.81.58:8080/teachinglite/"
#define SERVER_URL @"http://120.25.80.43:8080/teachinglite/"
/**
 * 以字节流的方式上传文件接口 请求参数 inputStream，type 返回值类型 Map<"fileUrl",url>
 */
#define UP_LOAD_BY_STREAM SERVER_URL@"fileUpload/uploadByStream"
/**
 * 以表单提交的方式上传文件接口 请求参数 file 返回值类型 Map<"fileUrl",url>
 */


#define UP_LOAD_BY_WEB SERVER_URL@"fileUpload/uploadByWeb"
/**
 * 以参数提交方式上传文件接口 请求参数 content,type 返回值类型 Map<"fileUrl",url>
 */
#define UP_LOAD_BY_PARAM SERVER_URL@"fileUpload/uploadByParam"

/** 参数content：1，type：2，userId：3，userType：4
 *   这个接口上传并自动更新用户头像url,更新完成后返回url,如果你想将图片上传和更新url一次性完成，可以使用这个接口
 */
#define  UPLOAD_AND_SAVE_BY_PARAM  SERVER_URL@"fileUpload/uploadAndSaveByParam"

/**
 * 参数ownerid，path: 文件在云盘的path，operation: createdownloadlink，data:
 * 1(意思是可以下载几次) data2: 500（意思是多少秒以内下载链接有效）包装成CMD的字符串，返回值UUID 建造tempLink =
 * "http://" + SmartPanIp + "/SmartPan/DD.do?UUID=" + UUID; tempLink可用于下载文件
 */

#define SMART_PAN_URL @"http://120.24.81.58:8085/SmartPan/SPC.do"

#define  SMART_DOWNLOAD_FILE  SMART_PAN_URL

@end
