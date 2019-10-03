//
//  GLBaseViewModel.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/8/20.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "GLBaseViewModel.h"

@interface GLBaseViewModel ()

@property(nonatomic, copy) NSString *defaultReuseIdentifier;

@end

@implementation GLBaseViewModel

- (instancetype)init {
    self = [super init];
    if (self){
        self.height = 0;
    }
    return self;
}

- (void)heightChanged {
    self.height = 0;
}

- (NSString *)reuseIdentifier {
    return self.defaultReuseIdentifier;    //  默认复用标识: 为本身类名后面"ViewModel" 替换为"Cell" 的 cell标识
}

- (NSString *)randomReuseIdentifier {
    if(!_randomReuseIdentifier) {
        _randomReuseIdentifier = [NSString stringWithFormat:@"%u%@",arc4random()%10000000, self.defaultReuseIdentifier];
    }
    return _randomReuseIdentifier;
}

- (NSString *)defaultReuseIdentifier {
    if (!_defaultReuseIdentifier) {
        NSString * name = [NSString stringWithUTF8String:object_getClassName(self)];
        // 默认数据模型为“xxxViewModel”，对应的cell为"xxxCell"
        name = [name substringToIndex:[name length] - 9];
        name = [name stringByAppendingString:@"Cell"];
        _defaultReuseIdentifier = name;
    }
    return _defaultReuseIdentifier;
}


- (Class)reuseViewClass {
    return nil;
}

- (NSIndexPath *)indexPathWithCollectionview:(UICollectionView *)collectionview {
    if(!_cell) {
        return nil;
    }
    return [collectionview indexPathForCell:_cell];
}

- (void)setWidth:(CGFloat)width {
    _width = width;
}

- (void)setupCell:(UICollectionViewCell *)collectionviewCell {
    self->_cell = collectionviewCell;
}

@end
