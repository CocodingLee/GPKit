//
//  GPFrameLossCell.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCallStackModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPFrameLossCell : UITableViewCell
- (void)updateWithModel:(GPCallStackModel *)model;
@end

NS_ASSUME_NONNULL_END
