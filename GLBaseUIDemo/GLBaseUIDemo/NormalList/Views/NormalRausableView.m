//
//  NormalHeaderView.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/10.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "NormalRausableView.h"
#import "NormalReusableViewModel.h"

@interface NormalRausableView ()

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation NormalRausableView

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 45)];
    self.titleLab.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:self.titleLab];
}

- (CGSize)viewSize {
    return CGSizeMake(SCREEN_WIDTH, 45);
}

- (void)reuseWithData:(GLBaseViewModel *)data section:(NSInteger)section {
    NormalReusableViewModel *model = (NormalReusableViewModel *)data;
    _titleLab.text = model.title;
}

@end
