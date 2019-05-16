//
//  DCHook.h
//
//  Created by Liyanwei on 2019/5/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPHook : NSObject

+ (void)hookClass:(Class)classObject
     fromSelector:(SEL)fromSelector
       toSelector:(SEL)toSelector;

@end
