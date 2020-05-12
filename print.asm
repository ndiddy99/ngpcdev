;*****************************************
;	Print functions 
;*****************************************
	$MAXIMUM
	module print

;  ---------------------------------
;	EXTERNAL LOOK UP
;  ---------------------------------
	extern SYSTEM_CALL
;  ---------------------------------
;   EXTERNAL DEFINITION
;  ---------------------------------
	public print_init,print_string,print_byte,print_word

;  ---------------------------------
;	INCLUDE
;  ---------------------------------
	$include "k1head.inc"
	$include "system.inc"

;-------------------------------------------------------
PROG section code large
;-------------------------------------------------------

;-------------------------------------------------------
; print_init: loads system font into first half of vram
;-------------------------------------------------------
print_init:
	ldb	ra3,3
	ldb	rw3,VECT_SYSFONTSET
	cal	SYSTEM_CALL
	ret

;-------------------------------------------------------
; print_string
;-------------------------------------------------------
; xix: pointer to null terminated text
; wa: x pos
; bc: y pos
;-------------------------------------------------------
print_string:
	;calculate screen offset
	lda xiy,SCRL1_VRAM
	slaw 1,wa ;2 bytes per tile
	slaw 6,bc ;each column is 0x40 bytes
	addw iy,wa
	addw iy,bc
copy_text:
	ldb a,(xix+)
	andb a,a
	j z,done_copy_text
	ldb (xiy+),a
	ldb (xiy+),0
	j copy_text
done_copy_text:
	ret
	
;-------------------------------------------------------
; print_byte
;-------------------------------------------------------
; xix: pointer to byte to print
; wa: x pos
; bc: y pos
;-------------------------------------------------------
print_byte:
	;calculate screen offset
	lda xiy,SCRL1_VRAM
	slaw 1,wa ;2 bytes per tile
	slaw 6,bc ;each column is 0x40 bytes
	addw iy,wa
	addw iy,bc
	;---first nybble---
	ldb a,(xix)
	ldb b,a
	andb b,0xf0 ;isolate high nybble
	srlb 4,b
	cpb b,0xa
	j nc,byte_atf0
	addb b,0x30 ;if nybble between 0 and 9, add 0x30
	j byte_doneadd0
byte_atf0: ;if nybble between a and f, add 0x37
	addb b,0x37
byte_doneadd0:
	ldb (xiy+),b
	ldb (xiy+),0
	;---second nybble---
	ldb b,a
	andb b,0xf ;isolate low nybble
	cpb b,0xa
	j nc,byte_atf1
	addb b,0x30 ;if nybble between 0 and 9, add 0x30
	j byte_doneadd1
byte_atf1: ;if nybble between a and f, add 0x37
	addb b,0x37
byte_doneadd1:
	ldb (xiy+),b
	ldb (xiy+),0
	ret

;-------------------------------------------------------
; print_word	
;-------------------------------------------------------
; xix: pointer to word to print
; wa: x pos
; bc: y pos
;-------------------------------------------------------
print_word:
	;calculate screen offset
	lda xiy,SCRL1_VRAM
	slaw 1,wa ;2 bytes per tile
	slaw 6,bc ;each column is 0x40 bytes
	addw iy,wa
	addw iy,bc
	;---first nybble---
	ldw wa,(xix)
	ldb b,w
	andb b,0xf0 ;isolate high nybble
	srlb 4,b
	cpb b,0xa
	j nc,word_atf0
	addb b,0x30 ;if nybble between 0 and 9, add 0x30
	j word_doneadd0
word_atf0: ;if nybble between a and f, add 0x37
	addb b,0x37
word_doneadd0:
	ldb (xiy+),b
	ldb (xiy+),0
	;---second nybble---
	ldb b,w
	andb b,0xf ;isolate low nybble
	cpb b,0xa
	j nc,word_atf1
	addb b,0x30 ;if nybble between 0 and 9, add 0x30
	j word_doneadd1
word_atf1: ;if nybble between a and f, add 0x37
	addb b,0x37
word_doneadd1:
	ldb (xiy+),b
	ldb (xiy+),0
	;---third nybble
	ldb a,(xix+)
	ldb b,a
	andb b,0xf0 ;isolate high nybble
	srlb 4,b
	cpb b,0xa
	j nc,word_atf2
	addb b,0x30 ;if nybble between 0 and 9, add 0x30
	j word_doneadd2
word_atf2: ;if nybble between a and f, add 0x37
	addb b,0x37
word_doneadd2:
	ldb (xiy+),b
	ldb (xiy+),0
	;---fourth nybble---
	ldb b,a
	andb b,0xf ;isolate low nybble
	cpb b,0xa
	j nc,word_atf3
	addb b,0x30 ;if nybble between 0 and 9, add 0x30
	j word_doneadd3
word_atf3: ;if nybble between a and f, add 0x37
	addb b,0x37
word_doneadd3:
	ldb (xiy+),b
	ldb (xiy+),0	
	ret	

;-------------------------------------------------------
	end
;-------------------------------------------------------