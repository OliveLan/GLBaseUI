//
//  GLCollectionReusableViewModel.m
//  GLBaseUIDemo
//
//  Created by GanL on 2019/9/30.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "GLCollectionReusableViewModel.h"

@implementation GLCollectionReusableViewModel

- (CGFloat)width {
    return 0.0001;
}

- (CGFloat)height {
    return 0.0001;
}

- (NSString *)reuseIdentifier {
    return @"GLCollectionReusableView";
}

@end
