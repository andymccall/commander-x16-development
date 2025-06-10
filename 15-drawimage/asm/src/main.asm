;
; Title:		       15-drawimage - Assembler Example
;
; Description:     A program that draws an image to the screen
;                  on the Commander X16
; Author:		    Andy McCall, mailme@andymccall.co.uk
;
; Created:		    2025-06-10 @ 14:07
; Last Updated:	 2025-06-10 @ 14:07
;
; Modinfo:
;

.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; Equates
GETIN                            = $FFE4
SCREEN_MODE                      = $FF5F
GRAPH_init                       = $FF20
GRAPH_draw_image                 = $FF38
GRAPH_clear                      = $FF23
GRAPH_set_colors                 = $FF29
enter_basic                      = $FF47

QUIT                             = $51

; Kernal Registers
r0		                           = $02
r0L		                        = r0
r0H		                        = r0+1

r1		                           = $04
r1L		                        = r1
r1H		                        = r1+1

r2		                           = $06
r2L		                        = r2
r2H		                        = r2+1

r3		                           = $08
r3L		                        = r3
r3H		                        = r3+1

r4		                           = $0A
r4L		                        = r4
r4H		                        = r4+1

; Screen mode
SCREEN_MODE_320X240_256C         = $80
SCREEN_MODE_80X60                = $00

image_data:
    .incbin "../assets/draw_image.bin"

start:
   
   jsr GRAPH_init

   lda #<SCREEN_MODE_320X240_256C
   clc
   jsr SCREEN_MODE

   lda #$00             ; Stroke
   ldx #$00             ; Fill
   ldy #$00             ; background
   jsr GRAPH_set_colors
   
   jsr GRAPH_clear

; Put image

   lda #10
   sta r0L
   lda #0
   sta r0H

   lda #10
   sta r1L
   lda #0
   sta r1H

   lda #<image_data
   sta r2L
   lda #>image_data
   sta r2H

   lda #64
   sta r3L
   lda #0
   sta r3H

   lda #64
   sta r4L
   lda #0
   sta r4H

   jsr GRAPH_draw_image

loop:
   jsr GETIN
   cmp #QUIT
   beq quit
   jmp loop

; Reset screen mode and drop back to BASIC
quit:
   lda #<SCREEN_MODE_80X60
   clc
   jsr SCREEN_MODE
   sec
   jsr enter_basic    ; enter BASIC sec for cold restart.
