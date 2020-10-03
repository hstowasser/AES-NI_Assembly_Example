/*****************************************************************************/
/* Includes:                                                                 */
/*****************************************************************************/
#include "aes.h"

/*****************************************************************************/
/* Defines:                                                                  */
/*****************************************************************************/
// The number of columns comprising a state in AES. This is a constant in AES. Value=4
#define Nb 4


#define Nk 4        // The number of 32 bit words in a key.
#define Nr 10       // The number of rounds in AES Cipher.


/*****************************************************************************/
/* Private variables:                                                        */
/*****************************************************************************/
// state - array holding the intermediate results during decryption.
typedef uint8_t state_t[4][4];


/*****************************************************************************/
/* Private functions:                                                        */
/*****************************************************************************/


extern void KeyExpansion(uint8_t* RoundKey, const uint8_t* Key);

extern void Cipher(state_t* state, const uint8_t* RoundKey);

extern void InvCipher(state_t* state, const uint8_t* RoundKey);


/*****************************************************************************/
/* Public functions:                                                         */
/*****************************************************************************/

void AES_init_ctx(struct AES_ctx* ctx, const uint8_t* key)
{
  KeyExpansion(ctx->RoundKey, key);
}

void AES_ECB_encrypt(const struct AES_ctx* ctx, uint8_t* buf)
{
  // The next function call encrypts the PlainText with the Key using AES algorithm.
  Cipher((state_t*)buf, ctx->RoundKey);
}

void AES_ECB_decrypt(const struct AES_ctx* ctx, uint8_t* buf)
{
  // The next function call decrypts the PlainText with the Key using AES algorithm.
  InvCipher((state_t*)buf, ctx->RoundKey);
}



