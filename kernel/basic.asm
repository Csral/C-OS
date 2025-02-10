bits 16
org 0x1000

_start:

    mov ax, 0x1000
    mov ds, ax
    
    mov ax, 0x7E0
    mov ss, ax
    mov sp, 0x2000

    mov ah, 0x0e
    mov al, "?"
    mov bh, 0

    int 0x10

    push kmsg
    call print_string

    hlt

print_string:
    
    push bp
    mov bp, sp
    
    mov si, [bp+4]
    mov bh, 0x00
    mov bl, 0x00
    mov ah, 0x0E

char:

    mov al, [si]
    add si, 1

    or al, 0
    je done

    int 0x10
    jmp char

done:

    mov sp, bp
    pop bp

    ret

kmsg db "Hello from kernel", 0