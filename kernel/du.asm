bits 16
org 0x3000

_start:

    mov ax, 0x3000
    mov ds, ax
    mov es, ax

    push 0x0400
    call movecursor
    add sp, 2

    push dmsg
    call print_string
    add sp, 2

    cli
    hlt

print_string:

    push bp
    mov bp, sp
    pusha

    mov si, [bp+4]
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x00

char:

    mov al, [si]
    add si, 1

    or al, 0
    je returnS

    int 0x10
    jmp char

returnS:

    popa

    mov sp, bp
    pop bp

    ret

movecursor:

    push bp
    mov bp, sp
    pusha

    mov dx, [bp+4]
    mov ah, 0x02
    mov bh, 0x00
    
    int 0x10

    popa
    mov sp, bp
    pop bp

    ret

dmsg db "Hello from dummy 2", 0