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

SCREEN_MODE                    := $FF5F ;

;-----------------------------------------------------------
; Constants

INPUT_1                        := $31
INPUT_2                        := $32
INPUT_3                        := $33
INPUT_4                        := $34
INPUT_5                        := $35
INPUT_6                        := $36
INPUT_7                        := $37
INPUT_8                        := $38
INPUT_9                        := $39

CR                             := $0D   ; ASCII/PETSCII code for carraige return
STR_PTR                        := $30   ; ASCII/PETSCII cide for zero

; Video modes
VIDEOMODE_80x60         := $00
VIDEOMODE_80x30         := $01
VIDEOMODE_40x60         := $02
VIDEOMODE_40x30         := $03
VIDEOMODE_40x15         := $04
VIDEOMODE_20x30         := $05
VIDEOMODE_20x15         := $06
VIDEOMODE_80COL         := VIDEOMODE_80x60
VIDEOMODE_40COL         := VIDEOMODE_40x30
VIDEOMODE_320x240       := $80

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

.macro CLEAR_SCREEN
   pha
   lda #$93
   jsr CHROUT
   pla
.endmacro

.macro SET_SCREEN_MODE mode
   pha
   lda #mode
   clc
   jsr SCREEN_MODE
   pla
.endmacro

.macro SET_BACKGROUND_COLOR color
   pha
   lda #1
   jsr CHROUT
   lda #color
   jsr CHROUT
   lda #1
   jsr CHROUT
   CLEAR_SCREEN
   pla
.endmacro

;-----------------------------------------------------------

start:
   jmp top_showmenu
   rts

top_showmenu:
   PRINT_STRING menu_header
   PRINTCR
   PRINT_STRING resolution_menu_item
   PRINT_STRING text_color_menu_item
   PRINT_STRING background_color_menu_item
   PRINT_STRING border_color_menu_item
   PRINT_STRING clear_screen_menu_item
   PRINT_STRING quit_menu_item
   PRINTCR
   PRINT_PROMPT prompt
@getinput:
   jsr CHRIN
@check_1:
   cmp #INPUT_1
   bne @check_2
   PRINTCR
   jmp resolution_menu
   bra @done
@check_2:
   cmp #INPUT_2
   bne @check_3
   PRINTCR
   jmp text_color_menu
   PRINTCR
   bra @done
@check_3:
   cmp #INPUT_3
   bne @check_4
   PRINTCR
   jmp background_color_menu
   PRINTCR
   beq @done
@check_4:
   cmp #INPUT_4
   bne @check_5
   PRINTCR
   jmp border_color_menu
   PRINTCR
   beq @done
@check_5:
   cmp #INPUT_5
   bne @check_6
   CLEAR_SCREEN
   beq @done
@check_6:
   cmp #INPUT_6
   beq @quit
@done:
   PRINTCR
   jmp top_showmenu
@quit:
   PRINTCR
   PRINT_STRING quit_msg
   rts

resolution_menu:
   PRINT_STRING resolution_header
   PRINTCR
   PRINT_STRING videomode_80x60_item
   PRINT_STRING videomode_80x30_item
   PRINT_STRING videomode_40x60_item
   PRINT_STRING videomode_40x30_item
   PRINT_STRING videomode_40x15_item
   PRINT_STRING videomode_20x30_item
   PRINT_STRING videomode_20x15_item
   PRINT_STRING videomode_320x240_item
   PRINT_STRING resolution_back_item
   PRINTCR
   PRINT_PROMPT prompt
@getinput:
   jsr CHRIN
@check_1:
   cmp #INPUT_1
   bne @check_2
   SET_SCREEN_MODE VIDEOMODE_80x60
   bra @done
@check_2:
   cmp #INPUT_2
   bne @check_3
   SET_SCREEN_MODE VIDEOMODE_80x30
   bra @done
@check_3:
   cmp #INPUT_3
   bne @check_4
   SET_SCREEN_MODE VIDEOMODE_40x60
   beq @done
@check_4:
   cmp #INPUT_4
   bne @check_5
   SET_SCREEN_MODE VIDEOMODE_40x30
   beq @done
@check_5:
   cmp #INPUT_5
   bne @check_6
   SET_SCREEN_MODE VIDEOMODE_40x15
   beq @done
@check_6:
   cmp #INPUT_6
   bne @check_7
   SET_SCREEN_MODE VIDEOMODE_20x30
   beq @done
@check_7:
   cmp #INPUT_7
   bne @check_8
   SET_SCREEN_MODE VIDEOMODE_20x15
   beq @done
@check_8:
   cmp #INPUT_8
   bne @check_9
   SET_SCREEN_MODE VIDEOMODE_320x240
   beq @done
@check_9:
   cmp #INPUT_9
   beq @back
@done:
   PRINTCR
   jmp resolution_menu
@back:
   PRINTCR
   jmp top_showmenu

text_color_menu:
   PRINT_STRING text_color_header
   PRINTCR
   PRINT_STRING white_item
   PRINT_STRING red_item
   PRINT_STRING green_item
   PRINT_STRING blue_item
   PRINT_STRING orange_item
   PRINT_STRING black_item
   PRINT_STRING brown_item
   PRINT_STRING pink_item
   PRINT_STRING back_item
   PRINTCR
   PRINT_PROMPT prompt
@getinput:
   jsr CHRIN
@check_1:
   cmp #INPUT_1
   bne @check_2
   bra @done
@check_2:
   cmp #INPUT_2
   bne @check_3
   bra @done
@check_3:
   cmp #INPUT_3
   bne @check_4
   beq @done
@check_4:
   cmp #INPUT_4
   bne @check_5
   beq @done
@check_5:
   cmp #INPUT_5
   bne @check_6
   beq @done
@check_6:
   cmp #INPUT_6
   bne @check_7
   beq @done
@check_7:
   cmp #INPUT_7
   bne @check_8
   beq @done
@check_8:
   cmp #INPUT_8
   bne @check_9
   beq @done
@check_9:
   cmp #INPUT_9
   beq @back
@done:
   PRINTCR
   jmp text_color_menu
@back:
   PRINTCR
   jmp top_showmenu

background_color_menu:
   PRINT_STRING background_color_header
   PRINTCR
   PRINT_STRING white_item
   PRINT_STRING red_item
   PRINT_STRING green_item
   PRINT_STRING blue_item
   PRINT_STRING orange_item
   PRINT_STRING black_item
   PRINT_STRING brown_item
   PRINT_STRING pink_item
   PRINT_STRING back_item
   PRINTCR
   PRINT_PROMPT prompt
@getinput:
   jsr CHRIN
@check_1:
   cmp #INPUT_1
   bne @check_2
   SET_BACKGROUND_COLOR CH_WHITE
   bra @done
@check_2:
   cmp #INPUT_2
   bne @check_3
   SET_BACKGROUND_COLOR CH_RED
   bra @done
@check_3:
   cmp #INPUT_3
   bne @check_4
   SET_BACKGROUND_COLOR CH_GREEN
   beq @done
@check_4:
   cmp #INPUT_4
   bne @check_5
   SET_BACKGROUND_COLOR CH_BLUE
   beq @done
@check_5:
   cmp #INPUT_5
   bne @check_6
   beq @done
@check_6:
   cmp #INPUT_6
   bne @check_7
   beq @done
@check_7:
   cmp #INPUT_7
   bne @check_8
   beq @done
@check_8:
   cmp #INPUT_8
   bne @check_9
   beq @done
@check_9:
   cmp #INPUT_9
   beq @back
@done:
   PRINTCR
   jmp background_color_menu
@back:
   PRINTCR
   jmp top_showmenu

border_color_menu:
   PRINT_STRING border_color_header
   PRINTCR
   PRINT_STRING white_item
   PRINT_STRING red_item
   PRINT_STRING green_item
   PRINT_STRING blue_item
   PRINT_STRING orange_item
   PRINT_STRING black_item
   PRINT_STRING brown_item
   PRINT_STRING pink_item
   PRINT_STRING back_item
   PRINTCR
   PRINT_PROMPT prompt
@getinput:
   jsr CHRIN
@check_1:
   cmp #INPUT_1
   bne @check_2
   bra @done
@check_2:
   cmp #INPUT_2
   bne @check_3
   bra @done
@check_3:
   cmp #INPUT_3
   bne @check_4
   beq @done
@check_4:
   cmp #INPUT_4
   bne @check_5
   beq @done
@check_5:
   cmp #INPUT_5
   bne @check_6
   beq @done
@check_6:
   cmp #INPUT_6
   bne @check_7
   beq @done
@check_7:
   cmp #INPUT_7
   bne @check_8
   beq @done
@check_8:
   cmp #INPUT_8
   bne @check_9
   beq @done
@check_9:
   cmp #INPUT_9
   beq @back
@done:
   PRINTCR
   jmp border_color_header
@back:
   PRINTCR
   jmp top_showmenu

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

menu_header:                 .asciiz "menu"
resolution_menu_item:        .asciiz "[1] change resolution"
text_color_menu_item:        .asciiz "[2] change text color"
background_color_menu_item:  .asciiz "[3] change background color"
border_color_menu_item:      .asciiz "[4] change border color"
clear_screen_menu_item:      .asciiz "[5] clear the screen"
quit_menu_item:              .asciiz "[6] quit"
prompt:                      .asciiz "selection >"

resolution_header:           .asciiz "resolution"
videomode_80x60_item:        .asciiz "[1] 80x60"
videomode_80x30_item:        .asciiz "[2] 80x30"
videomode_40x60_item:        .asciiz "[3] 40x60"
videomode_40x30_item:        .asciiz "[4] 40x30"
videomode_40x15_item:        .asciiz "[5] 40x15"
videomode_20x30_item:        .asciiz "[6] 20x30"
videomode_20x15_item:        .asciiz "[7] 20x15"
videomode_320x240_item:      .asciiz "[8] 320x240"
resolution_back_item:        .asciiz "[9] back"

text_color_header:           .asciiz "text color"
background_color_header:     .asciiz "background color"
border_color_header:         .asciiz "border color"

white_item:                  .asciiz "[1] white"
red_item:                    .asciiz "[2] red"
green_item:                  .asciiz "[3] green"
blue_item:                   .asciiz "[4] blue"
orange_item:                 .asciiz "[5] orange"
black_item:                  .asciiz "[6] black"
brown_item:                  .asciiz "[7] brown"
pink_item:                   .asciiz "[8] pink"

back_item:                   .asciiz "[9] back"

quit_msg:                    .asciiz "quitting..."