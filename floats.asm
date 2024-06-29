; Build with: nasm -f elf64 -g floats.asm && ld floats.o -static -o floats
; simple example of basic floating point operations & string conversion
BITS 64   
;
SYS_READ   equ     0          ; read text from stdin
SYS_WRITE  equ     1          ; write text to stdout
SYS_EXIT   equ     60         ; terminate the program
STDIN      equ     0          ; standard input
STDOUT     equ     1          ; standard output

; data section for initialized data
section .data
    numStr dd  "012345", 0x0A
    strLen equ $ - numStr

section .bss
    variable resb 20
    len      resb 1
section .text
    global _start
    
_start:
    ;;;;;;;;;;;;;;;;;;;;;;;;;;; old way of doing floats with x87;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;; initialize the FPU 
    ;fninit
    ; load value into st(o) register
    ;fld DWORD [two]
    ; takes square root of st(o) and store the result back in st(0)
    ;fsqrt
    ; store st(o) in variable and pop the x87 stack
    ;fstp DWORD [variable]
    ;;;;;;;;;;;;;;;;;;;;;;;;;; endold way of doing floats with x87;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;mov al, 123
    ;add al, '0'

    ;mov [numStr+0], al

    mov eax, SYS_READ                   ; std write
    mov edi, STDIN                     ; file discriptor
    mov esi, variable                      ; string to print
    mov edx, 20                   ; string length
    syscall   

    ;lea esi, [numStr + 2]
    ;mov al, [numStr + 2]
    ;add esi, 48
    ;mov [variable], al

    add al, 47
    mov [len], al

    mov eax, SYS_WRITE                   ; std write
    mov edi, STDOUT                      ; file discriptor
    mov esi, len                     ; string to print
    mov edx, 1                   ; string length
    syscall

    ;mov eax, SYS_WRITE                   ; std write
    ;mov edi, STDOUT                      ; file discriptor
    ;mov esi, numStr+0                     ; string to print
    ;mov edx, 1                   ; string length
    ;syscall

    mov eax, SYS_EXIT                    ; standard linux exit sys call      
    xor edi, edi                         ; zero out edi
    syscall
