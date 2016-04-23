//
//  ETDefinition.h
//  EasyTool
//
//  Created by supertext on 14-10-15.
//  Copyright (c) 2014年 icegent. All rights reserved.

#ifndef EasyTool_ETDefinition_h
#define EasyTool_ETDefinition_h

#ifdef DEBUG
#define ETLog(fmt, ...)  NSLog((@"\nDEBUG:%s/%d\n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ETLog(...)
#endif

#ifdef __cplusplus
#define ET_EXTERN		extern "C" __attribute__((visibility ("default")))
#else
#define ET_EXTERN	        extern __attribute__((visibility ("default")))
#endif

#endif
