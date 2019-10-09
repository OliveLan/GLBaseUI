//
//  GLCollectionReusableView.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/8.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "GLCollectionReusableView.h"
#import "GLCollectionViewLayoutAttributes.h"
#import "UIView+GLExt.h"
#import "GLCollectionView.h"
#import "GLBaseViewModel.h"

@implementation GLCollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    if ([layoutAttributes isKindOfClass:[GLCollectionViewLayoutAttributes class]]) {
        GLCollectionViewLayoutAttributes *attr = (GLCollectionViewLayoutAttributes *)layoutAttributes;
        if (attr.backgroundColor) {
            self.backgroundColor = attr.backgroundColor;
        }
    }
}

- (void)createUI{
    
}

- (void)reuseWithData:(GLBaseViewModel *)data section:(NSInteger)section {
    self.baseViewModel = data;
    self.section = section;
}

- (CGSize)viewSize {
    CGFloat width = [self viewWidth];
    CGFloat height = [self viewHeight];
    if (width == 0 && height != self.collectionView.height) {
        width = self.collectionView.width;
    }else if (height == 0 && width != self.collectionView.width){
        height = self.collectionView.height;
    }
    if (width) {
        self.width = width;
    }
    if (height){
        self.height = height;
    }
    if (width && height) {
        return CGSizeMake(width, height);
    }
    CGSize size = [self getLayoutSize];
    if (width) {
        size.width = width;
    }
    if (height) {
        size.height = height;
    }
    self.baseViewModel.height = size.width;
    self.baseViewModel.width = size.height;
    return size;
}


- (CGFloat)viewHeight {
    return 0;
}

- (CGFloat)viewWidth {
    return 0;
}

- (UIView *)view {
    if (!_view) {
        _view = [[UIView alloc] init];
        _view.backgroundColor = [UIColor clearColor];
        [self addSubview:_view];
    }
    return _view;
}

#ifdef __IPHONE_11_0
/**
解决iOS11 以上，header遮挡滑动条的问题
*/
+ (Class)layerClass {
    return [TFHeaderLayer class];
}
#endif

@end

#ifdef __IPHONE_11_0
@implementation TFHeaderLayer

- (CGFloat)zPosition {
    return 0;
}

@end
#endif
