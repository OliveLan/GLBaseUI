//
//  MultipleFirstWidgetModel.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/11.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "MultipleFirstWidgetModel.h"
#import "UserDataViewModel.h"

@interface MultipleFirstWidgetModel ()


@end

@implementation MultipleFirstWidgetModel

- (void)configWithData:(id)data {
    UserDataViewModel *model = [UserDataViewModel new];
    model.headerImgName = @"novelImg2";
    model.nickname = @"Olive";
    model.signature = @"嘻嘻";
    [self.cellDataList addObject:@[model]];
}

@end
