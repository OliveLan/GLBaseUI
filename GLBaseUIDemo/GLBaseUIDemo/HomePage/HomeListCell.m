//
//  HomeListCell.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "HomeListCell.h"
#import "HomeListViewModel.h"
#import "Masonry.h"

@interface HomeListCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) HomeListViewModel *viewModel;

@end

@implementation HomeListCell

#pragma mark - override
- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imgView];
    [self addSubview:self.titleLab];
    [self addSubview:self.contentLab];
    [self addSubview:self.line];
    
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.imgView);
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(5);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

- (CGSize)cellSize {
    CGSize contentLabSize = [_contentLab getLayoutSize];
    return CGSizeMake(SCREEN_WIDTH, _titleLab.bottom + contentLabSize.height + 15);
}

- (void)refreshCellWithModel:(GLBaseViewModel *)data indexPath:(NSIndexPath *)indexPath {
    _viewModel = (HomeListViewModel *)data;
    _titleLab.text = _viewModel.titleStr;
    _contentLab.text = _viewModel.content;
    _imgView.image = [UIImage imageNamed:_viewModel.imgName];
}

/** 根据数据源调整cell的高度 */
- (void)refreshCellSizeWithModel:(GLBaseViewModel *)model {
    _viewModel = (HomeListViewModel *)model;
    _contentLab.text = _viewModel.content;  // 对影响高度布局的label进行赋值
}

/** cell点击事件回调方式二 */
- (void)didSelectedCell {
    
}

#pragma mark - getter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 10, SCREEN_WIDTH - 25*2, 150)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.cornerRadius = 5.f;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 35)];
        _titleLab.font = [UIFont boldSystemFontOfSize:17];
        _titleLab.textColor = [UIColor darkTextColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.numberOfLines = 0;
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = [UIColor grayColor];
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}

- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = RGBA(241, 243, 246, 1);
    }
    return _line;
}

@end
