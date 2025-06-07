.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

   jmp start

; MACROS
.macro VERA_SET_ADDR addr, stride
   .ifnblank stride
      .if stride < 0
         lda #((^addr) | $08 | ((0-stride) << 4))
      .else
         lda #((^addr) | (stride << 4))
      .endif
   .else
      lda #(^addr) | $10
   .endif

   sta VERA_addr_bank
   lda #(>addr)
   sta VERA_addr_high
   lda #(<addr)
   sta VERA_addr_low
.endmacro

.macro RAM2VRAM ram_addr, vram_addr, num_bytes
   .scope
      ; set data port 0 to start writing to VRAM address
      stz VERA_ctrl
      lda #($10 | ^vram_addr) ; stride = 1
      sta VERA_addr_bank
      lda #>vram_addr
      sta VERA_addr_high
      lda #<vram_addr
      sta VERA_addr_low
       ; ZP pointer = start of video data in CPU RAM
      lda #<ram_addr
      sta ZP_PTR
      lda #>ram_addr
      sta ZP_PTR+1
      ; use index pointers to compare with number of bytes to copy
      ldx #0
      ldy #0
   vram_loop:
      lda (ZP_PTR),y
      sta VERA_data0
      iny
      cpx #>num_bytes ; last page yet?
      beq check_end
      cpy #0
      bne vram_loop ; not on last page, Y non-zero
      inx ; next page
      inc ZP_PTR+1
      bra vram_loop
   check_end:
      cpy #<num_bytes ; last byte of last page?
      bne vram_loop ; last page, before last byte
   .endscope
.endmacro

; Zero Page
ZP_PTR            = $30
DISPLAY_SCALE     = 64

; VRAM Addresses
VRAM_sprite_frames= $00000

VRAM_sprattr   = $1FC00
sprite2_sprattr = VRAM_sprattr +8
; Sprite Attributes:
SPRITE_Z3      = $0C
SPRITE_16H     = $40
SPRITE_16W     = $10

; I/O Registers
VERA_addr_low     = $9F20
VERA_addr_high    = $9F21
VERA_addr_bank    = $9F22
VERA_data0        = $9F23
VERA_data1        = $9F24
VERA_ctrl         = $9F25

MOUSE_CONFIG      = $FF68

sprite:
.byte $00,$00,$0B,$BB,$BB,$B0,$00,$00
.byte $00,$00,$B6,$66,$66,$6B,$00,$00
.byte $00,$0B,$66,$66,$66,$66,$B0,$00
.byte $00,$0B,$66,$66,$66,$66,$B0,$00
.byte $00,$B6,$6B,$BB,$BB,$B6,$6B,$00
.byte $00,$B6,$B7,$77,$77,$7B,$6B,$00
.byte $00,$B6,$77,$B7,$7B,$77,$6B,$00
.byte $00,$B6,$77,$77,$77,$77,$6B,$00
.byte $00,$B6,$67,$77,$77,$76,$6B,$00
.byte $00,$0B,$66,$66,$66,$66,$B0,$00
.byte $00,$00,$B6,$BB,$BB,$6B,$00,$00
.byte $00,$B6,$66,$6B,$B6,$66,$6B,$00
.byte $00,$0B,$66,$66,$66,$66,$B0,$00
.byte $00,$B6,$66,$6B,$B6,$66,$6B,$00
.byte $00,$B6,$66,$6B,$B6,$66,$6B,$00
.byte $00,$0B,$66,$BB,$BB,$66,$B0,$00
end_sprite:
SPRITE_SIZE = end_sprite-sprite


frame: .word 0

start:

   ; initialize
   lda #<(VRAM_sprite_frames >> 5)
   sta frame
   
   ;------------------
   ; init sprite
   ;------------------
   stz VERA_ctrl
   VERA_SET_ADDR sprite2_sprattr, 1
   lda frame
   sta VERA_data0
   lda frame+1
   sta VERA_data0
   ; position $80x$80
   lda #$80
   sta VERA_data0
   lda VERA_data0
   lda #$80
   sta VERA_data0
   lda VERA_data0
   ; Z3
   lda #SPRITE_Z3
   sta VERA_data0
   ; set to 32x32, palette offset 0
   lda #(SPRITE_16H | SPRITE_16W)
   sta VERA_data0

   jsr MOUSE_CONFIG

    
   RAM2VRAM sprite, VRAM_sprite_frames, SPRITE_SIZE


@main_loop:
   wai
   ; do nothing in main loop, just let ISR do everything
   bra @main_loop
   ; never return, just wait for reset

