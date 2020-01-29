

//
//      Copyright (C) 2020 Joseph Combs - All Rights Reserved
//
//
//  INFO
//
//    Fixed data types
//




#if !defined _INT_DEF_
#define      _INT_DEF_

//
//  GCC, for now, is required to build, because we
//  need fixed-width integer types.
//

#if defined (__GNUC__)

#if defined __INT16_TYPE__ && defined __INT32_TYPE__ && \
	defined __INT8_TYPE__

#define DEF_INT16_TYPE	__INT16_TYPE__
#define DEF_INT32_TYPE	__INT32_TYPE__
#define DEF_INT8_TYPE	__INT8_TYPE__
#else
#error "GCC: no signed integer support"
#endif

#if defined __UINT16_TYPE && defined __UINT32_TYPE && \
	defined __UINT8_TYPE__

#define DEF_UINT16_TYPE	__UINT16_TYPE__
#define DEF_UINT32_TYPE	__UINT32_TYPE__
#define DEF_UINT8_TYPE	__UINT8_TYPE__
#else
#error "GCC: no unsigned integer support"
#endif

#if defined __INT8_TYPE && defined __UINT8_TYPE
#else
#error "GCC: no pointer support"
#endif
#else
#error "GCC: not found."
#endif

typedef DEF_INT16_TYPE	INT16;
typedef DEF_UINT16_TYPE	UINT16;
typedef DEF_INT32_TYPE	INT32;
typedef DEF_UINT32_TYPE	UINT32;
typedef DEF_INT8_TYPE	INT8;
typedef DEF_UINT8_TYPE	UINT8;

#endif
