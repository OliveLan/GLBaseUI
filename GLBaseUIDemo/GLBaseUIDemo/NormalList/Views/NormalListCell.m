//
//  NormalListCell.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "NormalListCell.h"
#import "Masonry.h"
#import "NormalListViewModel.h"

#define kImgHeight      127

@interface NormalListCell ()

@property (nonatomic, strong) UIImageView *novelImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *desLab;
@property (nonatomic, strong) UILabel *authorLab;

@end

@implementation NormalListCell

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    [self novelImg];
    [self titleLab];
    [self desLab];
    [self authorLab];
}

- (CGSize)cellSize {
    return CGSizeMake(self.collectionView.width, self.novelImg.bottom + 8);
}

- (void)refreshCellWithModel:(GLBaseViewModel *)data indexPath:(NSIndexPath *)indexPath {
    NormalListViewModel *model = (NormalListViewModel *)data;
    _novelImg.image = [UIImage imageNamed:model.imgName];
    _titleLab.text = model.novelTitle;
    _desLab.text = model.content;
    _authorLab.text = model.nickname;
}

#pragma mark - getter
- (UIImageView *)novelImg {
    if (!_novelImg) {
        CGFloat imgWidth = kImgHeight * 0.75;
        _novelImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, imgWidth, kImgHeight)];
        _novelImg.contentMode = UIViewContentModeScaleAspectFill;
        _novelImg.layer.cornerRadius = 4.f;
        _novelImg.clipsToBounds = YES;
        
        [self addSubview:_novelImg];
    }
    return _novelImg;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor darkTextColor];
        [self addSubview:_titleLab];
        
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_novelImg.mas_right).offset(15);
            make.right.mas_equalTo(self).offset(-20);
            make.top.mas_equalTo(_novelImg.mas_top).offset(10);
        }];
    }
    return _titleLab;
}

- (UILabel *)desLab {
    if (!_desLab) {
        _desLab = [[UILabel alloc] init];
        _desLab.numberOfLines = 2;
        _desLab.font = [UIFont systemFontOfSize:12];
        _desLab.textColor = [UIColor grayColor];
        [self addSubview:_desLab];
        
        [_desLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_titleLab);
            make.top.mas_equalTo(_titleLab.mas_bottom).offset(8);
        }];
    }
    return _desLab;
}

- (UILabel *)authorLab {
    if (!_authorLab) {
        _authorLab = [[UILabel alloc] init];
        _authorLab.font = [UIFont systemFontOfSize:11];
        _authorLab.textColor = [UIColor grayColor];
        [self addSubview:_authorLab];
        [_authorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_titleLab);
            make.bottom.mas_equalTo(_novelImg.mas_bottom).offset(-10);
        }];
    }
    return _authorLab;
}

@end
