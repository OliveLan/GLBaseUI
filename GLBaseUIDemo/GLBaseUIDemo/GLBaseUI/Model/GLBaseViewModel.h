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

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (weak, nonatomic, readonly) UICollectionViewCell *cell;
@property (weak, nonatomic) UICollectionView *collectionView;
@property (nonatomic, weak) GLBaseWidgetModel *baseWidget;

@property(strong, nonatomic) NSString *randomReuseIdentifier;   // 随机生成的复用标志 当reuseEnable为false时候自动生成


/**
 根据collectionview 获取indexPath
 */
- (NSIndexPath *)indexPathWithCollectionview:(UICollectionView *)collectionview;

/**
 高度变化了 请用这个函数调用下
 */
- (void)heightChanged;

/**
 *  由子类重写
 *
 *  @return 复用标识 对应的cell类名字符串
 */
- (NSString *)reuseIdentifier;

/**
 *  复用视图类名
 *  NOTE: 可由子类继承（可选） 返回自定义类名（如果reuseIdentifier 和 类名不一致 需要继承重写该方法）
 *  默认和reuseIdentifier一致的类名
 */
- (Class)reuseViewClass;

- (void)setupCell:(UICollectionViewCell *)collectionviewCell;

@end

NS_ASSUME_NONNULL_END
