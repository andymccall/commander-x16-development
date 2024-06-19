;
; Title:		       05-setscreen - Assembler Example
;
; Description:     A program that sets the screen to red
; Author:		    Andy McCall, mailme@andymccall.co.uk
;
; Created:		    2024-06-19 @ 17:00
; Last Updated:	 2024-06-19 @ 15:00
;
; Modinfo:
;
;-----------------------------------------------------------

.include "cx16.inc"

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
;
; Colors

RED                           := $1C
WHITE                         := $90
;-----------------------------------------------------------
; Macros

.macro CLEAR_SCREEN
   pha
   lda #$93
   jsr CHROUT
   pla
.endmacro

.macro SWAP_FGBG
   pha
   lda #1
   jsr CHROUT
   pla
.endmacro

start:
      
   lda #RED
   jsr CHROUT
   SWAP_FGBG
   lda #WHITE
   jsr CHROUT
   CLEAR_SCREEN
   rts                                 ; Return to the system

;-----------------------------------------------------------