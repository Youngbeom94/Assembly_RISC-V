/*
 * curve25519.c
 *
 *  Created on: 2020. 10. 23.
 *      Author: 김영범
 */

#include"ECC.h"

void BN_copy(uint32_t* dst, uint32_t* src, int len) {
   uint8_t cnt_i = 0;

   memcpy(dst, src, sizeof(uint32_t) * len);
   return;

}

void p25519_mul(uint32_t* r, const uint32_t* a, const uint32_t* b, const uint32_t* m, uint8_t len) {
   int cnt_i, cnt_j; //for loop counting variable
   uint64_t UV = 0x00LL;
   uint32_t U, V = 0x00;
   uint32_t state[ECC_Parameter * 2] = { 0x0, };

   for (cnt_i = 0; cnt_i < ECC_Parameter; cnt_i++)
   {
      UV &= 0x00000000ffffffff;
      for (cnt_j = 0; cnt_j < ECC_Parameter; cnt_j++)
      {
         U = UV >> 32;
         UV = state[cnt_i + cnt_j] + ((unsigned long long)a[cnt_i] * (unsigned long long)b[cnt_j]) + U;
         V = UV & 0x00000000ffffffff;
         state[cnt_i + cnt_j] = V;
      }
      U = UV >> 32;
      state[cnt_i + ECC_Parameter] = U;
   }

   memcpy(r, state, 2 * ECC_Parameter * sizeof(uint32_t));

   return;
}

uint32_t BN_p25519_add(uint32_t* r, const uint32_t* a, const uint32_t* b, const uint32_t* m, uint8_t len) {

   int cnt_i = 0x00;
   uint32_t carry = 0x00;
   int c = 0x0;
   int borrow = 0x0;
   uint32_t state[ECC_Parameter] = { 0x00, };

   for (cnt_i = 0; cnt_i < len; cnt_i++) {
      c = 0;
      state[cnt_i] = a[cnt_i] + b[cnt_i];

      if (state[cnt_i] < a[cnt_i]) {
         c++;
      }

      state[cnt_i] += carry;

      if (state[cnt_i] < carry)
      {
         c++;
      }
      carry = c;
   }

   memcpy(r, state, len * sizeof(uint32_t));

   return carry;
}

uint32_t BN_p25519_sub(uint32_t* r, const uint32_t* a, const uint32_t* b, const uint32_t* m, uint8_t len) {

   int carry = 0;
   int c = 0;
   uint32_t borrow = 0;
   int cnt_i = 0;
   uint32_t state[ECC_Parameter] = { 0x00, };
   uint32_t state2[ECC_Parameter] = { 0x00, };

   for (cnt_i = 0; cnt_i < ECC_Parameter; cnt_i++) {

      state[cnt_i] = a[cnt_i] - b[cnt_i] - borrow;


      if (a[cnt_i] < b[cnt_i] || ((a[cnt_i] == b[cnt_i]) && (borrow == 1)))
      {
         borrow = 1;
      }
      else {
         borrow = 0;
      }

   }

   memcpy(r, state, sizeof(uint32_t) * len);

   return borrow;
}




void BN_modular(uint32_t* r, const uint32_t* a, const uint32_t* m, uint8_t len)
{

uint32_t T[ECC_Parameter * 2] = { 0x0, };
uint32_t T2[ECC_Parameter] = { 0x0, };
uint32_t T3[ECC_Parameter * 2] = { 0x0, };
uint32_t T4[ECC_Parameter] = { 0x0, };
uint32_t T5[ECC_Parameter * 2] = { 0x0, };
uint32_t T6[ECC_Parameter] = { 0x0, };
uint32_t ret[ECC_Parameter] = { 0x0, };
uint32_t g;

uint32_t V2[8] = { 38, 0x0,0x0, 0x0, 0x0, 0x0, 0x0, 0x0 };
uint32_t temp[8] = { 0x00, }; // Y
uint32_t temp2[8] = { 0x00, }; // X

int i;
int carry = 0;
for (i = 0; i < 8; i++) {
   temp[i] = a[i];
}
for (i = 0; i < 8; i++) {
   temp2[i] = a[i + 8];
}



p25519_mul(T, V2, temp2, m, ECC_Parameter);


ret[0] = T[8];


ret[0] += BN_p25519_add(T2, temp, T, m, ECC_Parameter);

p25519_mul(T3, ret, V2, m, ECC_Parameter);

uint32_t mod2[8] = { 0xFFFFFFED,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0xFFFFFFFF,0x7FFFFFFF };

carry = BN_p25519_add(T2, T2, T3, m, ECC_Parameter);

//clear
while (carry > 0||(BN_Compare(T2,mod2,ECC_Parameter)!=RightBigger)){


   carry -= BN_p25519_sub(T2, T2, mod2, m, ECC_Parameter);

}

BN_copy(r, T2,ECC_Parameter);

   return;
}



uint8_t BN_Compare(uint32_t* a, uint32_t* b, int len) {
   int cnt_i;

   for (cnt_i = len - 1; cnt_i >= 0; cnt_i--) {

      if (a[cnt_i] > b[cnt_i]) {
         return LeftBigger; //
      }
      else if (a[cnt_i] < b[cnt_i]) {
         return RightBigger; //
      }

   }

   return Same;
}
//
//
//void BN_mod_add(uint32_t* r, const uint32_t* a, const uint32_t* b, const uint32_t* m, uint8_t len) {
//
//   int cnt_i = 0x00;
//   int carry = 0x00;
//   int c = 0x0;
//   int borrow = 0x0;
//   uint32_t state[ECC_Parameter + 1] = { 0x00, };
//   uint32_t state2[ECC_Parameter + 1] = { 0x00, };
//   uint32_t prime[ECC_Parameter + 1] = { 0x00, };
//
//   for (cnt_i = 0; cnt_i < ECC_Parameter; cnt_i++) {
//      prime[cnt_i] = m[cnt_i];
//   }
//
//   for (cnt_i = 0; cnt_i < ECC_Parameter; cnt_i++) {
//      c = 0;
//      state[cnt_i] = a[cnt_i] + b[cnt_i];
//
//      if (state[cnt_i] < a[cnt_i]) {
//         c++;
//      }
//
//      state[cnt_i] += carry;
//
//      if (state[cnt_i] < carry)
//      {
//         c++;
//      }
//      carry = c;
//   }
//   state[ECC_Parameter] = carry;
//   //printf("더하기\n");
//   //printf("carry=%d\n", carry);
//   //for (int i = 8; i >= 0; i--) {
//   //   printf("%08X ", state[i]);
//   //}
//   //printf("\n");
//   //printf("빼기\n");
////더하기는 완벽함
//   while ((BN_Compare(state, prime, ECC_Parameter + 1)) != RightBigger) {
//      for (cnt_i = 0; cnt_i <= ECC_Parameter; cnt_i++) {
//         state2[cnt_i] = state[cnt_i] - prime[cnt_i] - borrow;
//         //printf("===========================================================================\n");
//         //printf("i=%d Borrow=%d\n state=%08X, prime=%08X\n", cnt_i, borrow, state[cnt_i], prime[cnt_i]);
//         if (state[cnt_i] < prime[cnt_i] || ((state[cnt_i] == prime[cnt_i]) && (borrow == 1)))
//         {
//            borrow = 1;
//         }
//         else {
//            borrow = 0;
//         }
//         /*   printf("i=%d Borrow=%d\n state=%08X, prime=%08X\n",cnt_i, borrow,state[cnt_i],prime[cnt_i]);
//            printf("===========================================================================\n");*/
//
//      }
//      BN_copy(state, state2, ECC_Parameter + 1);
//      /*printf("Checking Point\n");
//      for (int i = 8; i >= 0; i--) {
//         printf("%08X ", state[i]);
//      }
//      printf("\n");
//      getchar();*/
//   }
//
//   for (int i = ECC_Parameter-1; i >= 0; i--) {
//      r[i] = state[i];
//   }
//   //printf("Checking Point\n");
//   //for (int i = 7; i >= 0; i--) {
//   //   printf("%08X ", r[i]);
//   //}
//   //printf("\n");
//
//
//   return;
//}
//void BN_mod_sub(uint32_t* r, const uint32_t* a, const uint32_t* b, const uint32_t* m, uint8_t len) {
//
//   int carry = 0;
//   int c = 0;
//   int borrow = 0;
//   int cnt_i = 0;
//   uint32_t state[ECC_Parameter] = { 0x00, };
//   uint32_t state2[ECC_Parameter] = { 0x00, };
//
//   for (cnt_i = 0; cnt_i < ECC_Parameter; cnt_i++) {
//
//      state[cnt_i] = a[cnt_i] - b[cnt_i] - borrow;
//
//
//      if (a[cnt_i] < b[cnt_i] || ((a[cnt_i] == b[cnt_i]) && (borrow == 1)))
//      {
//         borrow = 1;
//      }
//      else {
//         borrow = 0;
//      }
//
//   }
//   if (borrow == 1) {
//      for (cnt_i = 0; cnt_i < ECC_Parameter; cnt_i++) {
//         c = 0;
//         r[cnt_i] = state[cnt_i] + m[cnt_i];
//
//         if (r[cnt_i] < state[cnt_i]) {
//            c++;
//         }
//
//         r[cnt_i] += carry;
//
//         if (r[cnt_i] < carry)
//         {
//            c++;
//         }
//         carry = c;
//      }
//   }
//   else {
//      BN_copy(r, state,ECC_Parameter);
//   }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//void BN_mod_mul(uint32_t* r, const uint32_t* a, const uint32_t* b, const uint32_t* m, uint8_t len) {
//   int cnt_i, cnt_j; //for loop counting variable
//   uint64_t UV = 0x00LL;
//   uint32_t U, V = 0x00;
//   uint32_t state[ECC_Parameter * 2] = { 0x0, };
//
//   for (cnt_i = 0; cnt_i < ECC_Parameter; cnt_i++)
//   {
//      UV &= 0x00000000ffffffff;
//      for (cnt_j = 0; cnt_j < ECC_Parameter; cnt_j++)
//      {
//         U = UV >> 32;
//         UV = state[cnt_i + cnt_j] + ((unsigned long long)a[cnt_i] * (unsigned long long)b[cnt_j]) + U;
//         V = UV & 0x00000000ffffffff;
//         state[cnt_i + cnt_j] = V;
//      }
//      U = UV >> 32;
//      state[cnt_i + ECC_Parameter] = U;
//   }
//
//   BN_modular(r, state, m, len);
//
//
//   return;
//}
//
//void Divide_2(uint32_t* a) {
//   int cnt_i = 0;
//   int temp = 0;
//   for (cnt_i = 0; cnt_i < ECC_Parameter - 1; cnt_i++) {
//      a[cnt_i] = a[temp + 1] << 31 | a[temp] >> 1;
//      temp += 1;
//   }
//   a[cnt_i] = a[cnt_i] >> 1;
//   return;
//}
//
//
//void BN_mod_inversion(uint32_t* r, const uint32_t* a, const uint32_t* m, uint8_t len) {
//   uint32_t temp[ECC_Parameter] = { 0x00, };
//   uint32_t temp2[ECC_Parameter] = { 0x00, };
//   uint32_t temp3[ECC_Parameter] = { 0x00, };
//
//   uint32_t Number_1[ECC_Parameter] = { 1,0,0,0,0,0,0,0 };
//   uint32_t X1[ECC_Parameter] = { 1,0,0,0,0,0,0,0 };
//   uint32_t X2[ECC_Parameter] = { 0x00, };
//
//   BN_copy(temp, a,ECC_Parameter);
//   BN_copy(temp2, m, ECC_Parameter);
//   int cnt_i = 0;
//   int c = 0;
//   int carry = 0;
//   while ((BN_Compare(temp, Number_1,ECC_Parameter) != Same) && (BN_Compare(temp2, Number_1, ECC_Parameter) != Same)) {
//
//      while ((temp[0] & 1) == 0) { // 짝수 인 경우
//
//
//         Divide_2(temp);
//
//
//         if ((X1[0] & 1) == 0) {
//            Divide_2(X1);
//
//         }
//         else {
//            carry = 0;
//            for (cnt_i = 0; cnt_i < ECC_Parameter; cnt_i++) {
//               c = 0;
//
//               temp3[cnt_i] = X1[cnt_i] + m[cnt_i];
//
//               if (temp3[cnt_i] < X1[cnt_i]) {
//                  c = 1;
//               }
//               else {
//                  c = 0;
//               }
//               temp3[cnt_i] += carry;
//
//               if (temp3[cnt_i] < carry)
//               {
//                  c = 1;
//               }
//
//               carry = c;
//            }
//            if (carry == 1) {
//               Divide_2(temp3);
//               temp3[ECC_Parameter - 1] ^= 0x80000000;
//            }
//
//            else {
//               Divide_2(temp3);
//            }
//            BN_copy(X1, temp3, ECC_Parameter);
//
//
//         }
//
//      }
//
//      while ((temp2[0] & 1) == 0) { // 짝수 인 경우
//         Divide_2(temp2);
//
//         if ((X2[0] & 1) == 0) {
//            Divide_2(X2);
//         }
//         else {
//
//            carry = 0;
//            for (cnt_i = 0; cnt_i < ECC_Parameter; cnt_i++) {
//               c = 0;
//
//               temp3[cnt_i] = X2[cnt_i] + m[cnt_i];
//
//               if (temp3[cnt_i] < X2[cnt_i]) {
//                  c++;
//               }
//
//               temp3[cnt_i] += carry;
//
//               if (temp3[cnt_i] < carry)
//               {
//                  c++;
//               }
//               carry = c;
//            }
//            if (carry == 1) {
//               Divide_2(temp3);
//               temp3[ECC_Parameter - 1] ^= 0x80000000;
//            }
//
//            else {
//               Divide_2(temp3);
//            }
//            BN_copy(X2, temp3, ECC_Parameter);
//
//
//         }
//
//      }
//
//      if (BN_Compare(temp, temp2, ECC_Parameter) != RightBigger) {
//         BN_copy(temp3, temp, ECC_Parameter);
//         BN_mod_sub(temp, temp3, temp2, m, 256);
//         BN_copy(temp3, X1, ECC_Parameter);
//         BN_mod_sub(X1, temp3, X2, m, 256);
//      }
//
//      else {
//
//         BN_copy(temp3, temp2, ECC_Parameter);
//         BN_mod_sub(temp2, temp3, temp, m, 256);
//         BN_copy(temp3, X2, ECC_Parameter);
//         BN_mod_sub(X2, temp3, X1, m, 256);
//
//      }
//   }
//
//   if (BN_Compare(Number_1, temp, ECC_Parameter) == Same) {
//      BN_copy(r, X1, ECC_Parameter);
//   }
//   else {
//      BN_copy(r, X2, ECC_Parameter);
//   }
//
//   return;
//
//}
//
//
//void BN_mod_sqr(uint32_t* r, const uint32_t* a, const uint32_t* m, uint8_t len)
//{
//   uint32_t r0 = 0, r1 = 0, r2 = 0;
//   uint64_t UV = 0;
//   uint32_t U = 0, V = 0;
//   uint32_t subR = 0;
//   uint32_t state[ECC_Parameter * 2] = { 0x00, };
//   int carry = 0;
//   int subcarry = 0;
//
//   for (int k = 0; k < (ECC_Parameter << 1) - 1; k++)
//   {
//      for (int i = k >> 1, j = i + (k & 1); i >= 0 && j < ECC_Parameter; i--, j++)
//      {
//         UV = ((unsigned long long)a[i] * (unsigned long long)a[j]);
//         if (i < j)
//         {
//            carry = (((UV >> 60) << 1) >> 4);
//            UV = UV << 1;
//            r2 = r2 + carry;
//         }
//         U = (UV >> 32); //U
//         V = UV & 0xffffffff; //V
//
//         r0 = r0 + V;
//
//         if (r0 < V)
//            carry = 1;
//         else
//            carry = 0;
//
//         r1 = r1 + U;
//         if (r1 < U)
//            r2 += 1;
//
//         r1 = r1 + carry;
//         if (r1 < carry)
//            r2 += 1;
//      }
//      state[k] = r0;
//      r0 = r1;
//      r1 = r2;
//      r2 = 0;
//   }
//   state[(ECC_Parameter << 1) - 1] = r0;
//   //통과
//   BN_modular(r, state, m, len);
//
//   return;
//}





