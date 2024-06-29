; Build with: nasm -f elf64 -g write-hello.asm && ld write-hello.o -static -o write-hello
;       linux x86 program that outputs a executable elf file that prints "Hello, World!\n"
;       but some basic elf tools might not work because of header bit clobberng
;               - to run the elf file that is created -
;                       chmox +x hello-world.bin
;                       ./hello-world.bin

BITS 64   

SYS_OPEN   equ     2          ; open file
SYS_CLOSE  equ     2          ; close file
SYS_READ   equ     0          ; read text from stdin
SYS_WRITE  equ     1          ; write text to stdout
SYS_EXIT   equ     60         ; terminate the program
STDIN      equ     0          ; standard input
STDOUT     equ     1          ; standard output
O_CREAT    equ     0102o      ; create file
umode_t    equ     0666o      ;

section .data

; TODO: add in another byte array from a program with more valid elf headers
; program byte array. a semi valid elf that prints "Hello, World!" then exits with return code of 0
                   ;Elf Header                    Elf header end | entry point                                   
byteArry    db     0x7f, 0x45, 0x4c, 0x46, 0x02, 0x01, 0x01, 0x00, 0x31, 0xc0, 0xff, 0xc0, 0x89, 0xc7, 0xeb, 0x18
                   ;
            db     0x02, 0x00, 0x3e, 0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x80, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00
                   ;      end entry point | code chunk 2
            db     0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xbe, 0x70, 0x80, 0x02, 0x00, 0x31, 0xd2, 0xb2
                   ;                                                                            end code chunk 2|
            db     0x0e, 0xeb, 0x25, 0x00, 0x40, 0x00, 0x38, 0x00, 0x01, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00
                   ; Program header
            db     0x01, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                   ;         end program header| code chunk 3                                   end code chunk 3|
            db     0x00, 0x80, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0f, 0x05, 0xb0, 0x3c, 0x31, 0xff, 0x0f, 0x05
                   ;                    not sure i think this is a double "dq file_end"       
            db     0x7e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x7e, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
                   ; H     e    l      l     o    ,           W      o     r     l     d     !    \n     
            db     0x48, 0x65, 0x6c, 0x6c, 0x6f, 0x2c, 0x20, 0x77, 0x6f, 0x72, 0x6c, 0x64, 0x21, 0x0a

    ;local label for len of the progrma byte array
    .len equ $ - byteArry

; file name
filename db 'hello-world.bin', 0
    .len equ $ - filename

fileDesc dq 0

section .text
global _start         

_start:
                 
    mov rdi, filename           ; file name
    mov rsi, O_CREAT            ; O_CREAT
    mov rdx, umode_t            ; inode mode
    mov rax, SYS_OPEN           ; open system call
    syscall

    mov [fileDesc], rax         ; store file descriptor from open() return value
    mov rdx, byteArry.len       ; pass in length of byte array
    mov rsi, byteArry           ; pass in byte array
    mov rdi, [fileDesc]         ; pass in file descriptor
    mov rax, SYS_WRITE        
    syscall            

    mov rdi, [fileDesc]         ; close 
    mov rax, SYS_CLOSE          ; file
    syscall

    mov rax, SYS_EXIT           ; standard linux exit sys call      
    xor rdi, rdi                ; zero out edi
    syscall           


