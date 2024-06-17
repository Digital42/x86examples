; Build with: nasm -f elf64 -g function.asm && ld function.o -static -o function
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
    char dd 'j'
    charLen equ $ - char


section .text
    global _start
    
_start:

    mov rdi, 5
    call function

    mov eax, SYS_EXIT                    ; standard linux exit sys call      
    xor edi, edi                         ; zero out edi
    syscall

function:
    push rbp                             ; function prolog
    mov rbp, rsp

    mov rax, rdi
    add rax, rax

    mov rsp, rbp                         ; function epilog
    pop rbp
    ret