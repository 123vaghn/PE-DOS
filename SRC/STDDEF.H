

//
//      Copyright (C) 2020 Joseph Combs - All Rights Reserved
//
//  INFO
//




#if !defined _STD_DEF_
#define      _STD_DEF_

#undef EXIT_SUCCESS
#undef EXIT_FAILURE
#undef NULL

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1

#if defined __STDC_VERSION__ && defioed __STDC__
#define VOID void
#define NULL ((VOID *)0)
#else
#define VOID int
#define NULL 0
#endif


#define DefPtr(in) in*

#endif
