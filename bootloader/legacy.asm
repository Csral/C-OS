bits 16
org 0x7C00

; Initialize the stack at 0x4000 or 0x5000
; Make stack 8k (8192)
; clear the window
; move cursor to 0,0
; load and call the kernel

; ensure proper memory pointer
mov ax, 0x7C00
mov ds, ax
mov es, ax

; set up stack at 0x4000 with size 8k

mov ax, 0x4000
mov ss, ax
mov sp, 0x2000 ; 8k stack

call clearwindow ; clear the tty

push 0x0000
call movecursor ; move cursor to start
add sp, 2 ; clear arg

; load kernel by reading 2nd sector

mov ah, 0x02
mov al, 0x01    ; read 1 sector
mov ch, 0x00    ; cylinder 0
mov cl, 0x02    ; 2nd sector
mov dh, 0x00    ; header 0
mov dl, 0x80    ; hard dive
mov bx, 0x1000  ; kernel address
mov es, bx      ; kernel address

int 0x13        ; read sectors BIOS interrupt

jc failed       ; error to find/read kernel

jmp 0x1000:0x0000   ; pass control to kernel

movecursor:

    ; Moves cursor to specified location. Doesn't ensure registers defaults and must be handled by users
    ; expects: argument (2 bytes) of the format: 0xrrcc where rr specifies the row number and cc specifies column number.
    ; use rr to initiate new lines
    ; returns: void

    push bp
    mov bp, sp

    mov dx, [bp+4]  ; cursor position given by user
    mov ah, 0x02    ; BIOS code
    mov bh, 0x00    ; 

    int 0x10

    mov sp, bp
    pop bp

    ret

clearwindow:

    ; clears the tty window
    ; expects: void
    ; returns: void

    mov ah, 0x07    ; BIOS code
    mov al, 0x00    ; clear whole screen
    mov bh, 0x07    ; white on black
    mov cx, 0x00    ; set 0,0 as top left
    mov dh, 0x18    ; 18 chars
    mov dl, 0x4f    ; 79 chars

    int 0x10

    ret

print_string:

    ; prints the given string to tty. Doesn't ensure registers defaults and must be handled by users
    ; expects: argument (2 bytes) for the string to print. Ensure the string ends in 0.
    ; returns: void

    push bp
    mov bp, sp

    mov si, [bp+4]  ; load the given string
    
    mov bx, 0x00    ;
    mov ax, 0x0E    ; tty write to cursor BIOs interrupt

char:

    mov al, [si]    ; load current char to al.
    add si, 2

    or al, 0        ; end of string?
    je returnS      ; end loop

    int 0x10        ; BIOS interrupt to print
    jmp char        ; repeat

returnS:

    mov sp, bp
    pop bp

    ret

failed:

    ; print failed status and halt cpu

    push failed_kernel_msg
    call print_string
    add sp, 2

    cli
    hlt

failed_kernel_msg db "Failed to load kernel. Check for: Unable to locate, sector issues, size issues, sectors read issues?", 0

times 510 - ( $ - $$ ) db 0     ; pad with 0
dw 0xAA55                       ; bootloader signature