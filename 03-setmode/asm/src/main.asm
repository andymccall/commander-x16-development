;
; Title:		       03-setmode - Assembler Example
;
; Description:     A program that sets the screen mode
; Author:		    Andy McCall, mailme@andymccall.co.uk
;
; Created:		    2024-06-14 @ 15:30
; Last Updated:	 2024-06-14 @ 15:30
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
;VIDEOMODE_80COL         VIDEOMODE_80x60
;VIDEOMODE_40COL         VIDEOMODE_40x30
VIDEOMODE_320x240       := $80

;-----------------------------------------------------------

start:
                
   lda #VIDEOMODE_40x60
   clc
   jsr SCREEN_MODE
   rts                                 ; Return to the system

;-----------------------------------------------------------