//
//  TypeDef.h
//  GlobalType
//
//  Created by 常 贤明 on 13-10-19.
//  Copyright (c) 2013年 常 贤明. All rights reserved.
//

typedef unsigned short WORD;
typedef unsigned int DWORD;
typedef unsigned char BYTE;
typedef unsigned long long UNDWORD;
typedef signed long long DWORD64;

#define UIFONT_SYSTERM_SIZE_LITTER      10.0f
#define UIFONT_SYSTERM_SIZE_LITTLE      12.0f
#define UIFONT_SYSTERM_DEFAULT_SIZE     14.0f
#define UIFONT_SYSTERM_SIZE_LARGE       15.0f
#define UIFONT_SYSTERM_SIZE_LARGER      18.0f

#define SafeVal(p) (p ? (*p) : 0)