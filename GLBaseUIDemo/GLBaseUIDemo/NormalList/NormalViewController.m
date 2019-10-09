//
//  NormalViewController.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "NormalViewController.h"
#import "NormalListWidgetModel.h"

@interface NormalViewController ()

@property (nonatomic, strong) GLBaseWidgetView *baseView;
@property (nonatomic, strong) NormalListWidgetModel *listWidgetModel;

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleViewWithTitle:@"普通列表"];
    
    [self.view addSubview:self.baseView];
    [self.baseView addWidgets:@[self.listWidgetModel]];
}

#pragma mark - setter
- (GLBaseWidgetView *)baseView {
    if (!_baseView) {
        _baseView = [[GLBaseWidgetView alloc] init];
        _baseView.frame = self.view.bounds;
    }
    return _baseView;
}

- (NormalListWidgetModel *)listWidgetModel {
    if (!_listWidgetModel) {
        _listWidgetModel = [[NormalListWidgetModel alloc] initWithData:nil];
    }
    return _listWidgetModel;
}

@end
