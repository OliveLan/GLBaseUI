//
//  GLBaseHttpModel.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/9/30.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "GLBaseHttpModel.h"

@interface GLBaseHttpModel ()

@property (nonatomic, strong) id resultData;

@end

@implementation GLBaseHttpModel

- (void)request {
    
}

- (void)requestSuccess:(id)result {
    if (_requestType == REQUEST_TYPE_OTHER) {
        return;
    }
    _requestStatus = REQUEST_STATUS_SUCCESS;
    if (_requestSuccessBlock) {
        _requestSuccessBlock(result);
    }
}

- (void)requestFailure:(id)error {
    _requestStatus = REQUEST_STATUS_FAIL;
    if (_requestErrorBlock) {
        _requestErrorBlock(error);
    }
}

@end
