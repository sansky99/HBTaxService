//
//  RequestState.h
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-27.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#ifndef iTAXMC_RequestState_h
#define iTAXMC_RequestState_h


typedef NS_ENUM(int,reuestState)
{
    ELoadidle = 0,
    ELoadingFirst,
    ERloading,
    ELoadingMore
};


typedef struct  requestProperty {
    uint16_t offset;
    reuestState state;
} requestProperty;


#endif
