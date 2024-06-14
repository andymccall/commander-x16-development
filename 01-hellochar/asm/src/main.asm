;
; Title:		       01-hellochar - Assembler Example
;
; Description:     A program that prints "X" to
;                  the console
; Author:		    Andy McCall, mailme@andymccall.co.uk
;
; Created:		    2024-06-13 @ 14:46
; Last Updated:	 2024-06-13 @ 14:46
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

CHROUT                        := $FFD2 ; This routine will translate the value on the
                                       ; Accumulator register to a character code, and
                                       ; output to the default output device.

;-----------------------------------------------------------
; Constants

CR                             := $0D  ; ASCII/PETSCII code for carraige return

;-----------------------------------------------------------

start:
   
   lda #'x'                             ; Load the address of char into a
   jsr CHROUT                          ; Calls the CHROUT kernal routine to display the character in a

   lda #CR                             ; Load the CR character code into a
   jsr CHROUT                          ; Call the CHROUT kernal routing to display the character in a
   rts                                 ; Return to the system

;-----------------------------------------------------------

char:     .byte "x"
char_end: