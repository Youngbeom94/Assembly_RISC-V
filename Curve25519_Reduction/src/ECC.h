/*
 * ECC.h
 *
 *  Created on: 2020. 10. 23.
 *      Author: 김영범
 */

#ifndef ECC_H_
#define ECC_H_

#include"Param.h"




// 유한체 레벨
uint8_t BN_Compare(uint32_t* a, uint32_t* b, int len);
void BN_copy(uint32_t* dst, uint32_t* src, int len);
void BN_mod_add(uint32_t* r, const uint32_t* a, const uint32_t* b, const uint32_t* m, uint8_t len);
void BN_mod_sub(uint32_t* r, const uint32_t* a, const uint32_t* b, const uint32_t* m, uint8_t len);
void BN_mod_mul(uint32_t* r, const uint32_t* a, const uint32_t* b, const uint32_t* m, uint8_t len);
void BN_mod_sqr(uint32_t* r, const uint32_t* a, const uint32_t* m, uint8_t len);
void BN_mod_inversion(uint32_t* r, const uint32_t* a, const uint32_t* m, uint8_t len);
void BN_modular(uint32_t* r, const uint32_t* a, const uint32_t* m, uint8_t len);
void Divide_2(uint32_t* a);

//타원곡선 레벨
extern void ec_GFp_group_init(EC_GROUP* a);
extern void ec_GFp_group_copy(EC_GROUP* dst, EC_GROUP* src);
extern void ec_GFp_group_set(EC_GROUP* a, const uint32_t* order, const uint32_t* X, const uint32_t* Y, uint8_t curve_name);
extern void ec_GFp_point_init(EC_POINT* a);
extern void ec_GFp_point_copy(EC_POINT* dst, const EC_POINT* src);
extern void ec_GFp_set_coordinates(EC_POINT* a, const uint32_t* X, const uint32_t* Y, uint8_t len);
extern void ec_GFp_convert_Affine_to_Jacobian(const EC_GROUP* group, EC_POINT* jprojective, const EC_POINT* AFFINE);
extern void ec_GFp_convert_Jacobian_to_Affine(const EC_GROUP* group, EC_POINT* AFFINE, const EC_POINT* jprojective);
extern void ec_GFp_Jprojective_add(const EC_GROUP* group, EC_POINT* r, const EC_POINT* a, const EC_POINT* b);
extern void ec_GFp_Jprojective_dbl(const EC_GROUP* group, EC_POINT* r, const EC_POINT* a);
extern void Double_end_add_always_SM(const EC_GROUP* group, EC_POINT* r, const uint32_t* Scalar);


//스칼라 레벨
extern void ec_wNAF_mul(const EC_GROUP* group, EC_POINT* r, const uint32_t* Scalar);
uint32_t modular_16(uint32_t B);
extern void Comb_Table(EC_GROUP* group, EC_POINT EC_Table[ECC_Parameter], uint8_t Table[ECC_Parameter][32], const uint32_t* Scalar);
extern unsigned long long Comb_Scalar_Multiplication(const EC_GROUP* group, EC_POINT* r, const uint32_t* Scalar);
extern void NAFw_Fuction(const EC_GROUP* group, const uint32_t* Scalar, char* Table);
extern void ec_Scalar_Multiplication(const EC_GROUP* group, EC_POINT* r, const uint32_t* Scalar);
extern void ec_Montgomery_Multiplication(const EC_GROUP* group, EC_POINT* r, const uint32_t* Scalar);
extern void ec_Atomic_Multiplication(const EC_GROUP* group, EC_POINT* r, const uint32_t* Scalar);

//기타 검증을 위한 함수
extern void File_Read(FILE* fp, uint32_t* a);
extern void File_Write(FILE* fp, EC_POINT* NUMBER);
extern void ec_Montgomery2(EC_GROUP* group, EC_POINT* r, uint32_t* Scalar);
extern void ec_print_point(EC_POINT* point);
extern void ec_print_value(uint32_t* word);
extern void SJK_ECADDDBL_Projective2(EC_GROUP* group, EC_POINT* a, EC_POINT* b, EC_POINT* r1, EC_POINT* r2);
extern void SJK_ECADDDBL2(EC_GROUP* group, EC_POINT* a, EC_POINT* b, EC_POINT* r1, EC_POINT* r2);

extern void Basepoint_Randomization(EC_GROUP* group, EC_POINT* r, uint32_t* Scalar);
extern void ec_Montgomery(EC_GROUP* group, EC_POINT* r, uint32_t* Scalar);
extern void SJK_ECADDDBL(EC_GROUP* group, EC_POINT* a, EC_POINT* b, EC_POINT* r1, EC_POINT* r2);
extern void SJK_ECADDDBL_Projective(EC_GROUP* group, EC_POINT* a, EC_POINT* b, EC_POINT* r1, EC_POINT* r2);

extern void ec_GFp_projective_dbl(EC_GROUP* group, EC_POINT* r, EC_POINT* a);
extern void SJK_YRecovery(EC_GROUP* group, EC_POINT* r, EC_POINT* a, EC_POINT* b);


extern void Random_Projective_Coordinate(EC_GROUP* group, EC_POINT* r, uint32_t* Scalar);

extern void Scalar_Randomization(EC_GROUP* group, EC_POINT* r, uint32_t* Scalar);






extern int ec_GFp_generate_randombasepoint(EC_GROUP* group, EC_POINT* r, uint8_t* initseed);
extern void CTR_DRBG_LEA128(EC_GROUP* group, EC_POINT* r, uint8_t* initseed);
extern void ADDONE(uint8_t* a, int len);
extern void BYTEXOR(uint8_t* A, uint8_t* B, uint8_t* R, int blocksize);
extern void SETZERO(uint8_t* block, int blocksize);
extern void LEA_ENC(uint8_t* ct, const unsigned int* rk, const uint8_t* pt, int len);
extern void LEA_KEYGEN(unsigned int* rk, const uint8_t* key, int len);
extern const uint32_t delta[8][36];
uint8_t CBC_Key[16];

//////////////////////////////////////////////////////
//////////////////////P-25519/////////////////////////
//////////////////////////////////////////////////////
extern uint32_t BN_p25519_add(uint32_t* r, const uint32_t* a, const uint32_t* b, const uint32_t* m, uint8_t len);
extern uint32_t BN_p25519_sub(uint32_t* r, const uint32_t* a, const uint32_t* b, const uint32_t* m, uint8_t len);
extern void ec_GFp_p25519_dbl(EC_GROUP* group, EC_POINT* r, EC_POINT* a);
extern void ec_GFp_p25519_add(EC_GROUP* group, EC_POINT* r, EC_POINT* p, EC_POINT* q);
extern void ec_p25519_YRecovery(EC_GROUP* group, EC_POINT* r, EC_POINT* R1, EC_POINT* R2);
extern void ec_p25519_XZ_Multiplication(EC_GROUP* group, EC_POINT* R1, EC_POINT* R2, uint32_t* Scalar);
extern void ec_p25519_ScalarMultiplication(EC_GROUP* group, EC_POINT* r, uint32_t* Scalar);

extern void ec_GFp_convert_Projective_to_Affine(const EC_GROUP* group, EC_POINT* AFFINE, const EC_POINT* projective);

#endif /* ECC_H_ */
