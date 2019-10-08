//
//  GLBaseWidgetModel.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/8/20.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "GLBaseWidgetModel.h"
#import "GLBaseWidgetView.h"
#import "GLBaseHttpModel.h"
#import "GlobalDefine.h"
#import "GLBaseViewModel.h"
#import "YYModel.h"
#import "GLCollectionReusableViewModel.h"

@implementation GLBaseWidgetModel

#pragma mark - public
- (instancetype)init {
    self = [super init];
    if (self) {
        [self configWithData:nil];
    }
    return self;
}

- (instancetype)initWithData:(id)data {
    self = [super init];
    if (self) {
        [self configWithData:data];
    }
    return self;
}

- (void)configWithData:(id __nullable)data {
    
}

- (void)refreshingData {
    
}

- (void)loadingMoreData {
    
}

- (void)request {
    
}

/**
 发送请求
 使用该方法发送请求，会接收请求回调，并自动进行数据绑定
 @param dataModel 请求成功后，用于绑定数据的model
*/
- (void)requestWithDataModel:(id)dataModel {
    [self.baseNetwork request];
    kBlockWeakSelf
    self.baseNetwork.requestSuccessBlock = ^(id resultDic) {
        if (weakSelf.baseNetwork.requestType == REQUEST_TYPE_REFRESH) {
            [weakSelf.cellDataList removeAllObjects];
            [weakSelf.headerDataList removeAllObjects];
            [weakSelf.footerDataList removeAllObjects];
            weakSelf.cellDataList = nil;
            weakSelf.headerDataList = nil;
            weakSelf.footerDataList = nil;
            [weakSelf.baseWidgetView endRefreshing];
        } else {
            [weakSelf.baseWidgetView endLoadMore];
        }
        [weakSelf handleSuccessResult:resultDic dataModel:dataModel];
    };
    self.baseNetwork.requestErrorBlock = ^(id error) {
//        if (self.cellDataList.count == 0) {
//            weakSelf.baseWidgetView.emptyType = TF_FAIL_EMPTY;
//        }
        if (weakSelf.baseNetwork.requestType == REQUEST_TYPE_REFRESH) {
            [weakSelf.baseWidgetView endRefreshing];
        } else {
            [weakSelf.baseWidgetView endLoadMore];
        }
        [weakSelf handleFail:error];
    };
}

/**
 接受到了数据回调
 自动绑定数据
*/
- (void)handleSuccessResult:(id)result dataModel:(id)dataModel {
    if ([result isKindOfClass:[NSArray class]]) {
        NSMutableArray *subArr = [NSMutableArray array];
        for (id sub in result) {
            if ([sub isKindOfClass:[NSDictionary class]]) {
                // 只有一个section
                if ([dataModel isKindOfClass:[GLBaseViewModel class]]) {
                    GLBaseViewModel *model = (GLBaseViewModel *)[[dataModel class] yy_modelWithJSON:sub];
                    [subArr addObject:model];
                }
            } else if ([sub isKindOfClass:[NSArray class]]) {
                // 多个section
                for (NSDictionary *dic in sub) {
                    if ([dataModel isKindOfClass:[GLBaseViewModel class]]) {
                        GLBaseViewModel *model = (GLBaseViewModel *)[[dataModel class] yy_modelWithJSON:dic];
                        [subArr addObject:model];
                    }
                }
            }
        }
        [self.cellDataList addObject:subArr];
        if (self.baseNetwork.requestType == REQUEST_TYPE_REFRESH) {
//            self.baseWidgetView.emptyType = subArr.count > 0 ? TF_EMPTY_NOT_EMPTY : TF_DATA_EMPTY;
        }
    }
    [self.baseWidgetView reloadDataSource];
}

- (void)handleFail:(id)error {
    
}

#pragma mark - getter
- (NSMutableArray<GLBaseViewModel *> *)headerDataList {
    if (!_headerDataList) {
        GLCollectionReusableViewModel *noneDataModel = [GLCollectionReusableViewModel new];
        _headerDataList = [[NSMutableArray alloc] initWithObjects:noneDataModel, nil];
    }
    return _headerDataList;
}

- (NSMutableArray<GLBaseViewModel *> *)footerDataList {
    if (!_footerDataList) {
        GLBaseViewModel *noneDataModel = [GLBaseViewModel new];
        _footerDataList = [[NSMutableArray alloc] initWithObjects:noneDataModel, nil];
    }
    return _footerDataList;
}

- (NSMutableArray<NSMutableArray<GLBaseViewModel *> *> *)cellDataList {
    if (!_cellDataList) {
        _cellDataList = [NSMutableArray array];
    }
    return _cellDataList;
}

- (GLBaseHttpModel *)baseNetwork {
    if (!_baseNetwork) {
        _baseNetwork = [[GLBaseHttpModel alloc] init];
    }
    return _baseNetwork;
}

@end
