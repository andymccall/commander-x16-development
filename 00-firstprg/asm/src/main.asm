;
; Title:		       00-firstprg - Assembler Example
;
; Description:     A program that does nothing for the Commander X16
;                  intended to check your environment works with no
;                  issues
; Author:		    Andy McCall, mailme@andymccall.co.uk
;
; Created:		    2024-06-13 @ 14:07
; Last Updated:	 2024-06-13 @ 14:07
;
; Modinfo:
;

.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

start:
   rts