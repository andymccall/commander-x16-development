;
; Title:		       07-readchar - Assembler Example
;
; Description:     A program that prints strings to the console
;                  based on menu input
; Author:		    Andy McCall, mailme@andymccall.co.uk
;
; Created:		    2024-06-17 @ 16:43
; Last Updated:	 2024-06-17 @ 16:43
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

CHROUT                         := $FFD2 ; This routine will translate the value on the
                                        ; Accumulator register to a character code, and
                                        ; output to the default output device.
CHRIN                          := $FFCF

;-----------------------------------------------------------
; Constants

INPUT_1                        := $31
INPUT_2                        := $32
INPUT_3                        := $33
CR                             := $0D   ; ASCII/PETSCII code for carraige return
STR_PTR                        := $30   ; ASCII/PETSCII cide for zero

;-----------------------------------------------------------
; Macros

.macro PRINT_STRING str
   pha
   lda #<str
   sta STR_PTR
   lda #>str
   sta STR_PTR+1
   jsr printstr
   jsr printcr
   pla
.endmacro

.macro PRINT_PROMPT str
   pha
   lda #<str
   sta STR_PTR
   lda #>str
   sta STR_PTR+1
   jsr printstr
   pla
.endmacro

.macro PRINTCR
   jsr printcr
.endmacro

;-----------------------------------------------------------

start:
   jmp showmenu
   rts

showmenu:
   PRINT_STRING menu_header
   PRINTCR
   PRINT_STRING hello_menu
   PRINT_STRING goodbye_menu
   PRINT_STRING quit_menu
   PRINTCR
   PRINT_PROMPT prompt
@getinput:
   jsr CHRIN
@check_1:
   cmp #INPUT_1
   bne @check_2
   PRINTCR
   PRINT_STRING hello_msg
   bra @done
@check_2:
   cmp #INPUT_2
   bne @check_3
   PRINTCR
   PRINT_STRING goodbye_msg
   bra @done
@check_3:
   cmp #INPUT_3
   beq @quit
@done:
   PRINTCR
   jmp showmenu
@quit:
   PRINTCR
   PRINT_STRING quit_msg
   rts

printstr:
   phy
   ldy #0
@printchar:
   lda (STR_PTR),y
   beq @done
   jsr CHROUT
   iny
   bra @printchar
@done:
   ply
   rts

printcr:
   lda #CR
   jsr CHROUT
   rts

;-----------------------------------------------------------

menu_header:          .asciiz "menu"
hello_menu:           .asciiz "[1] say hello"
goodbye_menu:         .asciiz "[2] say goodbye"
quit_menu:            .asciiz "[3] quit"
prompt:               .asciiz "selection >"

hello_msg:            .asciiz "hello!"
goodbye_msg:          .asciiz "goodbye!"

quit_msg:             .asciiz "quitting..."