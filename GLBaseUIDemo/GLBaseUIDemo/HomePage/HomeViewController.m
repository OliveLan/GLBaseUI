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
    
    [self setTitleViewWithTitle:@"GLBaseUI"];
    
    /** 第一步 将视图添加到当前控制器 */
    [self.view addSubview:self.baseView];
    /** 第二步 向视图内添加组件 */
    [self.baseView addWidgets:@[self.widgetModel]];
}

#pragma mark - getter
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
        
        NSArray *cellTitleArr = @[@"示例一：普通列表", @"示例二：多样式列表", @"示例三：横向卡片列表"];
        NSArray *imageArr = @[@"home_bg1", @"home_bg2", @"home_bg3"];
        NSArray *contentArr = @[@"该示例为同一种cell的普通列表，带header和footer，同时模拟了数据请求回调后的自动绑定",
                                @"多section、多种类型cell的混排，同时也包含cell中再次嵌套横向列表",
                                @""];
        for (int i = 0; i< cellTitleArr.count; i++) {
            HomeListViewModel *viewModel = [HomeListViewModel new];
            viewModel.titleStr = cellTitleArr[i];
            viewModel.imgName = imageArr[i];
            viewModel.content = contentArr[i];
            [_listDataArr addObject:viewModel];
        }
    }
    return _listDataArr;
}

@end
