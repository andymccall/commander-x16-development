;
; Title:		       01-helloworld - Assembler Example
;
; Description:     A program that prints "Hello, World!" to
;                  the console
; Author:		    Andy McCall, mailme@andymccall.co.uk
;
; Created:		    024-06-13 @ 14:46
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

CHROUT                  := $FFD2
SCREEN_MODE             := $FF5F
MOUSE_CONFIG            := $FF68
MOUSE_GET               := $FF6B

;-----------------------------------------------------------
; Constants

; Video modes
VIDEOMODE_320x240       := $80

CLR                     := $93
MOUSE_X                 := $32
MOUSE_Y                 := $34

; VERA
VERA_addr_low           := $9F20
VERA_addr_high          := $9F21
VERA_addr_bank          := $9F22
VERA_data0              := $9F23
VERA_ctrl               := $9F25

; Colors
WHITE                   := 1

paint_color: .byte WHITE << 4

;-----------------------------------------------------------
; Macros

.macro CLEAR_SCREEN
   pha
   lda #CLR
   jsr CHROUT
   pla
.endmacro

;-----------------------------------------------------------

start:

   CLEAR_SCREEN

   sec
   lda #VIDEOMODE_320x240
   jsr SCREEN_MODE
   lda #1
   jsr MOUSE_CONFIG

main_loop:
   jsr get_mouse_xy
   bit #$01
   beq main_loop ; not left button
   jsr paint_canvas
   bra main_loop

   rts                                 ; Return to the system

get_mouse_xy: ; Output: A = button ID; X/Y = text map coordinates
   ldx #MOUSE_X
   jsr MOUSE_GET
   ; divide coordinates by 8
   lsr MOUSE_X+1
   ror MOUSE_X
   lsr MOUSE_X+1
   ror MOUSE_X
   lsr MOUSE_X+1
   ror MOUSE_X
   ldx MOUSE_X
   lsr MOUSE_Y+1
   ror MOUSE_Y
   lsr MOUSE_Y+1
   ror MOUSE_Y
   lsr MOUSE_Y+1
   ror MOUSE_Y
   ldy MOUSE_Y
   rts

paint_canvas: ; Input: X/Y = text map coordinates
   stz VERA_ctrl
   lda #$01 ; stride = 0, bank 1
   sta VERA_addr_bank
   tya
   clc
   adc #$B0
   sta VERA_addr_high ; Y
   txa
   asl
   inc
   sta VERA_addr_low ; 2*X + 1
   lda paint_color
   sta VERA_data0
   rts

;-----------------------------------------------------------
