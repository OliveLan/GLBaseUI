//
//  HomeViewController.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeListWidgetModel.h"
#import "HomeListViewModel.h"
#import "NormalViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) GLBaseWidgetView *baseView;
@property (nonatomic, strong) HomeListWidgetModel *widgetModel;
@property (nonatomic, strong) NSMutableArray <HomeListViewModel *> *listDataArr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleViewWithTitle:@"Home"];
    
    /** 第一步 将视图添加到当前控制器 */
    [self.view addSubview:self.baseView];
    /** 第二步 向视图内添加组件 */
    [self.baseView addWidgets:@[self.widgetModel]];
}

#pragma mark - setter
- (GLBaseWidgetView *)baseView {
    if (!_baseView) {
        _baseView = [[GLBaseWidgetView alloc] init];
        _baseView.frame = self.view.bounds;
        
        /** cell点击事件回调方式一 */
        __weak typeof(self) weakself = self;
        _baseView.collectionView.selectedRowBlock = ^(NSIndexPath * _Nonnull indexPath) {
            if (indexPath.row == 0) {
                NormalViewController *normalVC = [NormalViewController new];
                [weakself.navigationController pushViewController:normalVC animated:YES];
            }
        };
    }
    return _baseView;
}

- (HomeListWidgetModel *)widgetModel {
    if (!_widgetModel) {
        _widgetModel = [[HomeListWidgetModel alloc] initWithData:self.listDataArr];
    }
    return _widgetModel;
}

- (NSMutableArray<HomeListViewModel *> *)listDataArr {
    if (!_listDataArr) {
        _listDataArr = [NSMutableArray array];
        
        NSArray *cellTitleArr = @[@"普通列表（带header、footer）", @"多样式列表", @"横向列表"];
        for (NSString *title in cellTitleArr) {
            HomeListViewModel *viewModel = [HomeListViewModel new];
            viewModel.titleStr = title;
            [_listDataArr addObject:viewModel];
        }
    }
    return _listDataArr;
}

@end
