//
//  NSObject+DeallocBlock.h
//  GPFoundation
//
//  Created by Liyanwei on 2018/9/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DeallocBlock)

/**
 Observer current instance class dealloc action

 @param block dealloc callback
 */
- (void)gp_deallocBlock:(void(^)(void))block;

@end
