# Bootloader

The primary task of bootloader is to initiate the system, load the kernel into memory and transfer the control to kernel.
In BIOS (Basic Input Output System) also known as legacy mode the bootloader depends on BIOS interrupts and runs in 16 bit mode by default which is known as real mode. This is because the BIOS calls are written to handle 16-bit arguments.

Here on some technical terms needs to be kept in mind:

* Legacy mode: BIOS based systems are said to be in legacy mode

## Key things to remember about bootloader

1) In legacy mode the BIOS always loads the bootloader at physical memory address 0x7C00
2) In legacy mode the bootloader must be exactly 512 bytes. This restriction can be bypassed (overcome).
3) The bootloader must end off with a valid bootloader signature which is 0xAA55 and the bytes are written as last 2 bytes of bootloader
4) 

## The booting process

In legacy mode, whenever you turn your computer on, the processor looks up at the physical address 0xFFFFFFF0 which contains the BIOS code (settings and config) and instructions for BIOS to load the bootloader. This address is a read-only segment on the hard disk.

The BIOS then performs POST which stands for Power-On-Self-Test which is a series of tests conducted on the I/O devices, disks and drives and other hardware components of computer by the BIOS to confirm their functionality. If any errors exists the computer produces a beep sound and prints the error.

If the BIOS deems some drive bootable, then it loads the first 512 bytes of the drive into memory address 0x007C00, and transfers program control to this address with a jump instruction to the processor.
