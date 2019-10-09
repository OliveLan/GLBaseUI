//
//  GLCollectionViewCell.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "GLCollectionViewCell.h"
#import "GLBaseViewModel.h"
#import "UIView+GLExt.h"

@implementation GLCollectionViewCell

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
}

- (void)didSelectedCell {
    
}

- (void)refreshCellWithModel:(GLBaseViewModel *)data indexPath:(NSIndexPath *)indexPath {
    self.baseViewModel = data;
    self.indexPath = indexPath;
}

- (void)refreshCellSizeWithModel:(GLBaseViewModel *)model {
    self.baseViewModel = model;
}

#pragma mark - public

- (CGFloat)cellHeight {
    return 0;
}

- (CGFloat)cellWidth {
    return 0;
}

- (CGSize)cellSize {
    CGFloat width = [self cellWidth];
    CGFloat height = [self cellHeight];
    if (width) {
        self.width = width;
    }
    if (height){
        self.height = height;
    }
    if (width && height) {
        return CGSizeMake(width, height);
    }
    if (!width && !height) {
        width = [UIScreen mainScreen].bounds.size.width;
        self.width = width;
    }
    
    CGSize size = [self contentViewSize];
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

- (CGSize)contentViewSize{
    [self refreshLayout];
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

@end
