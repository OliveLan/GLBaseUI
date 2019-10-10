//
//  GLBaseViewModel.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/8/20.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLBaseWidgetModel;

NS_ASSUME_NONNULL_BEGIN

@interface GLBaseViewModel : NSObject

/**
 cell高度
 */
@property (nonatomic, assign) CGFloat height;

/**
 cell宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 对应的cell
 */
@property (weak, nonatomic, readonly) UICollectionViewCell *cell;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (nonatomic, weak) GLBaseWidgetModel *baseWidget;

@property(strong, nonatomic) NSString *randomReuseIdentifier;

/**
 由子类重写
 
 @return 复用标识 对应的cell类名字符串
 */
- (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
