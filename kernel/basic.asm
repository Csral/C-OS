bits 16
org 0x0000

_start:

    mov ax, 0x1000
    mov ds, ax
    mov es, ax
    
    mov ax, 0x7E0
    mov ss, ax
    mov sp, 0x4000

    push 0x0100
    call movecursor
    add sp, 2

    mov ah, 0x0e
    mov al, "?"
    mov bh, 0

    int 0x10

    push 0x0200
    call movecursor
    add sp, 2

    push kmsg
    call print_string
    add sp, 2
    
    mov ah, 0x02
    mov al, 0x01 ; read only 1 sector
    mov ch, 0 ; cylindered 0
    mov cl, 3 ; 2nd sector (bootloader in sector 1)
    mov dh, 0 ; head 0
    mov dl, 0x80 ; read from harddrive
    mov bx, 0x2000 ; kernel address
    mov es, bx
    xor bx, bx     ; BX=0

    int 0x13 ; bios int.

    jc failed

    jmp 0x2000:0x0000

    cli
    hlt

failed:

    push emsg
    call print_string
    cli
    hlt

clearwindow:

    push bp
    mov bp, sp

    mov ah, 0x07
    mov al, 0x00
    mov bh, 0x07
    mov cx, 0x00        ; specifies top left of screen as (0,0)
    mov dh, 0x18        ; 18h = 24 rows of chars
    mov dl, 0x4f        ; 4fh = 79 cols of chars

    int 0x10

    mov sp, bp
    pop bp

    ret

movecursor:

    push bp
    mov bp, sp

    mov dx, [bp+4]
    mov ah, 0x02
    mov bh, 0x00
    
    int 0x10

    mov sp, bp
    pop bp

    ret

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
emsg db "Failed to load dummy", 0
kmsg db "Hello from kernel", 0

times 512 - ( $ - $$ ) db 0
