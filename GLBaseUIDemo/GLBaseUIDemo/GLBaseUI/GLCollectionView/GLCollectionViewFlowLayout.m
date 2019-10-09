//
//  GLCollectionViewFlowLayout.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/8.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "GLCollectionViewFlowLayout.h"
#import "GLCollectionReusableView.h"
#import "GLCollectionViewLayoutAttributes.h"
#import "GLCollectionView.h"
#import "GLCollectionReusableViewModel.h"
#import "GLBaseWidgetModel.h"

@interface GLCollectionViewFlowLayout ()

@property (nonatomic, assign) CGPoint lastOffset;       // 记录上次滑动停止时contentOffset值
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end

NSString *const GLCollectionViewSectionBackground = @"GLCollectionViewSectionBackground";

@implementation GLCollectionViewFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.decorationViewAttrs = [NSMutableArray array];
        [self registerClass:[GLCollectionReusableView class] forDecorationViewOfKind:GLCollectionViewSectionBackground];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.scrollDirection = _isHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    if (_isHorizontal && _scrollAnimation) {
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    [self.decorationViewAttrs removeAllObjects];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    id delegate = self.collectionView.delegate;
    if (!numberOfSections || ![delegate conformsToProtocol:@protocol(GLCollectionViewBgColorDelegate)]) {
        return;
    }
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        if (numberOfItems <= 0) {
            continue;
        }
        UICollectionViewLayoutAttributes *firstItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        UICollectionViewLayoutAttributes *lastItem = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:numberOfItems - 1 inSection:section]];
        if (!firstItem || !lastItem) {
            continue;
        }
        
        UIEdgeInsets sectionInset = [self sectionInset];
        
        if ([delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
            UIEdgeInsets inset = [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
            sectionInset = inset;
        }
        
        
        CGRect sectionFrame = CGRectUnion(firstItem.frame, lastItem.frame);
        
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            sectionFrame.size.width += sectionInset.left + sectionInset.right;
            sectionFrame.size.height = self.collectionView.frame.size.height;
        } else {
            sectionFrame.size.width = self.collectionView.frame.size.width - sectionInset.left - sectionInset.right;
        }
        
        // 修改section背景
        GLCollectionViewLayoutAttributes *attr = [GLCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:GLCollectionViewSectionBackground withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        attr.frame = sectionFrame;
        attr.zIndex = -1;
        
        attr.backgroundColor = [delegate collectionView:self.collectionView layout:self backgroundColorForSection:section];
        [self.decorationViewAttrs addObject:attr];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for (UICollectionViewLayoutAttributes *attr in self.decorationViewAttrs) {
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [answer addObject:attr];
        }
    }
    
    if (_isHorizontal == YES) {
        return answer;
    }
    /* 处理左右间距 解决item之间间隙不为0的问题 */
    for(int i = 1; i < [answer count]; ++i) {

        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];

        BOOL isZeroSpacing = NO;
        if ([self.collectionView isKindOfClass:[GLCollectionView class]] && currentLayoutAttributes.indexPath.row != 0) {
            GLCollectionView *curCollectionView = (GLCollectionView *)self.collectionView;

            if ([curCollectionView.flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
                isZeroSpacing = [curCollectionView.flowLayoutDelegate collectionView:curCollectionView layout:self minimumInteritemSpacingForSectionAtIndex:currentLayoutAttributes.indexPath.section] == 0;
            }
            if ([curCollectionView.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)]) {
                NSArray *list = [curCollectionView.dataSourceDelegate headerDataListWithCollectionView:curCollectionView];
                if (list.count > currentLayoutAttributes.indexPath.section) {
                    GLCollectionReusableViewModel *header = [list objectAtIndex:currentLayoutAttributes.indexPath.section];
                    if ([header isKindOfClass:[GLCollectionReusableViewModel class]]) {
                        isZeroSpacing = header.minimumInteritemSpacing == 0;
                    }
                }
            }
            if (curCollectionView.widgets.count > currentLayoutAttributes.indexPath.section) {
                GLBaseWidgetModel *widget = (GLBaseWidgetModel *)[curCollectionView.widgets objectAtIndex:currentLayoutAttributes.indexPath.section];

                if (widget.minimumInteritemSpacing > 0) {
                    isZeroSpacing = NO;
                }
            }
            
            if (isZeroSpacing) {
                NSInteger maximumSpacing = 0;
                NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
                if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width && currentLayoutAttributes.frame.origin.y == prevLayoutAttributes.frame.origin.y) {
                    CGRect frame = currentLayoutAttributes.frame;
                    frame.origin.x = origin + maximumSpacing;
                    currentLayoutAttributes.frame = frame;
                }
            }
        }
    }
    return answer;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString*)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:GLCollectionViewSectionBackground]) {
        return [self.decorationViewAttrs objectAtIndex:indexPath.section];
    }
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    if (!_scrollAnimation) return proposedContentOffset;
    
    CGFloat pageSpace = [self stepSpace];//计算分页步距
    CGFloat offsetMax = self.collectionView.contentSize.width - (pageSpace + self.sectionInset.right);
    CGFloat offsetMin = 0;
    /*修改之前记录的位置，如果小于最小contentsize或者大于最大contentsize则重置值*/
    if (_lastOffset.x<offsetMin) {
        _lastOffset.x = offsetMin;
    } else if (_lastOffset.x>offsetMax) {
        _lastOffset.x = offsetMax;
    }
    
    CGFloat offsetForCurrentPointX = ABS(proposedContentOffset.x - _lastOffset.x);//目标位移点距离当前点的距离绝对值
    CGFloat velocityX = velocity.x;
    BOOL direction = (proposedContentOffset.x - _lastOffset.x) > 0;//判断当前滑动方向,手指向左滑动：YES；手指向右滑动：NO
    
    if (offsetForCurrentPointX > pageSpace/8. && _lastOffset.x>=offsetMin && _lastOffset.x<=offsetMax) {
        NSInteger pageFactor = 0;
        if (velocityX != 0) {
            /*滑动*/
            pageFactor = ABS(velocityX);//速率越快，cell滑过数量越多
        } else {
            /**
             * 拖动
             * 没有速率，则计算：位移差/默认步距=分页因子
             */
            pageFactor = ABS(offsetForCurrentPointX/pageSpace);
        }
        
        /*设置pageFactor上限为2, 防止滑动速率过大，导致翻页过多*/
        pageFactor = pageFactor<1?1:(pageFactor<3?1:2);
        
        CGFloat pageOffsetX = pageSpace*pageFactor;
        proposedContentOffset = CGPointMake(_lastOffset.x + (direction?pageOffsetX:-pageOffsetX), proposedContentOffset.y);
    } else {
        /*滚动距离，小于翻页步距一半，则不进行翻页操作*/
        proposedContentOffset = CGPointMake(_lastOffset.x, _lastOffset.y);
    }
    
    //记录当前最新位置
    _lastOffset.x = proposedContentOffset.x;
    return proposedContentOffset;
}

/**
 *计算每滑动一页的距离：步距
 */
- (CGFloat)stepSpace {
    GLCollectionView *collection = (GLCollectionView *)self.collectionView;
    if (collection.widgets.count > 0) {
        GLBaseWidgetModel *widget = (GLBaseWidgetModel *)[collection.widgets objectAtIndex:0];
        NSArray *list = [widget.cellDataList objectAtIndex:0];
        CGFloat cellWidth = 0;
        if (list.count > 0) {
            GLBaseViewModel *viewModel = [list objectAtIndex:0];
            cellWidth = viewModel.width;
        }
        
        CGFloat lineSpacing = widget.minimumLineSpacing;
        return cellWidth + lineSpacing;
    }
    return 0;
}

@end
