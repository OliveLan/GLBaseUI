//
//  GLCollectionView.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/8/20.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLCollectionView, GLBaseViewModel, GLCollectionReusableViewModel;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - DataSource
@protocol GLCollectionViewDataSourceDelegate <NSObject>
@optional

/**
 *  头部数据源
 */
- (NSMutableArray <GLCollectionReusableViewModel *> *)headerDataListWithCollectionView:(GLCollectionView *)collectionView;
/**
 *  尾部数据源
 */
- (NSMutableArray <GLBaseViewModel *> *)footerDataListWithCollectionView:(GLCollectionView *)collectionView;
/**
 *  cellItem数据源
 */
- (NSMutableArray <GLBaseViewModel *> *)cellDataListWithCollectionView:(GLCollectionView *)collectionView;

@end

#pragma mark - FlowLayout
@protocol GLCollectionViewFlowLayoutDelegate <NSObject>
@optional

/**
 *  item横向间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

/**
 * item纵向间距
 **/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;

/**
 * section边距
 **/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;

@end

#pragma mark - ScrollDelegate
@protocol GLCollectionViewScrollDelegate <NSObject>
@optional

- (void)glScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)glScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)glScrollViewWillBeginDragging:(UIScrollView *)scrollView;

@end


typedef void(^DidSelectedRowBlock)(NSIndexPath *indexPath);
typedef void(^DidSelectedHeaderBlock)(NSInteger index);


@interface GLCollectionView : UICollectionView

@property (nonatomic, weak) UICollectionViewLayout *layout;
@property (nonatomic, weak) id<GLCollectionViewDataSourceDelegate> dataSourceDelegate;
@property (nonatomic, weak) id<GLCollectionViewFlowLayoutDelegate> flowLayoutDelegate;
@property (nonatomic, weak) id<GLCollectionViewScrollDelegate> scrollDelegate;

@property (nonatomic, strong) NSMutableArray<GLBaseViewModel *> *widgets;
@property (nonatomic, copy) DidSelectedRowBlock selectedRowBlock;
@property (nonatomic, copy) DidSelectedHeaderBlock selectedHeaderBlock;

+ (instancetype)createWithFlowLayout;
+ (instancetype)createWithLayout:(UICollectionViewLayout *)layout;
+ (instancetype)createFlowLayoutWithDirection:(BOOL)isHorizontal;

@end

NS_ASSUME_NONNULL_END
