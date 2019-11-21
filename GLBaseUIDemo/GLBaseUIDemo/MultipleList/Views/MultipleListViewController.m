//
//  MultipleListViewController.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/11.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "MultipleListViewController.h"
#import "MultipleFirstWidgetModel.h"
#import "MultipleSecondWidgetModel.h"
#import "MultipleTagWidgetModel.h"

@interface MultipleListViewController ()

@property (nonatomic, strong) GLBaseWidgetView *baseView;
@property (nonatomic, strong) MultipleFirstWidgetModel *firstWidget;
@property (nonatomic, strong) MultipleSecondWidgetModel *secondWidget;
@property (nonatomic, strong) MultipleTagWidgetModel *tagWidget;

@end

@implementation MultipleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleViewWithTitle:@"多样式列表"];
    
    [self.view addSubview:self.baseView];
    
    _firstWidget = [MultipleFirstWidgetModel new];
    _secondWidget = [MultipleSecondWidgetModel new];
    _tagWidget = [MultipleTagWidgetModel new];
    // 添加三种类型的widget
    [self.baseView addWidgets:@[_firstWidget, _secondWidget, _tagWidget]];
}

#pragma mark - getter
- (GLBaseWidgetView *)baseView {
    if (!_baseView) {
        _baseView = [[GLBaseWidgetView alloc] init];
        _baseView.frame = self.view.bounds;
    }
    return _baseView;
}

@end
