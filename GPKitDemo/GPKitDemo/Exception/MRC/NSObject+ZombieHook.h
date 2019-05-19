//
//  NSObject+Zombie.h
//  GPException
//
//  Created by Liyanwei on 2018/7/26.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZombieHook)

+ (void)gp_swizzleZombie;

@end
