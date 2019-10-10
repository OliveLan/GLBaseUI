//
//  UIView+GLExt.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GLExt)

- (void)refreshLayout;

- (CGSize)getLayoutSize;

- (CGFloat)width;

- (void)setWidth:(CGFloat)width;

- (CGFloat)height;

- (void)setHeight:(CGFloat)height;

- (void)constraintWithEdgeZero;

- (CGFloat)bottom;

@end

NS_ASSUME_NONNULL_END
