//
//  GLCollectionViewCell.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLCollectionView, GLBaseViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) GLCollectionView *collectionView;
@property (nonatomic, weak) GLBaseViewModel *baseViewModel;
@property (nonatomic, strong) NSIndexPath *indexPath;


#pragma mark - 需在子类Cell中重写

/**
 直接设定cellSize
 */
- (CGSize)cellSize;

/**
 cell高度
 */
- (CGFloat)cellHeight;

/**
 cell宽度
 */
- (CGFloat)cellWidth;

/**
 创建视图布局
 */
- (void)createUI;

/**
 根据数据更新界面

 @param data 数据源
 @param indexPath 当前indexPath
 */
- (void)refreshCellWithModel:(GLBaseViewModel *)data indexPath:(NSIndexPath *)indexPath;

/**
 更新cell大小时使用
 */
- (void)refreshCellSizeWithModel:(GLBaseViewModel *)model;

/**
 collectionView didSelectItemAtIndexPath时调用
 */
- (void)didSelectedCell;

@end

NS_ASSUME_NONNULL_END
