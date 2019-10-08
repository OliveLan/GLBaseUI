//
//  GLBaseHttpModel.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/9/30.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, REQUEST_STATUS) {
    REQUEST_STATUS_REQUESTING,
    REQUEST_STATUS_SUCCESS,
    REQUEST_STATUS_FAIL
};

typedef NS_ENUM(NSUInteger, REQUEST_TYPE) {
    REQUEST_TYPE_REFRESH,       // 刷新数据
    REQUEST_TYPE_LOADMORE,      // 上拉加载
    REQUEST_TYPE_OTHER
};

typedef void(^GLReqSuccess)( id resultDic);
typedef void(^GLReqFailure)( id error);

/**
 网络请求模型基类
 所有网络请求继承于该类
 */
@interface GLBaseHttpModel : NSObject

/**
 数据请求成功回调
 */
@property (nonatomic, copy) GLReqSuccess requestSuccessBlock;

/**
 数据请求失败回调
 */
@property (nonatomic, copy) GLReqFailure requestErrorBlock;

/**
 请求结果
 */
@property (nonatomic, readonly) id resultData;

/**
 请求结果：列表数据
 */
@property (nonatomic, readonly) NSArray *list;

/**
 请求状态
 */
@property (nonatomic, assign) REQUEST_STATUS requestStatus;

/**
 请求类型
 (下拉刷新、上拉加载)
 */
@property (nonatomic, assign) REQUEST_TYPE requestType;

/**
 项目网络请求基类
 复写后，需对该值赋值。
 */
@property (nonatomic, strong) id baseNetwork;

/**
 子类需复习该方法，用于发送具体的请求
 */
- (void)request;

@end

NS_ASSUME_NONNULL_END
