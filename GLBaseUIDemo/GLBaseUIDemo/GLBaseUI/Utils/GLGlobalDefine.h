//
//  GLGlobalDefine.h
//  GLBaseUIDemo
//
//  Created by GanL on 2019/10/8.
//  Copyright © 2019 Gan Lan. All rights reserved.
//

#ifndef GLGlobalDefine_h
#define GLGlobalDefine_h

// Assert
#ifdef DEBUG
#define GLAssert(condition , description)  if(!(condition)){ NSLog(@"%@",description); assert(0);}
#else
#define GLAssert(condition , description)
#endif

#ifdef DEBUG
#define QAssert(condition)  if(!(condition)){ assert(0);}
#else
#define QAssert(condition)
#endif

// block weakself
#define kBlockWeakSelf __weak typeof(&*self) weakSelf = self;
#define kBlockStrongSelf __strong typeof(&*weakSelf) strongSelf = weakSelf;

#endif /* GLGlobalDefine_h */
