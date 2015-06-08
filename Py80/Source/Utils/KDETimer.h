//
//  KDETimer.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/8/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDETimer : NSObject

+ (double) timeBlock:(void(^)())block;

@end
