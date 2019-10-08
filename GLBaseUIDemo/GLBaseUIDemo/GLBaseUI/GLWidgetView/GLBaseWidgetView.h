//
//  GLBaseWidgetView.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/8/20.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLBaseWidgetModel, GLCollectionView;

typedef void(^GLRefreshingBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@protocol GLBaseWidgetViewDeleagte <NSObject>

@optional;

- (void)collectionDidScroll:(UIScrollView *)scrollView;
- (void)collectionDidEndDecelerating:(UIScrollView *)scrollView;
- (void)collectionWillBeginDragging:(UIScrollView *)scrollView;

@end


@interface GLBaseWidgetView : UIView

@property (nonatomic, strong) GLCollectionView *collectionView;
@property (nonatomic, weak) id<GLBaseWidgetViewDeleagte>delegate;

/**
 特殊的初始化方法, 使用该方法可快速创建横向滑动的collectionView
 @param isHorizontal        是否是横向滑动列表
 @param scrollAnimation     横向滑动时，是否提供卡片居中停顿效果
 */
- (instancetype)initWithIsHorizontal:(BOOL)isHorizontal scrollAnimation:(BOOL)scrollAnimation;

/**
 向collecitionView添加组件
 */
- (void)addWidgets:(NSArray <GLBaseWidgetModel *> *)widgets;

/**
  插入组件
 */
- (void)insertWidget:(GLBaseWidgetModel *)widget section:(NSUInteger)section;

/**
 添加下拉刷新(横向列表为右拉刷新)
 */
- (void)addRefreshHeaderWithBlock:(GLRefreshingBlock)refreshing;

/**
 添加上拉加载(横向列表为左拉加载)
 */
- (void)addRefreshFooterWithBlock:(GLRefreshingBlock)refreshing;

/**
 手动调用刷新
 */
- (void)beginRefreshing;

/**
 停止刷新
 */
- (void)endRefreshing;

/**
 更新所有组件
 调用该方法 自动调用widgetModel中的 -(void)request; 方法
 */
- (void)refreshAllWidgets;

/**
 手动调用加载
 */
- (void)beginLoadMore;

/**
 停止加载更多
 */
- (void)endLoadMore;

/**
 没有更多数据提示视图（竖向）
 */
- (void)endLoadMoreWithNoMoreData;

/**
 没有更多数据提示视图（横向）
*/
- (void)showHorizontalEmptyFooter;

/**
 隐藏横向没有更多视图
 */
- (void)hiddenHorizontalEmptyFooter;

@end

NS_ASSUME_NONNULL_END
