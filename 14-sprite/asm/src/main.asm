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

; https://github.com/X16Community/x16-docs/blob/master/X16%20Reference%20-%2009%20-%20VERA%20Programmer's%20Reference.md#9f29-9f2c
DC_VIDEO          = $9F29

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
; Row 0 - Empty/Hair
.byte $00,$00,$00,$00,$00,$00,$00,$00
; Row 1 - Hair/Head Top
.byte $00,$08,$88,$88,$88,$80,$00,$00
; Row 2 - Head/Forehead
.byte $08,$11,$22,$22,$22,$18,$00,$00
; Row 3 - Eye/Rotten Flesh
.byte $81,$24,$44,$22,$22,$21,$80,$00 ; Left eye socket, decay
; Row 4 - Eye/Nose
.byte $12,$22,$22,$22,$22,$22,$10,$00
; Row 5 - Jaw/Mouth
.byte $21,$22,$11,$11,$12,$21,$20,$00 ; Sunken mouth
; Row 6 - Neck/Shoulder
.byte $00,$12,$22,$22,$22,$21,$00,$00
; Row 7 - Shoulder/Torso (slight hunch)
.byte $00,$67,$77,$77,$77,$77,$60,$00
; Row 8 - Torso/Arm (tattered)
.byte $06,$77,$77,$77,$77,$77,$76,$00
; Row 9 - Torso/Arm
.byte $77,$77,$77,$77,$77,$77,$77,$70
; Row 10 - Tattered Clothing/Missing Arm (more decayed)
.byte $07,$77,$77,$00,$00,$77,$70,$00 ; Hole/decay on left side
; Row 11 - Waist/Legs
.byte $00,$77,$77,$77,$77,$77,$70,$00
; Row 12 - Legs (more asymmetric)
.byte $00,$67,$76,$00,$67,$76,$60,$00 ; One leg more decayed/missing lower part
; Row 13 - Legs
.byte $00,$67,$76,$00,$67,$76,$60,$00
; Row 14 - Feet/Stumps
.byte $00,$00,$66,$00,$00,$66,$00,$00
; Row 15
.byte $00,$00,$00,$00,$00,$00,$00,$00
end_sprite:
SPRITE_SIZE = end_sprite-sprite

frame: .word 0

start:

; Initialize
   lda #<(VRAM_sprite_frames >> 1)
   sta frame
   
;------------------
; Init sprite
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

;----------------------------------
; Setup the display to show sprites
;----------------------------------
   ; Enable sprites by pushing config into DC_VIDEO
   ; Example: Enable Sprites, Layer 0, Layer 1, and VGA output
   ; %01110001 (binary) = $71 (hex)
   ; Bit 7: 1 (Sprites enabled)
   ; Bit 6: 1 (Layer 1 enabled)
   ; Bit 5: 1 (Layer 0 enabled)
   ; Bit 4: 0 (assuming default tile base)
   ; Bit 3: 0 (scanline interrupt disabled)
   ; Bit 2: 0 (line doubler disabled)
   ; Bit 1: 0 (VGA mode bit 1)
   ; Bit 0: 1 (VGA mode bit 0)
   ; Note: For VGA, bits 1 and 0 of $9F29 usually form 01b for 640x480, or 10b for 320x240 (with line doubling).
   ; The most common VGA setup usually results in a value of $71 if you want 640x480 with both layers.

; Load the current config
   lda DC_VIDEO
; Or the existing config with the config I want, based on the bitmask above
   ora #%01110000
; Write it back to the DC_VIDEO address
   sta DC_VIDEO
    
; Finally copy the sprite to the video ram
   RAM2VRAM sprite, VRAM_sprite_frames, SPRITE_SIZE


@main_loop:
   wai
   ; do nothing in main loop, just let ISR do everything
   bra @main_loop
   ; never return, just wait for reset

