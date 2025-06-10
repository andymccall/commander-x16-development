.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; Equates
SCREEN_MODE                      = $FF5F

GRAPH_init                       = $FF20
GRAPH_clear                      = $FF23
GRAPH_put_char                   = $FF41

; Kernal Registers
r0					                  = $02
r0L					               = r0
r0H					               = r0+1
r1					                  = $04
r1L					               = r1
r1H					               = r1+1

; Screen mode
SCREEN_MODE_320X240_256C         = $80

start:

   lda #<SCREEN_MODE_320X240_256C
   clc
   jsr SCREEN_MODE

   lda #100
   sta r0L
   lda #0
   sta r0H

   lda #50
   sta r1L
   lda #0
   sta r1H

   lda #'H'

   jsr GRAPH_put_char

   rts