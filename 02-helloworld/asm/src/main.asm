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

CHROUT                        := $FFD2 ; This routine will translate the value on the
                                       ; Accumulator register to a character code, and
                                       ; output to the default output device.

;-----------------------------------------------------------
; Constants

CR                             := $0D   ; ASCII/PETSCII code for carraige return

;-----------------------------------------------------------

start:
   lda #<string                        ; Load the address of the string into the accumulator
   sta ptr                             ; Store the contents of the accumulator in memory
   lda #>string_end                    ; Load the address of the string end into the accumulator
   sta ptr+1                           ; Store the accumulator in memory at ptr+1
   ldy #0                              ; Set y to 0
@printchar:
   cpy #(string_end-string)            ; Compare Y with the value of string_end-string, setting z if equal
   beq @newline                        ; If z is set, jump to newline (carry on otherwise...)
   lda (ptr),y                         ; Load the address ptr (pointing to the string) at position y into a, 
   jsr CHROUT                          ; Calls the CHROUT kernal routine to display the character in a
   iny                                 ; Increment y register, moving the pointer to the next character
   bra @printchar                      ; Loop back to the printchar location for next character
@newline:
   lda #CR                             ; Load the CR character code into a
   jsr CHROUT                          ; Call the CHROUT kernal routing to display the character in a
   rts                                 ; Return to the system

;-----------------------------------------------------------

string:     .byte "hello, world!"
string_end: