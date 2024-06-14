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

start:
                
   lda #COLOR::RED                     ; Load the value for RED (2) into a
   sta VERA::DISP::FRAME               ; Call VERA to set the frame to the colour in a
   rts                                 ; Return to the system

;-----------------------------------------------------------