//
//  GLBaseWidgetModel.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/8/20.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLBaseViewModel, GLCollectionReusableViewModel, GLBaseWidgetView, GLBaseHttpModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLBaseWidgetModel : NSObject

@property (nonatomic, weak) GLBaseWidgetView *baseWidgetView;

/**
 CollectionView header视图模型
 */
@property (nonatomic, strong) NSMutableArray<GLCollectionReusableViewModel *> * __nullable headerDataList;

/**
 CollectionView cell视图模型数组
 */
@property (nonatomic, strong) NSMutableArray<NSArray <GLBaseViewModel *>*> *__nullable cellDataList;

/**
 CollectionView footer视图模型
 */
@property (nonatomic, strong) NSMutableArray<GLCollectionReusableViewModel *> *__nullable footerDataList;

/**
 item横向间距
 */
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

/**
 item纵向间距
 */
@property (nonatomic, assign) CGFloat minimumLineSpacing;

/**
 设置section边距。
 若自定义，则必须将“isResetSectionInset”设为YES！
 */
@property (nonatomic, assign) UIEdgeInsets sectionInset;

/**
 是否自定义section边距
 */
@property (nonatomic, assign) BOOL isResetSectionInset;

/**
 每个section的背景色
 */
@property (nonatomic, strong) UIColor *sectionBgColor;

/**
 数据请求model
 */
@property (nonatomic, strong) GLBaseHttpModel *baseNetwork;

/**
 初始化方法
 @param data 初始化所需数据
 */
- (instancetype)initWithData:(id __nullable)data;

/**
 初始化配置（初始化时会调用该方法）
 */
- (void)configWithData:(id __nullable)data;

/**
 刷新数据
 */
- (void)refreshingData;

/**
 加载更多数据
 */
- (void)loadingMoreData;

/**
 复写后，下拉刷新时调用“refreshAllWidgets”时，会触发该方法
 */
- (void)request;

/**
 发送请求
 使用该方法发送请求，会接收请求回调，并自动进行数据绑定
 @param dataModel 请求成功后，用于绑定数据的model
 */
- (void)requestWithDataModel:(id)dataModel;

/**
 请求成功数据处理
 */
- (void)handleSuccessResult:(id)result dataModel:(id __nullable)dataModel;

/**
 请求失败数据处理
 */
- (void)handleFail:(id)error;

@end

NS_ASSUME_NONNULL_END
