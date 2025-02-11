bits 16
org 0x7C00

mov ax, 0x7E0
mov ss, ax
mov sp, 0x4000

call clearwindow

push 0x0000
call movecursor
add sp, 2

push bmsg
call print_string

mov ah, 0x02
mov al, 0x01 ; read only 1 sector
mov ch, 0 ; cylindered 0
mov cl, 2 ; 2nd sector (bootloader in sector 1)
mov dh, 0 ; head 0
mov dl, 0x80 ; read from harddrive
mov bx, 0x1000 ; kernel address
mov es, bx

int 0x13 ; interrupt BIOS

jc failed

jmp 0x1000:0x0000

failed:

    push msg
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

msg db "Error: Failed to read/load kernel", 0
bmsg db "Hello from bootloader!", 0

times 510 - ($ - $$) db 0
dw 0xAA55