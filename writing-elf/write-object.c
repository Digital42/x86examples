/*
        creates an elf64 executable file for 126 byte long hello world program written in x86 for linux
        this will eventually be made into a simple assembler 
        compile normally with:
        gcc -o write-program write-program.c
        chmod +x write-program
        ./write-program
*/
    
#include<stdio.h>


/*               NOT SURE IF THE VARIOUS ELF HEADERS SHOULD BE IN A STRUCT OR ENUM
enum elfHeader {
    //magic number
    magicNum1 = 0x7f,
    magicNum2 = 0x45,
    magicNum3 = 0x4c,
    magicNum4 = 0x46,
    bits = ,
    endianness = ,
    version = ,
    targetAbi = 0x00,
    phoff,
    shoff,
    flags,
    ehsize,
    phentsize,
    phnum,
    shentsize,
    shnum,
    shstrndx    
};
*/

int main(){

    /*
        this is x86 nasm source for 126 byte program that isnt technically a valid elf file 
        but it runs and outputs like a normal hello world program.  

            [bits 64]
            file_load_va: equ 4096 * 40

            db 0x7f, 'E', 'L', 'F'
            db 2
            db 1
            db 1
            db 0

            entry_point:
            xor eax, eax
            inc eax
            mov edi, eax
            jmp code_chunk_2

            dw 2
            dw 0x3e
            dd 1
            dq entry_point + file_load_va
            dq program_headers_start


            code_chunk_2:
            mov esi, file_load_va + message
            xor edx, edx
            mov dl, message_length

            jmp code_chunk_3
            db 0
            dw 64
            dw 0x38
            dw 1
            dw 0x40
            dw 0
            dw 0

            program_headers_start:
            dd 1
            dd 5
            dq 0
            dq file_load_va

            code_chunk_3:
            syscall
            mov al, 60
            xor edi, edi
            syscall

            dq file_end
            ;dq file_end

            message: db `Hello, world!\n`
            message_length: equ $ - message

            file_end:
    */

    //this array is a 126 byte long x86 program on linux that outputs "Hello, world! to console" 
	short dataBytes[] = {/*   Elf Header                 Elf header end | entry point                                   */
                          0x7f, 0x45, 0x4c, 0x46, 0x02, 0x01, 0x01, 0x00, 0x31, 0xc0, 0xff, 0xc0, 0x89, 0xc7, 0xeb, 0x18,
                         /*                                                                                             */
                          0x02, 0x00, 0x3e, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x80, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00,
                         /*    entry point end | code chunk 2                                                            */
                          0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xbe, 0x70, 0x80, 0x02, 0x00, 0x31, 0xd2, 0xb2,
                         /*                                                                           end code chunk 2  |*/
                          0x0e, 0xeb, 0x25, 0x00, 0x40, 0x00, 0x38, 0x00, 0x01, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00,
                         /* Program header                                                                               */
                          0x01, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                         /*       Program header end | code chunk 3                                                      */
                          0x00, 0x80, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0f, 0x05, 0xb0, 0x3c, 0x31, 0xff, 0x0f, 0x05,
                         /*   <-           not sure i think this is a double "dq file_end"                         ->    */
                          0x7e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                         /*H     e    l      l     o    ,           W      o     r     l     d     !    \n               */
                          0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21, 0x0a
                         };

    // gets size of array
    int ArySize = sizeof(dataBytes)/sizeof(dataBytes[0]);
	FILE *ObjectFile;

	ObjectFile=fopen("hello-world.bin","wb");

    //standard error handling for working with files
	if (!ObjectFile)
	{
		printf("Could'nt open file!");
		return 1;
	}

    //write arrays of bytes to file
    for(int i = 0; i < ArySize; i++){
		fwrite(&dataBytes[i],1,1,ObjectFile);
    };

	fclose(ObjectFile);

	return 0;
}