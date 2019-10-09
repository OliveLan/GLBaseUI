//
//  GLCollectionView.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/8/20.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "GLCollectionView.h"
#import "GLCollectionViewFlowLayout.h"
#import "GlobalDefine.h"
#import "GLCollectionReusableView.h"
#import "GLCollectionViewCell.h"
#import "GLBaseViewModel.h"
#import "GLBaseWidgetModel.h"
#import "GLCollectionReusableViewModel.h"

@interface GLCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GLCollectionViewBgColorDelegate>

@property (nonatomic, copy) NSString * cellReuseIdentifier;
@property (nonatomic, copy) NSString * headerReuseIdentifier;
@property (nonatomic, copy) NSString * footerReuseIdentifier;

@property (nonatomic, strong) NSMutableDictionary *cellDataDic;
@property (nonatomic, strong) NSMutableDictionary *headerDataDic;
@property (nonatomic, strong) NSMutableDictionary *footerDataDic;

@property (nonatomic, strong) NSMutableDictionary *cacheCellDic;
@property (nonatomic, strong) NSMutableDictionary *cacheHeaderDic;
@property (nonatomic, strong) NSMutableDictionary *cacheFooterDic;

@end

@implementation GLCollectionView

#pragma mark - create
+ (instancetype)createWithFlowLayout {
    UICollectionViewFlowLayout *layout = [GLCollectionViewFlowLayout new];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return [self createWithLayout:layout];
}

+ (instancetype)createFlowLayoutWithDirection:(BOOL)isHorizontal scrollAnimation:(BOOL)scrollAnimation {
    GLCollectionViewFlowLayout *layout = [GLCollectionViewFlowLayout new];
    layout.isHorizontal = isHorizontal;
    layout.scrollAnimation = scrollAnimation;
    layout.scrollDirection = isHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical;
    return [self createWithLayout:layout];
}

+ (instancetype)createWithLayout:(UICollectionViewLayout *)layout {
    return [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.layout = layout;
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    self.backgroundColor = [UIColor clearColor];
    self.dataSource = self;
    self.delegate = self;
    self.alwaysBounceVertical = YES;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

#pragma mark - private
- (NSMutableArray *)handleSectionDataListWithSection:(NSInteger)section {
    if ([self.dataSourceDelegate respondsToSelector:@selector(cellDataListWithCollectionView:)]) {
        // 从GLBaseWidgetView中获取数据
        NSMutableArray *arr = [self.dataSourceDelegate cellDataListWithCollectionView:self];
        if (arr.count > section) {
            id dataList = [arr objectAtIndex:section];
            if (![dataList isKindOfClass:[NSArray class]]) {
                if (section == 0) {
                    return arr;
                } else {
                    GLAssert(0, @"array 数据单元不是数组");
                }
            } else {
                return dataList;
            }
        }
    } else {
        GLAssert(0, @"没实现cellDataList");
    }
    return nil;
}

- (NSMutableArray *)handleCellDataWithSection:(NSInteger)section row:(NSInteger)row {
    NSArray *sectionData = [self handleSectionDataListWithSection:section];
    if (sectionData.count > row) {
        return [sectionData objectAtIndex:row];
    }
    return nil;
}

- (GLCollectionReusableView *)getCacheHeaderWithReuseIdentifier:(NSString *)identifier {
    if (identifier == nil) {
        identifier = self.headerReuseIdentifier;
    }
    GLCollectionReusableView * cacheHeader = [self.cacheHeaderDic objectForKey:identifier];
    if (!cacheHeader || ![cacheHeader isKindOfClass:[GLCollectionReusableView class]]) {
        cacheHeader = [[NSClassFromString(identifier) alloc] init];
        QAssert(cacheHeader);  //identifier 错误 不是类名
        QAssert([cacheHeader isKindOfClass:[GLCollectionReusableView class]]);
        cacheHeader.collectionView = self;
        [self.cacheHeaderDic setObject:cacheHeader forKey:identifier];
    }
    return cacheHeader;
}

- (GLCollectionReusableView *)getCacheFooterWithReuseIdentifier:(NSString *)identifier {
    if (identifier == nil) {
        identifier = self.footerReuseIdentifier;
    }
    GLCollectionReusableView * cacheFooter = [self.cacheFooterDic objectForKey:identifier];
    if (!cacheFooter || ![cacheFooter isKindOfClass:[GLCollectionReusableView class]]) {
        cacheFooter = [[NSClassFromString(identifier) alloc] init];
        QAssert(cacheFooter);  //identifier 错误 不是类名
        QAssert([cacheFooter isKindOfClass:[GLCollectionReusableView class]]);
        cacheFooter.collectionView = self;
        [self.cacheFooterDic setObject:cacheFooter forKey:identifier];
    }
    return cacheFooter;
}

/**  获得cell缓存 */
- (GLCollectionViewCell *)getCacheCellWithReuseIdentifier:(NSString *)identifier {
    if (identifier == nil) {
        identifier = self.cellReuseIdentifier;
    }
    GLCollectionViewCell *cacheCell = [self.cacheCellDic objectForKey:identifier];
    if (!cacheCell || ![cacheCell isKindOfClass:[GLCollectionViewCell class]]) {
        cacheCell = [[NSClassFromString(identifier) alloc] init];
        GLAssert(cacheCell,@"identifier 错误 不是类名 data 未返回复用标识");
        QAssert([cacheCell isKindOfClass:[GLCollectionViewCell class]]);
        cacheCell.collectionView = self;
        [self.cacheCellDic setObject:cacheCell forKey:identifier];
    }
    return cacheCell;
}

/** 获取headder视图 */
- (GLCollectionReusableView *)getHeaderViewWithIndexPath:(NSIndexPath *)indexPath kind:(NSString *)kind {
    if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)] && [self.dataSourceDelegate headerDataListWithCollectionView:self].count > 0) {
        NSArray *headerList = [self.dataSourceDelegate headerDataListWithCollectionView:self];
        id data;
        if (headerList.count > indexPath.section) {
            data = [headerList objectAtIndex:indexPath.section];
        }
        if (data) {
            GLBaseViewModel *viewModel = (GLBaseViewModel *)data;
            QAssert([data isKindOfClass:[GLBaseViewModel class]]);
            
            NSString *reuseIdentifier = [viewModel reuseIdentifier];
            if (reuseIdentifier == nil) {
                reuseIdentifier = self.headerReuseIdentifier;
            }
            
            GLCollectionReusableView * view = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            QAssert(view && [view isKindOfClass:[GLCollectionReusableView class]]);
            
            view.collectionView = self;
            [view reuseWithData:viewModel section:indexPath.section];
            view.userInteractionEnabled = YES;
            view.tag = 100000+indexPath.section;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedCollectionHeader:)];
            [view addGestureRecognizer:tap];
            return view;
        }
    }
    [self registerHeaderClassIfNeedWithIdentifier:@"GLCollectionReusableView"];
    return [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"GLCollectionReusableView" forIndexPath:indexPath];
}

/** 获取footer视图 */
- (GLCollectionReusableView *)getFooterViewWithIndexPath:(NSIndexPath *)indexPath kind:(NSString *)kind {
    if ([self.dataSourceDelegate respondsToSelector:@selector(footerDataListWithCollectionView:)] && [self.dataSourceDelegate footerDataListWithCollectionView:self].count > 0) {
        NSArray *footerList = [self.dataSourceDelegate footerDataListWithCollectionView:self];
        id data;
        if (footerList.count > indexPath.section) {
            data = [footerList objectAtIndex:indexPath.section];
        }
        if (data) {
            GLBaseViewModel *viewModel = (GLBaseViewModel *)data;
            QAssert([data isKindOfClass:[GLBaseViewModel class]]);
            
            NSString * reuseIdentifier = [viewModel reuseIdentifier];
            if (reuseIdentifier == nil) {
                reuseIdentifier = self.footerReuseIdentifier;
            }
            
            GLCollectionReusableView * view = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            QAssert(view && [view isKindOfClass:[GLCollectionReusableView class]]);
            
            view.collectionView = self;
            [view reuseWithData:viewModel section:indexPath.section];
            return view;
        }
    }
    [self registerFooterClassIfNeedWithIdentifier:@"GLCollectionReusableView"];
    return [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"GLCollectionReusableView" forIndexPath:indexPath];
}

- (void)didSelectedCollectionHeader:(UIGestureRecognizer *)gesture {
    NSInteger section = gesture.view.tag - 100000;
    if (_selectedHeaderBlock) {
        _selectedHeaderBlock(section);
    }
}

#pragma mark - registerCell
- (void)registerCellWithReuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath {
    [self registerUnEeuseCellWithChangeIdentifier:reuseIdentifier reuseIdentifier:reuseIdentifier indexPath:indexPath];
}

- (void)registerUnEeuseCellWithChangeIdentifier:(NSString *)changeIdentifier reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSIndexPath *)indexPath {
    if (reuseIdentifier) {
        GLCollectionViewCell *cacheCell = [self.cacheCellDic objectForKey:changeIdentifier];
        if (!cacheCell) {
            Class cellClass = NSClassFromString(reuseIdentifier);
            if(!cellClass) {
                return;
            }
            GLAssert(cellClass, @"identifier 不是类名 ");
            
            [self registerClass:cellClass forCellWithReuseIdentifier:reuseIdentifier];
            // 缓存cell
            [self.cacheCellDic setObject:cellClass forKey:changeIdentifier];
        }
    }
}

- (void)registerHeaderClassIfNeedWithIdentifier:(NSString *)identifier orignIdentifier:(NSString *)orignIdentifier {
    if (identifier.length && orignIdentifier.length) {
        GLCollectionReusableView *cacheHeader = [self.cacheHeaderDic objectForKey:identifier];
        if (!cacheHeader) {
            Class headerClass = NSClassFromString(orignIdentifier);
            if(!headerClass) {
                return;
            }
            QAssert(headerClass); //identifier 错误 不是类名
            [self registerHeaderClass:headerClass];
            [self.cacheHeaderDic setObject:headerClass forKey:identifier];
        }
    }
}

- (void)registerHeaderClass:(Class)headerClass {
    QAssert(headerClass);
    self.headerReuseIdentifier = NSStringFromClass(headerClass);
    [self registerClass:headerClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.headerReuseIdentifier];
}

- (void)registerHeaderClassIfNeedWithIdentifier:(NSString *) identifier{
    [self registerHeaderClassIfNeedWithIdentifier:identifier orignIdentifier:identifier];
}

- (void)registerFooterClassIfNeedWithIdentifier:(NSString *)identifier orignIdentifier:(NSString *)orignIdentifier {
    if (identifier.length && orignIdentifier.length) {
        GLCollectionReusableView * cacheFooter = [self.cacheHeaderDic objectForKey:identifier];
        if (!cacheFooter) {
            Class footerClass = NSClassFromString(orignIdentifier);
            if(!footerClass) {
                return;
            }
            QAssert(footerClass); //identifier 错误 不是类名
            [self registerFooterClass:footerClass];
            [self.cacheFooterDic setObject:footerClass forKey:identifier];
        }
    }
}

- (void)registerFooterClass:(Class)headerClass {
    QAssert(headerClass);
    self.footerReuseIdentifier = NSStringFromClass(headerClass);
    [self registerClass:headerClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:self.footerReuseIdentifier];
}

- (void)registerFooterClassIfNeedWithIdentifier:(NSString *) identifier{
    [self registerFooterClassIfNeedWithIdentifier:identifier orignIdentifier:identifier];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GLCollectionViewCell *cell = (GLCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[GLCollectionViewCell class]]) {
        cell.indexPath = indexPath;
        [cell didSelectedCell];
    }
    if (_selectedRowBlock) {
        _selectedRowBlock(indexPath);
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self.dataSourceDelegate respondsToSelector:@selector(cellDataListWithCollectionView:)]) {
        NSArray * array = [self.dataSourceDelegate cellDataListWithCollectionView:self];
        if (array.count > 0) {
            if ([[array objectAtIndex:0] isKindOfClass:[NSArray class]]) {
                return array.count;
            }else {
                return 1;
            }
        }else {
            return 1;
        }
    } else if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)]) {
        NSArray * array = [self.dataSourceDelegate headerDataListWithCollectionView:self];
        if (array) {
            return array.count;
        }else {
            return 0;
        }
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [self handleSectionDataListWithSection:section].count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id data = [self handleCellDataWithSection:indexPath.section row:indexPath.row];
    GLCollectionViewCell *cell;
    if ([data isKindOfClass:[GLBaseViewModel class]]) {
        
        GLBaseViewModel *baseViewModel = (GLBaseViewModel *)data;
        
        NSString * reuseIdentifier = [baseViewModel reuseIdentifier];
        if (reuseIdentifier == nil) {
            reuseIdentifier = self.cellReuseIdentifier;
        }
        
        [self registerCellWithReuseIdentifier:reuseIdentifier indexPath:indexPath];
        
        cell = [self dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.collectionView = self;
        cell.baseViewModel = baseViewModel;
        [cell refreshCellWithModel:data indexPath:indexPath];
    } else {
        GLAssert([data isKindOfClass:[GLBaseViewModel class]], @"cell数据源不是TFBaseViewModel类型");
    }
    
    if (cell) {
        cell.collectionView = self;
        return cell;
    } else {
        [self registerCellWithReuseIdentifier:@"GLCollectionCell" indexPath:indexPath];
        return [self dequeueReusableCellWithReuseIdentifier:@"GLCollectionCell" forIndexPath:indexPath];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [self getHeaderViewWithIndexPath:indexPath kind:kind];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [self getFooterViewWithIndexPath:indexPath kind:kind];
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
/** item大小 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id data = [self handleCellDataWithSection:indexPath.section row:indexPath.row];
    if (data) {
        GLBaseViewModel *model = (GLBaseViewModel *)data;
        
        NSString * reuseIdentifier = [model reuseIdentifier];
        if (reuseIdentifier == nil) {
            reuseIdentifier = self.cellReuseIdentifier;
        }
        
        [self registerCellWithReuseIdentifier:reuseIdentifier indexPath:indexPath];
        
        GLCollectionViewCell * cacheCell = [self getCacheCellWithReuseIdentifier:[model reuseIdentifier]];
            
        if ((cacheCell.baseViewModel.height > 0 && cacheCell.baseViewModel.width > 0)) {
            model.width = cacheCell.baseViewModel.width;
            model.height = cacheCell.baseViewModel.height;
            return CGSizeMake(cacheCell.baseViewModel.width, cacheCell.baseViewModel.height);
        }
        [cacheCell refreshCellSizeWithModel:model];
        CGSize size =  [cacheCell cellSize];
        model.width = size.width;
        model.height = size.height;
        if (model.height == 0) {
            model.height = 0.01;
        }
        return CGSizeMake(model.width, model.height);
    }
    return CGSizeMake(0.01, 0.01);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)] && [self.dataSourceDelegate headerDataListWithCollectionView:self]) {
        NSArray *headerList = [self.dataSourceDelegate headerDataListWithCollectionView:self];
        id data;
        if (headerList.count > section) {
            data = [headerList objectAtIndex:section];
        }
        if (data) {
            GLBaseViewModel * viewModel = ((GLBaseViewModel *)data);
            QAssert([data isKindOfClass:[GLBaseViewModel class]]);//要继承ReuseDataBase
            [self registerHeaderClassIfNeedWithIdentifier:[viewModel reuseIdentifier]];
            if ([self.layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                if (viewModel.width == 0 && viewModel.height == 0) {
                    CGSize size = ((UICollectionViewFlowLayout *)self.layout).headerReferenceSize ;
                    viewModel.width = size.width;
                    viewModel.height = size.height;
                }
            }
            if (viewModel.height == 0 || viewModel.width == 0) {
                GLCollectionReusableView * cacheHeader = [self getCacheHeaderWithReuseIdentifier:[viewModel reuseIdentifier]];
                
                if (cacheHeader.baseViewModel.height > 0 && cacheHeader.baseViewModel.width > 0) {
                    viewModel.width = cacheHeader.baseViewModel.width;
                    viewModel.height = cacheHeader.baseViewModel.height;
                    return CGSizeMake(cacheHeader.baseViewModel.width, cacheHeader.baseViewModel.height);
                }
                
                [cacheHeader reuseWithData:viewModel section:section];
                CGSize size  = [cacheHeader viewSize];
                viewModel.width = size.width;
                viewModel.height = size.height;
                return size;
            }
            return CGSizeMake(viewModel.width, viewModel.height);
        }else {
            [self registerHeaderClassIfNeedWithIdentifier:@"GLCollectionReusableView"];
        }
    } else {
        [self registerHeaderClassIfNeedWithIdentifier:@"GLCollectionReusableView"];
    }
    return CGSizeMake(0.001, 0.001);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self.dataSourceDelegate respondsToSelector:@selector(footerDataListWithCollectionView:)] && [self.dataSourceDelegate footerDataListWithCollectionView:self]) {
        NSArray *footerList = [self.dataSourceDelegate footerDataListWithCollectionView:self];
        id data;
        if (footerList.count > section) {
            data = [footerList objectAtIndex:section];
        }
        if (data) {
            GLBaseViewModel * viewModel = ((GLBaseViewModel *)data);
            QAssert([data isKindOfClass:[GLBaseViewModel class]]);
            [self registerFooterClassIfNeedWithIdentifier:[viewModel reuseIdentifier]];
            if ([self.layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                if (viewModel.width == 0 && viewModel.height == 0) {
                    CGSize size = ((UICollectionViewFlowLayout *)self.layout).headerReferenceSize ;
                    viewModel.width = size.width;
                    viewModel.height = size.height;
                }
            }
            if (viewModel.height == 0 || viewModel.width == 0) {
                GLCollectionReusableView *cacheFooter = [self getCacheFooterWithReuseIdentifier:[viewModel reuseIdentifier]];
                
                if (cacheFooter.baseViewModel.height > 0 && cacheFooter.baseViewModel.width > 0) {
                    viewModel.width = cacheFooter.baseViewModel.width;
                    viewModel.height = cacheFooter.baseViewModel.height;
                    return CGSizeMake(cacheFooter.baseViewModel.width, cacheFooter.baseViewModel.height);
                }
                
                [cacheFooter reuseWithData:viewModel section:section];
                CGSize size  = [cacheFooter viewSize];
                viewModel.width = size.width;
                viewModel.height = size.height;
                return size;
            }
            return CGSizeMake(viewModel.width, viewModel.height);
        }else {
            [self registerHeaderClassIfNeedWithIdentifier:@"GLCollectionReusableView"];
        }
    } else {
        [self registerHeaderClassIfNeedWithIdentifier:@"GLCollectionReusableView"];
    }
    return CGSizeMake(0.001, 0.001);
}

/** item横向间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.flowLayoutDelegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    if (self.widgets.count > section) {
        GLBaseWidgetModel *widget = [self.widgets objectAtIndex:section];
        if (widget.minimumInteritemSpacing > 0) {
            return widget.minimumInteritemSpacing;
        }
    }
    if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)]) {
        NSArray *list = [self.dataSourceDelegate headerDataListWithCollectionView:self];
        if (list.count > section) {
            GLCollectionReusableViewModel *header = [list objectAtIndex:section];
            if ([header isKindOfClass:[GLCollectionReusableViewModel class]]) {
                return header.minimumInteritemSpacing;
            }
        }
    }
    
    return 0.f;
}

/** item纵向间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.flowLayoutDelegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }
    if (self.widgets.count > section) {
        GLBaseWidgetModel *widget = [self.widgets objectAtIndex:section];
        if (widget.minimumLineSpacing > 0) {
            return widget.minimumLineSpacing;
        }
    }
    if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)]) {
        NSArray *list = [self.dataSourceDelegate headerDataListWithCollectionView:self];
        if (list.count > section) {
            GLCollectionReusableViewModel *header = [list objectAtIndex:section];
            if ([header isKindOfClass:[GLCollectionReusableViewModel class]]) {
                return header.minimumLineSpacing;
            }
        }
    }
    
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([self.flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.flowLayoutDelegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    GLBaseWidgetModel *widget;
    if (self.widgets.count > section) {
        widget = [self.widgets objectAtIndex:section];
    } else {
        widget = [self.widgets lastObject];
    }
    if (widget.isResetSectionInset) {
        sectionInset = widget.sectionInset;
        return sectionInset;
    }
    
    if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)]) {
        NSArray *list = [self.dataSourceDelegate headerDataListWithCollectionView:self];
        if (list.count > section) {
            GLCollectionReusableViewModel *header = [list objectAtIndex:section];
            if ([header isKindOfClass:[GLCollectionReusableViewModel class]]) {
                return header.sectionInset;
            }
        }
    }
    return sectionInset;
}

#pragma mark - TFCollectionViewBgColorDelegate
- (UIColor *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout backgroundColorForSection:(NSInteger)section {
    if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataListWithCollectionView:)]) {
        NSArray *list = [self.dataSourceDelegate headerDataListWithCollectionView:self];
        if (list.count > section) {
            GLCollectionReusableViewModel *header = [list objectAtIndex:section];
            if ([header isKindOfClass:[GLCollectionReusableViewModel class]] && header.sectionBgColor) {
                return header.sectionBgColor;
            }
        }
    }
    
    GLBaseWidgetModel *widget;
    if (self.widgets.count > section) {
        widget = [self.widgets objectAtIndex:section];
    } else {
        widget = [self.widgets lastObject];
    }
    if (widget.sectionBgColor != nil) {
        return widget.sectionBgColor;
    }
    
    return [UIColor clearColor];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(glScrollViewDidScroll:)]) {
        [self.scrollDelegate glScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(glScrollViewDidEndDecelerating:)]) {
        [self.scrollDelegate glScrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.scrollDelegate respondsToSelector:@selector(glScrollViewWillBeginDragging:)]) {
        [self.scrollDelegate glScrollViewWillBeginDragging:scrollView];
    }
}

#pragma mark - setter
- (NSMutableDictionary *)cellDataDic {
    if (!_cellDataDic) {
        _cellDataDic = [NSMutableDictionary dictionary];
    }
    return _cellDataDic;
}

- (NSMutableDictionary *)headerDataDic {
    if (!_headerDataDic) {
        _headerDataDic = [NSMutableDictionary dictionary];
    }
    return _headerDataDic;
}

- (NSMutableDictionary *)footerDataDic {
    if (!_footerDataDic) {
        _footerDataDic = [NSMutableDictionary dictionary];
    }
    return _footerDataDic;
}

- (NSMutableDictionary *)cacheCellDic {
    if (!_cacheCellDic) {
        _cacheCellDic = [NSMutableDictionary dictionary];
    }
    return _cacheCellDic;
}

- (NSMutableDictionary *)cacheFooterDic {
    if (!_cacheFooterDic) {
        _cacheFooterDic = [NSMutableDictionary dictionary];
    }
    return _cacheFooterDic;
}

- (NSMutableArray <GLBaseWidgetModel *> *)widgets {
    if (!_widgets) {
        _widgets = [NSMutableArray array];
    }
    return _widgets;
}

@end
