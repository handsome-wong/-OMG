//
//  SeminarUrl.h
//  teachingliteApple
//
//  Created by admin on 15/9/25.
//  Copyright (c) 2015年 com.futian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiConstant.h"

@interface SeminarUrl : NSObject

/**
 * 帖子列表接口,返回值类型Map<"seminarList",List<Record>>
 */

#define LIST_SEMINAR  SERVER_URL@"seminar/list"

/**
 * 通过帖Title,Content,userId,courseId，parentId的增加帖子的Url,返回值类型null
 */
#define ADD_SEMINAR SERVER_URL@"seminar/add"

/**
 * 通过帖子seminarId的编辑帖子的Url,返回值类型Map<"seminar",Seminar>
 */
#define EDIT_SEMINAR SERVER_URL@"seminar/edit"

/**
 * 通过帖子seminarId,Title,Content,userId,courseId，parentId的更新帖子的Url,返回值类型null
 */
#define UPDATE_SEMINAR SERVER_URL@"seminar/update"

/**
 * 通过帖子seminarId的删除帖子的Url,返回值类型null
 */
#define DELETE_SEMINAR SERVER_URL@"seminar/delete"

/**
 * 通过用户Id获取指定用户的帖子列表的Url,返回值类型Map<"seminarList",List<Record>>
 */
#define GET_SEMINAR_BY_USER_ID SERVER_URL@"seminar/getSeminarsByUserId"

/**
 * 通过课程Id获取指定课程的主贴列表的Url,返回值类型Map<"seminarList",List<Record>>
 */
#define GET_ROOT_SEMINARS_BY_COURSE_ID SERVER_URL@"seminar/getRootSeminarsByCourseId"

/**
 * 通过parentId获取指定帖子及跟帖列表的Url，包括子帖数和点赞数的Url,返回值类型Map<"seminarList",List>
 * Record>>
 */

#define  GET_ROOT_AND_CHILD_SEMINARS_BY_PARENT_ID SERVER_URL@"seminar/getRootAndChildSeminarsByParentId"

/**
 * 通过parentId获取子帖数量的Url,返回值类型Map<"countOfChildSeminar",int>
 */
#define GET_CHILDS_COUNT_BY_PARENT_ID ApiConstant.SERVER_URL@"seminar/getChildsCountByParentId"

/**
 * 通过帖子seminarId获取帖子点赞数的Url,返回值类型Map<"countOfSeminarLike",int>
 */
#define GET_LIKE_COUNT_BY_SEMINAR_ID SERVER_URL@"seminar/getLikeCountBySeminarId"

/**
 * 通过子贴childId获取指定帖子的父帖子的Url,返回值类型Map<"seminar",Seminar>
 */
#define GET_PARENT_SEMINAR_BY_CHILD_ID SERVER_URL@"seminar/getParentSeminarByChildId"

/**
 * 通过帖子content获取内容中包含指定内容的帖子的Url,返回值类型Map<"seminarList",List<Record>>
 */
#define GET_SEMINARS_BY_CONTENT SERVER_URL@"seminar/getSeminarsByContent"

/**
 * 通过userId获取指定用户所有课程的主帖列表的Url,返回值类型Map<"seminarList",List<Record>>
 */

#define  GET_ROOT_SEMINARS_OF_COURSES_BY_USER_ID SERVER_URL@"seminar/getRootSeminarsOfCousesByUserId"

/**
 * 通过userId获取指定用户全部课程的主帖及对应的跟帖数量和点赞数量的Url,返回值类型Map<"seminarList",List<Record
 * >>
 */
#define GET_SEMINARS_AND_CHILD_COUNT_AND_LIKE_COUNT_BY_USER_ID SERVER_URL@"seminar/getSeminarsAndChildCountAndLikeCountByUserId"

/**
 * 通过帖子seminarId删除帖子以及子帖和点赞的Url,返回值类型null
 */
#define DELETE_SEMINAR_AND_CHILDS_AND_LIKE_BY_SEMINAR_ID SERVER_URL@"seminar/deleteSeminarAndChildsAndLikesBySeminarId"

/**
 * 通过userId和courseId获取指定用户指定课程的帖子列表的Url,返回值类型Map<"seminarList",List<Record>>
 */
#define GET_SEMINARS_BY_COURSE_ID_AND_USER_ID SERVER_URL@"seminar/getSeminarsByCourseIdAndUserId"

/**
 * 通过userId和seminarId删除属于自己的帖子（自己的特定主帖及子帖或在某帖子中的跟帖）的Url,返回值类型null
 */
#define DELETE_SEMINARS_BY_SEMINAR_ID_AND_USER_ID SERVER_URL@"seminar/deleteSeminarsBySeminarIdAndUserId"


//特注以下是课程讨论分页用的接口

/**
 * 获取主贴
 * 传courseId，seminarUpdateTime, seminarId, pageSize
 * （pageSize这个是要拿多少条数据）
 */
#define GET_ROOT_SEMINARS_BY_COURSE_ID_AND_PAGE_PARAMS SERVER_URL@"seminar/getRootSeminarsByCourseIdAndPageParams"

/**
 * 获取子贴
 * 传parentId，seminarUpdateTime, seminarId, pageSize
 * （pageSize这个是要拿多少条数据）
 */
#define GET_ROOT_AND_CHILD_SEMINARS_BY_PARENT_ID_AND_PAGE_PARAMS SERVER_URL@"seminar/getRootAndChildSeminarsByParentIdAndPageParams"


/**
 * 通过帖seminarTitle, seminarContent, userId, courseId, seminarParentId, seminarIsFavourite的增加帖子的Url,返回值类型null
 */
#define ADD_SEMINAR_BY_FORM SERVER_URL@"seminar/addSeminarByForm"

//seminarId 帖子ID
//userId  当前登录用户ID
#define ADD_OR_DELETE_SEMINARLIKE_BY_SEMINARID_AND_USERID SERVER_URL@"seminarLike/addOrDeleteSeminarLikeBySeminarIdAndUserId"

@end
