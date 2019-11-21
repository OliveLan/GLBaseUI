//
//  UserDataCell.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/14.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "UserDataCell.h"
#import "UserDataViewModel.h"
#import "Masonry.h"

@interface UserDataCell ()

@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *nicknameLab;
@property (nonatomic, strong) UILabel *signatureLab;

@end

@implementation UserDataCell

- (CGSize)cellSize {
    return CGSizeMake(SCREEN_WIDTH, 90);
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.headerImg];
    [self addSubview:self.nicknameLab];
    [self addSubview:self.signatureLab];
    
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.width.mas_equalTo(50);
        make.centerY.mas_equalTo(self);
    }];
}

- (void)refreshCellWithModel:(GLBaseViewModel *)data indexPath:(NSIndexPath *)indexPath {
    UserDataViewModel *model = (UserDataViewModel *)data;
    _headerImg.image = [UIImage imageNamed:model.headerImgName];
    _nicknameLab.text = model.nickname;
    _signatureLab.text = model.signature;
}

#pragma mark - getter
- (UIImageView *)headerImg {
    if (!_headerImg) {
        _headerImg = [UIImageView new];
        _headerImg.layer.cornerRadius = 25;
        _headerImg.clipsToBounds = YES;
        _headerImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImg;
}

@end
