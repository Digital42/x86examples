; Build with: nasm -f elf64 -g input-output.asm && ld input-output.o -static -o input-output
; this is a simple example of basic input and output of a string in x86 on linux 
BITS 64   
;
SYS_READ   equ     0          ; read text from stdin
SYS_WRITE  equ     1          ; write text to stdout
SYS_EXIT   equ     60         ; terminate the program
STDIN      equ     0          ; standard input
STDOUT     equ     1          ; standard output

; data section for initialized data
section .data
    ; simple string for user prompt
    prompt dd "Please Enter a character: ", 0
    promptLen equ $ - prompt

; bss section is for uninitiated data 
section .bss
    ; user input typically is uninitialized data 
    ; 24 byte buffer
    inputLen equ 24
    userInput resb inputLen

section .text
    global _start
    
_start:

    mov eax, SYS_WRITE                   ; std write
    mov edi, STDOUT                      ; file discriptor
    mov esi, prompt                      ; string to print
    mov edx, promptLen                   ; string length
    syscall

    mov eax, SYS_READ                    ; std read
    mov edi, STDIN                       ; file discriptor
    mov esi, userInput                   ; user input location
    mov edx, inputLen                    ; user string length
    syscall

    mov eax, SYS_WRITE                   ; std write
    mov edi, STDOUT                      ; file discriptor
    mov esi, userInput                   ; string to print
    mov edx, inputLen                    ; string length
    syscall    

    mov eax, SYS_EXIT                    ; standard linux exit sys call      
    xor edi, edi                         ; zero out edi
    syscall