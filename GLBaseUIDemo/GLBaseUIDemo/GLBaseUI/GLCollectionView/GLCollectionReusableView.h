//
//  GLCollectionReusableView.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/8.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLCollectionView, GLBaseViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLCollectionReusableView : UICollectionReusableView

@property (nonatomic, weak) GLCollectionView *collectionView;
@property (nonatomic, weak) GLBaseViewModel *baseViewModel;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) UIView *view;

/**
 * UI的初始化重写该方法
 */
- (void)createUI;

/**
 * 根据data进行页面赋值
 */
- (void)reuseWithData:(GLBaseViewModel *)data section:(NSInteger)section;

/**
 *  可以重写  如果直接确定这个view 的大小 可以重写这个方法直接返回大小
 *  @return view 的大小 宽和高
 */
- (CGSize)viewSize;

/**
 *  可以重写
 *  如果可以确定高度 就要重写这个方法 而宽度会根据自动布局来自动算出
 *  @return 返回view的高度
 */
- (CGFloat)viewHeight;

/**
 *  可以重写
 *  如果可以确定宽度 就要重写这个方法 而高度会根据自动布局来自动算出
 *  @return 返回view的高度
 */
- (CGFloat)viewWidth;

@end



#ifdef __IPHONE_11_0
@interface TFHeaderLayer : CALayer

@end
#endif

NS_ASSUME_NONNULL_END
