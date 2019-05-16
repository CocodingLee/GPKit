//
//  GPTraceCore.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#ifndef default_GPTraceCore_h
#define default_GPTraceCore_h

#include <stdio.h>
#include <objc/objc.h>


typedef struct _CallRecord
{
    __unsafe_unretained Class cls;
    SEL sel;
    
    uint64_t time; // us (1/1000 ms)
    int depth;
} GPCallRecord;

extern void gpCallTraceStart(void);
extern void gpCallTraceStop(void);

extern void gpCallConfigMinTime(uint64_t us); //default 1000
extern void gpCallConfigMaxDepth(int depth);  //default 3

extern GPCallRecord *gpGetCallRecords(int *num);
extern void gpClearCallRecords(void);

#endif /* default_GPTraceCore_h */
