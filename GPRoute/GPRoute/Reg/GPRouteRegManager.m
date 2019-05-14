//
//  GPRouteRegManager.m
//  GPRoute
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPRouteRegManager.h"
#import "GPRouteRegTree.h"
#import "GPRouteRegTreeDelegate.h"

@interface GPRouteRegManager ()
@property (nonatomic, strong) GPRouteRegTree *regRoot;
@end

@implementation GPRouteRegManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self regRoot];
    }
    
    return self;
}

- (GPRouteRegTree *) regRoot
{
    if (!_regRoot) {
        _regRoot = [[GPRouteRegTree alloc] init];
    }
    
    return _regRoot;
}

- (void)addReg:(id<GPRouteRegTreeDelegate>)reg
    withDomain:(NSString *)domain
          path:(NSString *)path
{
    GPRouteRegTree *leftNode = [self leafNodeAtDomain:domain path:path];
    if (leftNode.regs) {
        NSMutableArray *regs = [leftNode.regs mutableCopy];
        [regs addObject:reg];
        leftNode.regs = regs;
    } else {
        leftNode.regs = @[reg];
    }
}

- (GPRouteRegTree *)leafNodeAtDomain:(NSString *)domain
                                path:(NSString *)path
{
    NSMutableArray *treePath = [NSMutableArray new];
    [treePath addObject:domain];
    [treePath addObjectsFromArray:[path componentsSeparatedByString:@"."]];
    
    return [self leafNodeAtPath:treePath fromNode:self.regRoot];
}

- (GPRouteRegTree *)leafNodeAtPath:(NSArray<NSString *> *)pathSeg
                          fromNode:(GPRouteRegTree *)node
{
    NSMutableArray *nextPathSeg = [pathSeg mutableCopy];
    
    NSString *firstSeg = [nextPathSeg firstObject];
    [nextPathSeg removeObjectAtIndex:0];
    
    NSMutableDictionary<NSString *, GPRouteRegTree *> *children = nil;
    if (node.children) {
        children = [node.children mutableCopy];
    } else {
        children = [NSMutableDictionary new];
    }
    
    GPRouteRegTree *nextNode = nil;
    if (!children[firstSeg]) {
        GPRouteRegTree *newNode = [[GPRouteRegTree alloc] init];
        children[firstSeg] = newNode;
        newNode.fater = node;
    }
    node.children = children;
    nextNode = children[firstSeg];
    
    if (nextPathSeg.count == 0) {
        return nextNode;
    } else {
        return [self leafNodeAtPath:nextPathSeg fromNode:nextNode];
    }
}

- (NSArray< id<GPRouteRegTreeDelegate> > *)matchRegsWithDomain:(NSString *)domain path:(NSString *)path
{
    NSMutableArray *treePath = [NSMutableArray new];
    [treePath addObject:domain];
    [treePath addObjectsFromArray:[path componentsSeparatedByString:@"."]];
    
    GPRouteRegTree *leafNode = self.regRoot;
    while (treePath.count > 0 && leafNode.children[[treePath firstObject]]) {
        leafNode = leafNode.children[[treePath firstObject]];
        [treePath removeObjectAtIndex:0];
    }
    
    NSArray *regs = leafNode.regs;
    GPRouteRegTree *curNode = leafNode;
    while (!regs && curNode) {
        curNode = curNode.fater;
        regs = curNode.regs;
    }
    
    return regs;
}

- (void)checkRegsWithDomain:(NSString *)domain
                       path:(NSString *)path
                     params:(NSDictionary *)params
                 completion:(void (^)(GPRouteDecision, NSError *error))completion
{
    NSMutableArray< id<GPRouteRegTreeDelegate> > *regs = [[self matchRegsWithDomain:domain path:path] mutableCopy];
    if (regs.count == 0) {
        if (completion) {
            completion(GPRouteDecisionAllow, nil);
        }
    } else {
        [self checkRegsWithRegs:regs domain:domain path:path params:params completion:completion];
    }
}

- (void)checkRegsWithRegs:(NSArray< id<GPRouteRegTreeDelegate> >*)regs
                   domain:(NSString *)domain
                     path:(NSString *)path
                   params:(NSDictionary *)params
               completion:(void (^)(GPRouteDecision, NSError *))completion
{
    NSMutableArray *nextRegs = [regs mutableCopy];
    [nextRegs removeObjectAtIndex:0];
    id<GPRouteRegTreeDelegate> reg = [regs firstObject];
    
    [reg regWithDomain:domain path:path params:params completion:^(GPRouteDecision decision, NSError *error) {
        switch (decision) {
            case GPRouteDecisionDeny: {
                if (completion) {
                    completion(GPRouteDecisionDeny, error);
                }
                break;
            }
                
            case GPRouteDecisionAllow: {
                if (nextRegs.count == 0) {
                    if (completion) {
                        completion(GPRouteDecisionAllow, nil);
                    }
                } else {
                    [self checkRegsWithRegs:nextRegs domain:domain path:path params:params completion:completion];
                }
                break;
            }
            default:
                break;
        }
        
    }];
}

@end
