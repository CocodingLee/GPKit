//
//  GPJSBridge.h
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GPJSBridge, GPJSBridgeMessageModel;

@protocol GPJSBridgeDelegate <NSObject>
- (NSDictionary *)bridge:(GPJSBridge *)bridge
        didReciveMessage:(GPJSBridgeMessageModel *)message;
@end

////////////////////////////////////////////////////////

typedef NS_ENUM(NSInteger, GPJSBridgeMessageType) {
    GPJSBridgeMessageTypeAsync = 0,
    GPJSBridgeMessageTypeSync  = 1,
};

@interface GPJSBridgeMessageModel : NSObject
@property (nonatomic, assign) GPJSBridgeMessageType type;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSDictionary *args;
@property (nonatomic, strong) id callbackId;
@end

////////////////////////////////////////////////////////

@interface GPJSBridge : NSObject <WKUIDelegate>
@property (nonatomic, weak) id<GPJSBridgeDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
