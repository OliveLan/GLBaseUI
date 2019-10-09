//
//  BaseViewController.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIButton *leftButton;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    self.view.backgroundColor = RGBA(248, 248, 248, 1);
    
    if (self.navigationController.viewControllers.count > 1 || self.presentingViewController) {
        // 添加返回按钮
        [self setLeftBackBtn];
    }
}

- (void)setTitleViewWithTitle: (NSString *)title {
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(80, 0, self.navigationController.view.frame.size.width-160, NavHeight);
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor darkTextColor];
    lblTitle.font = [UIFont systemFontOfSize:19];
    lblTitle.text = title;
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    self.navigationItem.titleView = lblTitle;
}

// 设置导航栏左侧按钮
- (void)setLeftBackBtn {
    
    UIImage * backImg = [UIImage imageNamed:@"back"];
    self.leftButton.frame = CGRectMake(0, 0, 30, 30);
    self.leftButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.leftButton setImage:backImg forState:UIControlStateNormal];
    
    UIView *leftCustomView = [[UIView alloc] initWithFrame:self.leftButton.frame];
    [leftCustomView addSubview:self.leftButton];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftCustomView];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backBtnClick {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - setter & getter
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

@end
