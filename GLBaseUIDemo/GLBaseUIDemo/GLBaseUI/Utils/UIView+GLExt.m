//
//  UIView+GLExt.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "UIView+GLExt.h"
#import "Masonry.h"

@implementation UIView (GLExt)

- (CGSize)getLayoutSize {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self needsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    return [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

/**
 刷新布局
 */
- (void)refreshLayout {
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
}

- (void)constraintWithEdgeZero {
    [self constraintWithEdge:UIEdgeInsetsZero];
}

- (void)constraintWithEdge:(UIEdgeInsets)edge {
    assert(self.superview != nil);
    [self mas_remakeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.superview).offset(edge.top);
        make.left.equalTo(self.superview).offset(edge.left);
        make.right.equalTo(self.superview).offset(-edge.right);
        make.bottom.equalTo(self.superview).offset(-edge.bottom);
    }];
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

@end
