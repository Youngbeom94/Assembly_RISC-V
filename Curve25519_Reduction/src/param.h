/*
 * param.h
 *
 *  Created on: 2020. 10. 23.
 *      Author: ±è¿µ¹ü
 */

#ifndef PARAM_H_
#define PARAM_H_

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <sys/types.h>
#include <time.h>
#include <sys/stat.h>



#define ECC_Parameter 8 // P-256, P-384, P-521
#define Param 1 // 0-P256, 1-p-25519


#define LeftBigger 5
#define RightBigger 6
#define Same 7

#define  Affine   12
#define Jacobian   13

#define Not_Infinity 14
#define Is_Infinity 15

#define TRUE   3
#define False   4

typedef struct ec_group_st EC_GROUP;
typedef struct ec_point_st EC_POINT;


struct ec_point_st {

   unsigned char curve_name;
   unsigned char is_Infinity;

   uint32_t X[ECC_Parameter];
   uint32_t Y[ECC_Parameter];
   uint32_t Z[ECC_Parameter];

   uint8_t  Z_is_one;
};


struct ec_group_st {

   EC_POINT generator;

   uint32_t order[ECC_Parameter];
   uint32_t a[ECC_Parameter];
   uint32_t b[ECC_Parameter];
   uint8_t curve_name;
};


typedef struct atomic_block {

   uint32_t a[ECC_Parameter];
   int sign;
}atomic_block;



#endif /* PARAM_H_ */
