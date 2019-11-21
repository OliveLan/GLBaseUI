//
//  NormalListWidgetModel.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "NormalListWidgetModel.h"
#import "NormalListHttpModel.h"
#import "NormalListViewModel.h"
#import "NormalReusableViewModel.h"

@interface NormalListWidgetModel ()


@end

@implementation NormalListWidgetModel

- (void)configWithData:(id)data {
    NormalListHttpModel *httpModel = [[NormalListHttpModel alloc] init];
    self.baseNetwork = httpModel;
    /** 开始请求数据 并在请求成功后 自动绑定列表数据 (需告知待绑定数据的viewmodel实例) */
    [self requestWithDataModel:[NormalListViewModel new]];
}

/** 列表自动绑定数据在此方法中实现，复写该方法，可处理特殊的列表数据结构 */
- (void)handleSuccessResult:(id)result dataModel:(id)dataModel {
    
    /** 添加头部数据源 */
    NormalReusableViewModel *headerViewModel = [NormalReusableViewModel new];
    headerViewModel.title = @"Header";
    self.headerDataList = [NSMutableArray arrayWithObject:headerViewModel];
    /** 添加尾部数据源 */
    NormalReusableViewModel *footerViewModel = [NormalReusableViewModel new];
    footerViewModel.title = @"Footer";
    self.footerDataList = [NSMutableArray arrayWithObject:footerViewModel];
    
    [super handleSuccessResult:result dataModel:dataModel];
}

- (void)handleFail:(id)error {
    
}

@end
