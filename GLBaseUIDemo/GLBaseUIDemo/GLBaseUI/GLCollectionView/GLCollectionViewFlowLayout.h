//
//  GLCollectionViewFlowLayout.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/8.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GLCollectionViewBgColorDelegate <NSObject>

- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section;

@end

@interface GLCollectionViewFlowLayout : UICollectionViewFlowLayout

/**
 是否为水平滚动，默认为NO
 */
@property (nonatomic, assign) BOOL isHorizontal;

/**
 是否使用横向滚动分页动画
 */
@property (nonatomic, assign) BOOL scrollAnimation;

@end

NS_ASSUME_NONNULL_END
