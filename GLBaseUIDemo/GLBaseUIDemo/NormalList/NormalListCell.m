//
//  NormalListCell.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "NormalListCell.h"

@implementation NormalListCell

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
}

- (CGSize)cellSize {
    return CGSizeMake(self.collectionView.width, 200);
}

@end
