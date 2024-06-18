;
; Title:		       06-printnts - Assembler Example
;
; Description:     A program that prints null terminated strings to
;                  the console via a reusable macro
; Author:		    Andy McCall, mailme@andymccall.co.uk
;
; Created:		    2024-06-17 @ 16:43
; Last Updated:	 2024-06-17 @ 16:43
;
; Modinfo:
;
;-----------------------------------------------------------

.segment "STARTUP"
.segment "INIT"
.segment "ONCE"

.segment "ZEROPAGE"
ptr: .res 2

.segment "CODE"

   jmp start

;-----------------------------------------------------------
; Kernal Routines

CHROUT                         := $FFD2 ; This routine will translate the value on the
                                        ; Accumulator register to a character code, and
                                        ; output to the default output device.

;-----------------------------------------------------------
; Constants

CR                             := $0D   ; ASCII/PETSCII code for carraige return
STR_PTR                        := $30   ; ASCII/PETSCII cide for zero

;-----------------------------------------------------------
; Macros

.macro PRINT_STRING str
   pha
   lda #<str
   sta STR_PTR
   lda #>str
   sta STR_PTR+1
   jsr printstr
   pla
.endmacro

;-----------------------------------------------------------

start:
   lda #1
   sta not_divide
   PRINT_STRING helloworld_msg
   PRINT_STRING helloagain_msg
   rts

printstr:
   phy
   ldy #0
@printchar:
   lda (STR_PTR),y
   beq @done
   jsr CHROUT
   iny
   bra @printchar
@done:
   lda #CR
   jsr CHROUT
   ply
   rts

;-----------------------------------------------------------

helloworld_msg:       .asciiz "hello, world!"
helloagain_msg:       .asciiz "hello, again!"
not_divide:           .byte 1