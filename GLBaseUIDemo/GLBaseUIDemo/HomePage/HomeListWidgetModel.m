//
//  HomeListWidgetModel.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "HomeListWidgetModel.h"

@implementation HomeListWidgetModel

- (void)configWithData:(id)data {
    if ([data isKindOfClass:[NSArray class]]) {
        self.cellDataList = [NSMutableArray arrayWithArray:data];
    }
}

@end
