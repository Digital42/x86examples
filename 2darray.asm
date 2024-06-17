; Build with: nasm -f elf64 -g "file_name".nasm && ld "file_name".o -static -o "file_name" 
BITS 64   
;
SYS_READ   equ     0          ; read text from stdin
SYS_WRITE  equ     1          ; write text to stdout
SYS_EXIT   equ     60         ; terminate the program
STDIN      equ     0          ; standard input
STDOUT     equ     1          ; standard output

; data section for initialized data
section .data

    element dd 0

    ; Define an array of bytes
    array  dd 'a','b','c','d','e'
           dd 'f','g','h','i','j'
           dd 'k','l','m','n','o'
           ; Keep track of each element size in bytes
           .DataTypeSize equ 4
           ; Define size of the array 
           .SizeOfArray equ $ - array
           ; Number of rows in the 2d array
           .LengthOf equ array.SizeOfArray / .DataTypeSize
           ; Number of columns in the 2d array
           .NumberOfCols equ 5

    rowIndex dd 0
    colIndex dd 1

; bss section is for uninitiated data 
section .bss

section .text
    global _start
    
_start:

    ; In order to find an element with a given index you need to impliment the follow bassic math fomula
    ; (row index * the number of column)
    mov eax, [rowIndex]                   ;
    mov ebx, array.NumberOfCols           ;                                                                                                                                                           h-byte|l-byte
    mul ebx                               ; (row index * number of cols)                                                -- MUL multiplies a source (ebx) wwith eax and the result is stored between     [edx|eax]
    add eax, DWORD[colIndex]              ; (row index * number of cols) + column index                                 -- ADD takes a destination operand (first operand) and the source operand (second operand) and then stores result in the destination operand (first operand)
    mov ebx, array.DataTypeSize           ; move the size of element into ebx           
    mul ebx                               ; ((row index * number of cols) + column index) * data type size 
    add eax, array                        ; (((row index * number of cols) + column index) * data type size) + array
    
    mov edi, [eax]                        ; store the index for later use as futher instructions can change the value of eax 
    mov [element], edi

    mov eax, SYS_WRITE                    ; std write
    mov edi, STDOUT                       ; file discriptor
    mov esi, element                      ; string to print
    mov edx, 1                            ; size of element
    syscall

    mov eax, SYS_EXIT                    ; standard linux exit sys call      
    xor edi, edi                         ; zero out edi
    syscall