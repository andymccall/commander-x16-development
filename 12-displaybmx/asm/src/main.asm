;
; Title:		       12-showpng - Assembler Example
;
; Description:     A program that shows a png on the
;                  Commander X16
; Author:		    Andy McCall, mailme@andymccall.co.uk
;
; Created:		    2024-08-17 @ 16:21
; Last Updated:	 2024-08-17 @ 16:21
;
; Modinfo:
;
;-----------------------------------------------------------

.segment "ONCE"

;Two macros to make word operations easier
.macro cmpWord op1,op2
.scope
   ;compare high bytes
   lda op1+1
   cmp op2+1
   beq CheckLowByte
   
   jmp Endcmp      ;carry bit will tell greater of smaller
   
   CheckLowByte:
   lda op1
   cmp op2
   
   Endcmp:
.endscope
.endmacro

.macro sbcWord op1,op2,addrResult
.scope
   lda op1
   sec
   sbc op2
   sta addrResult
   lda op1+1
   sbc op2+1
   sta addrResult+1
.endscope
.endmacro

.macro CopyWord sFrom,sTo
   pha
      lda sFrom
      sta sTo
      lda sFrom+1
      sta sTo+1
   pla
.endmacro


jmp start

;.include "x16.s"
VERA_addr_low     = $9F20
VERA_addr_high    = $9F21
VERA_addr_bank    = $9F22
VERA_data0        = $9F23
VERA_data1        = $9F24
VERA_ctrl         = $9F25
SETLFS            = $FFBA
SETNAM            = $FFBD
OPEN              = $FFC0
CLOSE             = $FFC3
CHKIN             = $FFC6
CLRCHN            = $FFCC
CHRIN             = $FFCF
VERA_isr          = $9F27
MACPTR            = $FF44
DEBUG             = $9FBB
VERA_L0_config    = $9F2D
VERA_dc_video     = $9F29
GRAPH_init        = $FF20
GRAPH_clear       = $FF23

;File to be drawn
File:       .byte "ASSETS/SCREENS/DD1SPLASH.BMX" 
File_End:

;x,y coordinates in px where the bmx should be drawn
OffsetX:    .word 20
OffsetY:    .word 30

;ZSM header according to documentation
BMXHeader:     ;32 bytes
   BMXFileID:              .res 3
   BMXVersion:             .res 1
   BMXBitDepth:            .res 1
   BMXVeraColorDepthReg:   .res 1
   BMXWidth:               .res 2
   BMXHeight:              .res 2
   BMXPaletteCount:        .res 1
   BMXPaletteStart:        .res 1
   BMXDataStart:           .res 2
   BMXCompressed:          .res 1      ;Compressed BMX is not implemented in this example!!!
   BMXVeraBorderColor:     .res 1
   BMXReserverd:           .res 16

VERATmp1:   .byte 0
VERATmp2:   .byte 0
VERATmp3:   .byte 0


BytesPerLine:        .word 0
MaxChunckSize:       .word 255   ;max 255 bytes
CurrentChunckSize:   .word 0
Word0:               .word 0
Word1:               .word 1
Word320:             .word 320

start:
   jsr GRAPH_init
   jsr GRAPH_clear
   
   jsr OpenBMXFile
   jsr ReadBMXHeader
   jsr ReadPaletteFromBMX
   
   ;Hide textlayer,show bitmap layer
   lda #%00010001
   sta VERA_dc_video
  
   ;Change colordepth to what is specified in BMX header   
   lda VERA_L0_config
   ORA BMXVeraColorDepthReg
   sta VERA_L0_config
   
   ;Default bitmaplayer starts at $00000
   stz VERA_addr_low
   stz VERA_addr_high
   lda #$10
   sta VERA_addr_bank      ;Auto increment by 1
 
   ;Advance VERA address to offset x and y  
   cmpWord OffsetY,Word0   ;If OffsetY=0 then skip
   beq SkipSetYOffset
      CopyWord Word320,NumberToAdd
      :  ;320px per y
         jsr AddWordToVera   
         dec OffsetY
         bne :-
   SkipSetYOffset:
   
   ;Add OffsetX
   CopyWord OffsetX,NumberToAdd
   jsr AddWordToVera  
   
   StartDrawing:
      
      jsr SaveVera      ;Backup vera address
      jsr DrawLine
      jsr RestoreVera   ;Restore vera address
      
      CopyWord Word320,NumberToAdd
      jsr AddWordToVera

      sbcWord BMXHeight,Word1,BMXHeight   ;Draw lines until height is 0
      cmpWord BMXHeight,Word0
   bne StartDrawing

   jsr CloseFile
rts

DrawLine:
   CopyWord BMXWidth,BytesPerLine
   
   ReadNextChunck:

      ldx #<VERA_data0
      ldy #>VERA_data0

      
      ;Width determines chunks
      cmpWord BytesPerLine,MaxChunckSize
      bcs LoadFullChunck
         lda BytesPerLine
         sta CurrentChunckSize
         jmp ReadChunck
      LoadFullChunck:
         lda MaxChunckSize  
         sta CurrentChunckSize 
      ReadChunck:
      
      sec 
      jsr MACPTR

      sbcWord BytesPerLine,CurrentChunckSize,BytesPerLine
      cmpWord BytesPerLine,Word0
   bne ReadNextChunck
rts


OpenBMXFile:
   lda #(File_End-File)
   ldx #<File
   ldy #>File
   jsr SETNAM   

   ;prepare file for OUTPUT
   lda #1  
   ldx #8  
   ldy #2  
   jsr SETLFS
   jsr OPEN  
   ldx #1
   jsr CHKIN
rts

CloseFile:
   jsr CLRCHN
   lda #1
   jsr CLOSE
rts

ReadBMXHeader:
   ;load BMX header
   ldx #<BMXHeader
   ldy #>BMXHeader
   lda #32
   clc 
   jsr MACPTR 

rts

ReadPaletteFromBMX:
   ;Load custom palette at specific offset
   ;set vera to palette offset 
   lda #$00
   sta VERA_addr_low
   lda #$FA
   sta VERA_addr_high
   lda #$11
   sta VERA_addr_bank 
   
   ;Add vera palette offset twice as the bmx header value is an index
   ;and vera uses 2 bytes per colorindex

   stz NumberToAdd+1
   lda BMXPaletteStart
   sta NumberToAdd
   jsr AddWordToVera
   jsr AddWordToVera

   
   :  ;Read palette data 2 bytes per palete count index
      jsr CHRIN
      sta VERA_data0
      jsr CHRIN
      sta VERA_data0
      dec BMXPaletteCount
      bne :- 
rts

SaveVera:
pha
    lda VERA_addr_low
    sta VERATmp1
    lda VERA_addr_high
    sta VERATmp2
    lda VERA_addr_bank
    sta VERATmp3
pla    
rts

RestoreVera:
pha
    lda VERATmp1
    sta VERA_addr_low
    lda VERATmp2
    sta VERA_addr_high
    lda VERATmp3
    sta VERA_addr_bank
pla
rts

AddWordToVera:
jmp AddWordToVera_start
   NumberToAdd:   .word 0
AddWordToVera_start:
pha
    LDA VERA_addr_low  
    CLC        
    ADC NumberToAdd  
    STA VERA_addr_low   

    LDA VERA_addr_low+1 
    ADC NumberToAdd+1 
    STA VERA_addr_low+1      
   
    LDA VERA_addr_low+2 
    ADC #0
    STA VERA_addr_low+2   
pla
rts
