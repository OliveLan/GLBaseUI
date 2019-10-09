//
//  HomeListCell.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "HomeListCell.h"
#import "HomeListViewModel.h"

@interface HomeListCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *line;

@end

@implementation HomeListCell

#pragma mark - override
- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 60)];
    self.titleLab.font = [UIFont systemFontOfSize:16];
    self.titleLab.textColor = [UIColor darkTextColor];
    [self addSubview:self.titleLab];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(20, 59, SCREEN_WIDTH-20, 0.5)];
    self.line.backgroundColor = RGBA(241, 243, 246, 1);
    [self addSubview:self.line];
}

- (CGSize)cellSize {
    return CGSizeMake(SCREEN_WIDTH, 60);
}

- (void)refreshCellWithModel:(GLBaseViewModel *)data indexPath:(NSIndexPath *)indexPath {
    HomeListViewModel *viewModel = (HomeListViewModel *)data;
    _titleLab.text = viewModel.titleStr;
}

/** cell点击事件回调方式二 */
- (void)didSelectedCell {
    
}

@end
