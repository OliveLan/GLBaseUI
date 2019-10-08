//
//  GLCollectionReusableViewModel.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/9/30.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "GLBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLCollectionReusableViewModel : GLBaseViewModel

@property (nonatomic, assign) CGFloat   minimumInteritemSpacing;    // item横向间距
@property (nonatomic, assign) CGFloat   minimumLineSpacing;         // item纵向间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;            // section边距
@property (nonatomic, strong) UIColor   *sectionBgColor;            // 每个section的背景色

@end

NS_ASSUME_NONNULL_END
