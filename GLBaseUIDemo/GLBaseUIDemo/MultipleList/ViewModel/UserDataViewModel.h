//
//  UserDataViewModel.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/14.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#import "GLBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserDataViewModel : GLBaseViewModel

@property (nonatomic, strong) NSString *headerImgName;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *signature;

@end

NS_ASSUME_NONNULL_END
