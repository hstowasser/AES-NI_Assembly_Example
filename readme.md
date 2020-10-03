# AES using Intel AES-NI instructions.

This project implements 128bit AES-EBC encrypt and decrypt functions using the AES-NI x86 instructions. It was written in the spirit of intellectual curiosity and is not intended to be secure or robust in any way. The code is loosley based on the [AES-Tiny](https://github.com/kokke/tiny-AES-c) project.

The project was build and tested on Ubuntu-20.04, though it may work on other UNIX based systems.

## Build the test

```
nasm -f elf64 aes_asm
gcc -no-pie test.c aes_asm.o -o aes_test
```