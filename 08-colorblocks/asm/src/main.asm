;
; Title:		       08-colorblocks - Assembler Example
;
; Description:     A program that prints color blocks
;                  to the screen
; Author:		    Andy McCall, mailme@andymccall.co.uk
;
; Created:		    2024-06-19 @ 17:01
; Last Updated:	 2024-06-20 @ 11:16
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

; Character Codes

CH_COLOR_SWAP           := $01

; Colors

CH_WHITE                := $05
CH_RED                  := $1C
CH_GREEN                := $1E
CH_BLUE                 := $1F
CH_ORANGE               := $81
CH_BLACK                := $90
CH_BROWN                := $95
CH_PINK                 := $96
CH_LIGHTRED             := CH_PINK
CH_GRAY1                := $97
CH_GRAY2                := $98
CH_LIGHTGREEN           := $99
CH_LIGHTBLUE            := $9A
CH_GRAY3                := $9B
CH_PURPLE               := $9C
CH_YELLOW               := $9E
CH_CYAN                 := $9F

;-----------------------------------------------------------
; Macros

.macro CLEAR_SCREEN
   pha
   lda #$93
   jsr CHROUT
   pla
.endmacro

.macro PRINT_BLOCK color
   pha
   lda #color
   jsr CHROUT
   lda #CH_COLOR_SWAP
   jsr CHROUT
   lda #' '
   jsr CHROUT
   pla
.endmacro

; Memory location $0376 contains the original colors for
; the fg and bg, the high nibble is the bg color and low
; nibble is fg color.  Save these to resote later in
; original_colors
.macro SAVE_COLORS
   pha
   lda $0376
   sta original_colors
   pla 
.endmacro

; Writing the saved value in original_colors back to the
; memory location $0376 will restore the original setting
; of the fg and bg
.macro RESTORE_COLORS
   pha
   lda original_colors
   sta $0376
   pla
.endmacro

start:
 
   CLEAR_SCREEN

   SAVE_COLORS

   PRINT_BLOCK CH_CYAN
   PRINT_BLOCK CH_WHITE
   PRINT_BLOCK CH_RED
   PRINT_BLOCK CH_GREEN
   PRINT_BLOCK CH_BLUE
   PRINT_BLOCK CH_ORANGE
   PRINT_BLOCK CH_BLACK
   PRINT_BLOCK CH_BROWN
   PRINT_BLOCK CH_PINK
   PRINT_BLOCK CH_LIGHTRED
   PRINT_BLOCK CH_GRAY1
   PRINT_BLOCK CH_GRAY2
   PRINT_BLOCK CH_LIGHTGREEN
   PRINT_BLOCK CH_LIGHTBLUE
   PRINT_BLOCK CH_GRAY3
   PRINT_BLOCK CH_PURPLE
   PRINT_BLOCK CH_YELLOW
   PRINT_BLOCK CH_CYAN
   
   RESTORE_COLORS

   rts                                 ; Return to the system

;-----------------------------------------------------------

original_colors:         .res 1