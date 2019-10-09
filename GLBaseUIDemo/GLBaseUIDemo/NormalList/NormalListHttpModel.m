//
//  NormalListHttpModel.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "NormalListHttpModel.h"

@interface NormalListHttpModel ()


@end

@implementation NormalListHttpModel

/** 复写父类方法 发送网络请求 */
- (void)request {
    [self requestListDataSuccess:^(id  _Nonnull resultDic) {
    } fail:^(id  _Nonnull error) {
    }];
}

#pragma mark -
#pragma mark - 自定义的继承于“GLBaseHttpModel”的网络请求父类中的实现，可参看下列方法

/** 模拟请求列表数据，实际使用中可在网络请求基类中实现 */
- (void)requestListDataSuccess:(GLReqSuccess)success fail:(GLReqFailure)fail {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 请求得到的列表数据
            NSArray *list = @[@{@"imgUrl": @"", @"novelTitle": @"iOS开发从入门到放弃", @"nickname": @"Olive", @"content": @"是时候展现真正的技术了！！"},
                              @{@"imgUrl": @"", @"novelTitle": @"前端开发菜鸟课程", @"nickname": @"Olive", @"content": @"菜鸟教菜鸟让你变得更菜鸟"},
                              @{@"imgUrl": @"", @"novelTitle": @"数据结构与算法", @"nickname": @"Olive", @"content": @"这是什么我也不会哈哈哈哈"}];
            
            /** 若请求成功 在回调中做以下操作 */
            self.list = list;
            success(list);
            [self requestSuccess:list];
            self.requestStatus = REQUEST_STATUS_SUCCESS;
            
            
            /** 若请求失败 做以下操作 */
        //    fail(error);
        //    [self requestFailure:error];
        //    self.requestStatus = REQUEST_STATUS_FAIL;
    });
}

- (void)requestSuccess:(id)result {
    if (self.requestType == REQUEST_TYPE_OTHER) {
        return;
    }
    if (self.requestSuccessBlock) {
        self.requestSuccessBlock(result);
    }
}

- (void)requestFailure:(id)error {
    if (self.requestErrorBlock) {
        self.requestErrorBlock(error);
    }
}

@end
