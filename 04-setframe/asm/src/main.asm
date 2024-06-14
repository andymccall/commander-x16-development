;
; Title:		       03-setframe - Assembler Example
;
; Description:     A program that sets the frame to red
; Author:		    Andy McCall, mailme@andymccall.co.uk
;
; Created:		    2024-06-14 @ 15:30
; Last Updated:	 2024-06-14 @ 15:30
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

SCREEN_MODE                   := $FF5F ; This routine will translate the value on the
                                       ; Accumulator register to a character code, and
                                       ; output to the default output device.

;-----------------------------------------------------------
; Constants
;
; Video modes
VIDEOMODE_80x60         := $00
VIDEOMODE_80x30         := $01
VIDEOMODE_40x60         := $02
VIDEOMODE_40x30         := $03
VIDEOMODE_40x15         := $04
VIDEOMODE_20x30         := $05
VIDEOMODE_20x15         := $06
VIDEOMODE_22x23         := $07
VIDEOMODE_64x50         := $08
VIDEOMODE_64x25         := $09
VIDEOMODE_32x50         := $0A
VIDEOMODE_32x25         := $0B
VIDEOMODE_320x240       := $80

start:
      
   lda #COLOR::RED                     ; Load the value for RED (2) into a
   sta VERA::DISP::FRAME               ; Call VERA to set the frame to the colour in a
   lda #VIDEOMODE_22x23
   clc
   jsr SCREEN_MODE
   rts                                 ; Return to the system

;-----------------------------------------------------------