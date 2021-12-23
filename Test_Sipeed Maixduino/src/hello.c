#include <stdio.h>	
#include "bsp.h"
#include "util.h"
#include <string.h>
#define RTC_FREQ    32768

//! Test Function
int core1_function(void *ctx);

//! Test AES Function
extern void AES_128_encrypt(const uint8_t *, const uint8_t *, uint8_t *);

//! Test util Function
void print_hex(char* msg, uint8_t*in, int bytelen);


 int main()	
{	
    //! Test Function
    // uint64_t core = current_coreid();	
    // printf("Core %ld Hello world\n", core);	
    // register_core1(core1_function, NULL);	


    //! Our Work
    const uint8_t key[16] = {4,5,6,7,4,5,6,8,4,5,6,9,4,5,6,10};
    uint8_t in[16] = {0,0,0,0,1,2,3,1,2,4,1,2,5,1,2,6};
    uint8_t out[16];
    uint8_t rk[11*16];

    memcpy(rk, key, 16);
    
    printf("hello wold\n");

    //Fill instruction cache and train branch predictors
    AES_128_encrypt(rk, in, out);

    print_hex("[Plain  Text] : ", in, 16);
    print_hex("[Cipher Text] : ", out, 16);

    //! Please Remove
    //while(1);	
}

int core1_function(void *ctx)	
{	
    uint64_t core = current_coreid();	
    printf("Core %ld Hello world\n", core);	
    while(1);	
}	

void print_hex(char* msg, uint8_t* in, int bytelen)
{
    printf("%s",msg);

    for(int cnt_i = 0 ; cnt_i < bytelen ; cnt_i ++)
    {
        if((cnt_i != 0) && (cnt_i % 16 == 0))
            printf("\n");

        printf("%02x ", in[cnt_i]);
    }

    printf("\n");
}
