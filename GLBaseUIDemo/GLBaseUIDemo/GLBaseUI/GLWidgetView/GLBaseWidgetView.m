//
//  GLBaseWidgetView.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/8/20.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "GLBaseWidgetView.h"
#import "GLBaseWidgetModel.h"
#import "GLCollectionView.h"
#import "GLCollectionViewFlowLayout.h"
#import "GLBaseWidgetModel.h"
#import "GLBaseHttpModel.h"
#import "GlobalDefine.h"
#import "GLCollectionReusableViewModel.h"
#import "UIView+GLExt.h"
//#import "GLRefreshHeader.h"
//#import "GLRefreshFooter.h"

@interface GLBaseWidgetView () <GLCollectionViewDataSourceDelegate, GLCollectionViewScrollDelegate>

@property (nonatomic, strong) NSMutableArray * headerDataList;
@property (nonatomic, strong) NSMutableArray * cellDataList;
@property (nonatomic, strong) NSMutableArray * footerDataList;
@property (nonatomic, strong) NSMutableArray * decorationViewClassList;
@property (nonatomic, strong) NSMutableArray * widgets;
@property (nonatomic, assign) NSUInteger       requestingNum;
@property (nonatomic, assign) NSUInteger       requestFinishedNum;
@property (nonatomic, assign) BOOL             isHorizontal;
@property (nonatomic, assign) BOOL             scrollAnimation;

@end

@implementation GLBaseWidgetView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithIsHorizontal:(BOOL)isHorizontal scrollAnimation:(BOOL)scrollAnimation {
    self = [super init];
    if (self) {
        _isHorizontal = isHorizontal;
        _scrollAnimation = scrollAnimation;
        [self initConfig];
    }
    return self;
}

- (void)dealloc {
    
}

- (void)initConfig {
    [self.collectionView constraintWithEdgeZero];
    
    self.backgroundColor = [UIColor clearColor];
    self.headerDataList = [NSMutableArray new];
    self.cellDataList = [NSMutableArray new];
    self.footerDataList = [NSMutableArray new];
    self.decorationViewClassList = [NSMutableArray new];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    REQUEST_STATUS status = [[change objectForKey:@"new"] integerValue];
    if (status == REQUEST_STATUS_SUCCESS || status == REQUEST_STATUS_FAIL) {
        _requestFinishedNum ++;
    }
    
    if (_requestFinishedNum == _requestingNum) {
//        [self.collectionView.mj_header endRefreshing];
        _requestingNum = 0;
        _requestFinishedNum = 0;
    }
}

#pragma mark - 添加组件
- (void)addWidgets:(NSArray<GLBaseWidgetModel *> *)widgets {
    for (GLBaseWidgetModel *widget in widgets) {
        GLAssert([widget isKindOfClass:[GLBaseWidgetModel class]], @"widget 类型 不符");
        GLAssert(self.widgets.count <= self.widgets.count, @"section 超出范围");
        
        if ([widget isKindOfClass:[GLBaseWidgetModel class]]) {
            widget.baseWidgetView = self;
            [self.widgets insertObject:widget atIndex:self.widgets.count];
            self.collectionView.widgets = self.widgets;
        }
    }
    [self reloadDataSource];
}

- (void)insertWidget:(GLBaseWidgetModel *)widget section:(NSUInteger)section {
    GLAssert([widget isKindOfClass:[GLBaseWidgetModel class]], @"widget 类型 不符");
    GLAssert(self.widgets.count <= section, @"section 超出范围");
    if ([widget isKindOfClass:[GLBaseWidgetModel class]]) {
        widget.baseWidgetView = self;
        [self.widgets insertObject:widget atIndex:section];
        self.collectionView.widgets = self.widgets;
        [self reloadDataSource];
    }
}

#pragma mark - refresh && loadMore
- (void)addRefreshHeaderWithBlock:(GLRefreshingBlock)refreshing {
    
}

- (void)addRefreshFooterWithBlock:(GLRefreshingBlock)refreshing {
    
}

- (void)refreshAllWidgets {
    _requestingNum = 0;
    _requestFinishedNum = 0;
//    self.emptyType = TF_LOADING_EMPTY;
    for (GLBaseWidgetModel *widget in self.widgets) {
        if ([widget isKindOfClass:[GLBaseWidgetModel class]]) {
            self.requestingNum ++;
            [widget request];
            [widget.baseNetwork addObserver:self forKeyPath:@"requestStatus" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
}

- (void)beginRefreshing {
    
}

- (void)beginLoadMore {
    
}

- (void)endRefreshing {
    
}

- (void)endLoadMore {
    
}

- (void)endLoadMoreWithNoMoreData {
    
}

- (void)showHorizontalEmptyFooter {
    
}

- (void)hiddenHorizontalEmptyFooter {
    
}

#pragma mark - private
/**
 根据数据源刷新界面
 */
- (void)reloadDataSource {
    self.headerDataList = nil;
    self.footerDataList = nil;
    self.cellDataList = nil;
    for (GLBaseWidgetModel *widgetModel in self.widgets) {
        [self.headerDataList addObjectsFromArray:widgetModel.headerDataList];
        [self.footerDataList addObjectsFromArray:widgetModel.footerDataList];
        [self.cellDataList addObjectsFromArray:widgetModel.cellDataList];
    }
    [self.collectionView reloadData];
}

#pragma mark - TFCollectionViewDataSourceDelegate
- (NSMutableArray<GLBaseViewModel *> *)cellDataListWithCollectionView:(GLCollectionView *)collectionView {
    return self.cellDataList;
}

- (NSMutableArray<GLCollectionReusableViewModel *> *)headerDataListWithCollectionView:(GLCollectionView *)collectionView {
    return self.headerDataList;
}

- (NSMutableArray<GLBaseViewModel *> *)footerDataListWithCollectionView:(GLCollectionView *)collectionView {
    return self.footerDataList;
}

#pragma mark - TFCollectionViewScrollDelegate
- (void)tfscrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(collectionDidScroll:)]) {
        [self.delegate collectionDidScroll:scrollView];
    }
}

- (void)tfscrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(collectionDidEndDecelerating:)]) {
        [self.delegate collectionDidEndDecelerating:scrollView];
    }
}

- (void)tfscrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(collectionWillBeginDragging:)]) {
        [self.delegate collectionWillBeginDragging:scrollView];
    }
}

#pragma mark - getter
- (GLCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [GLCollectionView createFlowLayoutWithDirection:_isHorizontal scrollAnimation:_scrollAnimation];
        _collectionView.dataSourceDelegate = self;
        _collectionView.scrollDelegate = self;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableArray *)widgets {
    if (!_widgets) {
        _widgets = [NSMutableArray array];
    }
    return _widgets;
}

- (NSMutableArray *)headerDataList {
    if (!_headerDataList) {
        _headerDataList = [NSMutableArray array];
    }
    return _headerDataList;
}

- (NSMutableArray *)footerDataList {
    if (!_footerDataList) {
        _footerDataList = [NSMutableArray array];
    }
    return _footerDataList;
}

- (NSMutableArray *)cellDataList {
    if (!_cellDataList) {
        _cellDataList = [NSMutableArray array];
    }
    return _cellDataList;
}

@end
