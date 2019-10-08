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
@property (nonatomic, strong) NSMutableArray<NSMutableArray<GLBaseViewModel *>*> *__nullable cellDataList;

/**
 CollectionView footer视图模型
 */
@property (nonatomic, strong) NSMutableArray<GLBaseViewModel *> *__nullable footerDataList;

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

@end

NS_ASSUME_NONNULL_END
