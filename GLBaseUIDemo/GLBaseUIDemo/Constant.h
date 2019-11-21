//
//  Constant.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/9.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define StatusBarHeight             [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarHeight                44
#define NavHeight                   (StatusBarHeight + NavBarHeight)
#define SCREEN_WIDTH                (CGRectGetWidth([UIScreen mainScreen].bounds))
#define SCREEN_HEIGHT               (CGRectGetHeight([UIScreen mainScreen].bounds))
#define RGBA(r, g, b, a)            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#endif /* Constant_h */
