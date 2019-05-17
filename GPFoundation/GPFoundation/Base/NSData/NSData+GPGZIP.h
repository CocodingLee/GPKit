//
//  NSData+GZip.h
//  GPFoundation
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (GPGZIP)

// gzip compression utilities
- (NSData *)gp_gzip;
- (NSData *)gp_ungzip;

@end
