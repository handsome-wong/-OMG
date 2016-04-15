//
//  BaseService.h
//  teachingliteApple
//
//  Created by admin on 15/11/4.
//  Copyright (c) 2015年 com.huagongguangzhouxueyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "util.h"
#import "UIImageView+WebCache.h"//图片缓存

@interface BaseService : NSObject

//取消宏定义
#undef USER_TYPE
#undef USER_ID
#undef USER_NAME
#undef USER_NUMBER
#undef USER_PHONE
#undef COURSE_ID
#undef COURSE_NAME
#undef NOTIF_ID
#undef NOTE_ID
#undef NOTE_CONTENT
#undef PAGE_SIZE

//base
#define RESULTMAP @"resultMap"
#define SUCCESS @"Success"
#define MESSAGE @"message"
#define REQUESTFAILE @"请检查网络状态！"

//login
#define TEXTVIEW_BLANK @"请检查账号和密码是否为空！"
#define IS_RECORD @"isRecord"
#define IS_LOGIN @"isLogin"
#define IS_YES @"YES"
#define IS_NO @"NO"
#define CHECKBOX_PRESSED @"checkbox_pressed"
#define CHECKBOX_NORMAL @"checkbox_normal"
#define NUMBER @"number"
#define PASSWORD @"password"
#define FAILE @"请检查账号和密码！"
#define LOGINUSER @"loginUser"
#define COURSE_ROOTVIEW @"course_rootView"
#define REQUESTSUEECSS @"登陆成功！"

//user
#define USER_ID @"userId"
#define USER_TYPE @"userType"
#define USER_NAME @"userName"
#define USER_NUMBER @"userNumber"
#define USER_PHONE @"userPhone"
#define USER_EMAIL @"userEmail"
#define USER_PASSWORD @"userPassword"
#define USER_ISUSING @"userIsUsing"
#define USER_IMAGEURL @"userImageUrl"
#define USER_SEX @"userSex"
#define USER_CREATETIME @"userCreateTime"
#define USER_UPDATETIME @"userUpdateTime"
#define USER_SEX_1 @"1"
#define USER_SEX_0 @"0"


//course
#define COURSE_ID @"courseId"
#define COURSE_NAME @"courseName"
#define COURSE_CREDIT @"courseCredit"
#define COURSE_PERIOD @"coursePeriod"
#define DEPT_ID @"deptId"
#define COURSE_ICONURL @"courseIconUrl"
#define COURSE_TYPEID @"courseTypeId"
#define COURSE_CREATETIME @"courseCreateTime"
#define COURSE_UPDATETIME @"courseUpdateTime"
#define COURSE_COLLECTION_CELL @"CourseCollectionCell"
#define NULL_STR @"<null>"
#define COURSE_ICON_NORMAL @"ic_default_course_normal"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define USER_INFO_VIEW @"UserInfoView"

#define COURSE_GO_TABBAR @"course_go_tabBar"
#define COURSE_LIST @"courseList"
#define APP_NOTE_DATEFORMAT @"YYYY-MM-dd"
#define APP_NOTE_ID @"123"
#define APP_NOTE_TITLE @"华广云课堂简介"
#define APP_NOTE_CONTENT @"华广云课堂教学软件是由华南理工大学广州学院工程研究院研发，包括教师端和学生端，其中学生端分为Android端和IOS端，学生端具有查看课程通知、学习交流、下载课程资料、编写课程笔记等功能！"


//notif
#define NOTIF_ID @"notifId"
#define NOTIF_TITLE @"title"
#define NOTIF_CONTENT @"content"
#define NOTIF_CREATETIME @"createTime"
#define NOTIF_UPDATETIME @"updateTime"
#define NOTIF @"Notif"
#define COURSE_NOTIF_TITLE @"courseNotifTitle"
#define COURSE_NOTIF_CREATETIME @"courseNotifCreateTime"
#define COURSE_NOTIF_CONTENT @"courseNotifContent"
#define NOTIF_GO_NOTIFDETAIL @"notif_go_notifDetail"
#define COURSE_NOTIF_UPDATETIME @"courseNotifUpdateTime"
#define COURSE_NOTIF_ID @"courseNotifId"
#define PAGESIZE @"pageSize"
#define PAGE_SIZE_INT @"8"
#define COURSE_NOTIF_ID @"courseNotifId"
#define COURSE_NOTIF_UPDATETIME @"courseNotifUpdateTime"
#define COURSE_NOTIF_AND_OWNER @"CourseNotifAndOwner"
#define LOAD_FINISH @"数据已加载完！"

//note
#define NOTE_ID @"noteId"
#define NOTE_TITLE @"title"
#define NOTE_CONTENT @"content"
#define NOTE_CREATETIME @"createdTime"
#define NOTE_UPDATETIME @"updatedTiem"
#define NOTE_GO_NOTEDETAIL @"note_go_noteDetail"
#define NOTE_GO_NOTESEND @"note_go_noteSend"
#define NOTEDETAIL_GO_NOTESEND @"noteDetail_go_noteSend"
#define DATE_FORMAT @"YYYY-MM-dd"
#define NOTE_ID_FORMAT @"YYYYMMddhhmmss"

//userInfo
#define USER_ICON_MALE @"ic_default_male"
#define USER_ICON_FEMALE @"ic_default_female"
#define USER_ICON_NULL @"avator_null"
#define CANCEL @"取消"
#define PHOTO_CHOOSE @"从相册选择"
#define PHOTO_TAKE @"拍照"
#define PHOTO_TAKE_TIPS @"该设备无摄像头"
#define UPLOAD_FAIL @"上传失败！"
#define FILE @"file"
#define FILE_URL @"fileUrl"
#define ERROR @"数据读取失败，请稍后重试！"
#define IS_NULL @""
#define NULL_TIPS @"密码不能为空！"
#define IS_SPACE @" "
#define SPACE_TIPS @"密码不能出现空格！"
#define PSW_LESS_TIPS @"密码不能少于6位！"
#define CHANGE_PSW_SUCCESS @"更改密码成功！"
#define CHANGE_PSW_FAIL @"更改密码失败"
#define PSW_IDENTICAL_TIPS @"新密码不一致!"
#define OLD_PSW_ERROR @"原密码输入错误！"
#define TIPS @"提示"
#define EXIT_CONFIRM @"确认退出吗？"
#define SURE @"确定"
#define OLD_PASSWORD @"oldPassword"
#define NEW_PASSWORD @"newPassword"
#define MALE @"男"
#define FEMALE @"女"

//seminar
#define SEMINAR @"Seminar"
#define SEMINAR_LIKE_COUNT @"seminarLikeCount"
#define SEMINAR_CHILD_COUNT @"seminarChildCount"
#define SEMINAR_TITLE @"seminarTitle"
#define SEMINAR_CREATETIME @"seminarCreateTime"
#define SEMINAR_CONTENT @"seminarContent"
#define SEMINAR_IMAGEURL @"seminarImageUrl"
#define IMAGE_EMPTY @"ic_empty"
#define _DELETE @"删除"
#define DELETE_CONFIRM @"确定删除？"
#define SEMINAR_ID @"seminarId"
#define SEMINAR_LIST @"seminarList"
#define SEMINAR_GO_SEMINARSON @"seminar_go_seminarSon"
#define SEMINAR_UPDATETIME @"seminarUpdateTime"
#define LOAD_TIPS @"数据已加载完！"
#define IS_REFRESH @"isRefresh"
#define SEMINAR_GO_SEMINARSEND @"seminar_go_seminarSend"
#define SEMINARSON @"SeminarSon"
#define LOUZHU @"楼主"
#define DELETE_FAILE @"删除失败！"
#define SEMINAR_PARENT_ID @"seminarParentId"
#define SUCCESS_SEND @"发送成功"
#define FAILE_SEND @"发送失败"
#define PARENT_ID @"parentId"
#define CONTENT_SPACE @"内容不能为空！"
#define IS_COMPRESS @"是否压缩图片"
#define ORIGIN @"原图"
#define COMPRESS @"压缩"
#define CONTENT_TITLE_SPACE @"标题和内容不能为空！"
#define SEMINAR_ISFAVOURITE @"seminarIsFavourite"
#define COUNT_0 @"0"

//封装头像显示问题
+ (void)showAvatarWithDic:(NSDictionary *)dic
             forImageView:(UIImageView *)imageView;

#pragma mark - 设置性别
+ (NSString *)getUserSexWithSexString:(NSString *)sex;


//头像显示问题
+ (void)showAvatarWithUserSex:(NSString *)userSex
                 UserImageUrl:(NSString *)userImageUrl
                 forImageView:(UIImageView *)imageView;
@end













