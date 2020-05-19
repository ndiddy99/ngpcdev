;*****************************************
;	Main Program 
;*****************************************
	$MAXIMUM
	module game_main

;  ---------------------------------
;	EXTERNAL LOOK UP
;  ---------------------------------
	extern SYS_PATCH
	extern SYSTEM_CALL
	extern init_setting

;  ---------------------------------
;   EXTERNAL DEFINITION
;  ---------------------------------
	public reset,v_int,h_int,dummy,timer1,timer2
	public alarm_int,z80_int,sound_int

;  ---------------------------------
;	INCLUDE
;  ---------------------------------
	$include "system.inc"
	$include "k1head.inc"
	$include "glbwork.inc"
	$include "game.inc"
	$include "print.inc"
	$include "graphics.inc"
	$include "scroll.inc"


;-------------------------------------------------------
PROG section code large
;-------------------------------------------------------

		public	__STARTUP
__STARTUP	equ	0xff1800
;-------------------------------------------------------
; entry point			
;-------------------------------------------------------
reset:
	cal	SYS_PATCH ;called during init to assist with power functionality

;------------------- INITIALIZATION --------------------
	cal init_setting ;VRAM, work initialization
	; cal print_init ;load system font
	ei 0 ;allow interrupts with a priority >= 0

	;---copy palette---
	lda xiy,palette
	lda xix,SCROLL1_CRAM
	ldl xbc,palette_end-palette ;should be a ldw but needs to be an ldl
palette_copy:                   ;to appease the assembler
	ldw wa,(xiy+)
	ldw (xix+),wa
	djnz bc,palette_copy	
	;---clear scroll plane 2 palette---
	ldw wa,0
	lda xix,SCROLL2_CRAM
	ldw bc,4*16
palette2_copy:
	ldw (xix+),wa
	djnz bc,palette2_copy

	; ;---set bg color---	
	ldw wa,0xf85
	ldw (0x83e0),wa
	ldb a,0x80 ;bg color on, first color in cram
	ldb (0x8118),a	
	
	;---copy tiles---
	
	lda xiy,tiles
	lda xix,CHR_VRAM
	ldl xbc,tiles_end-tiles
	ldir (xix+),(xiy+)
	
	;---copy map---
	
	lda xix,SCRL1_VRAM
	lda xiy,map
	ldb d,19 ;19 rows
map_copy:	
	ldw bc,40 ;40 bytes per row (20 columns * 2 bytes per tile)
copy_row:
	ldir (xix+),(xiy+)
	addw ix,64-40
	addw iy,128-40
	djnz d,map_copy
	;---copy guy sprite---
	lda xiy,guy
	lda xix,CHR_VRAM+tiles_end-tiles
	ldl xbc,guy_end-guy
	ldir (xix+),(xiy+)
	;---copy guy palette---
	lda xiy,guy_pal
	lda xix,SPRITE_CRAM
	ldl xbc,guy_pal_end-guy_pal ;should be a ldw but needs to be an ldl
guy_pal_copy:                   ;to appease the assembler
	ldw wa,(xiy+)
	ldw (xix+),wa
	djnz bc,guy_pal_copy	
	
	ldb a,200
	ldb (0x8800),a
	ldb a,0y00011000
	ldb (0x8801),a
	ldb a,40
	ldb (0x8802),a
	ldb (0x8803),a
	ldb a,0
	ldb (0x8c00),a	
	
	ldb a,201
	ldb (0x8804),a
	ldb a,0y00011110 ;turn on h/v chain
	ldb (0x8805),a
	ldb a,8 ;offset 8 px from prev sprite on x axis
	ldb (0x8806),a
	ldb a,0
	ldb (0x8807),a
	ldb a,0
	ldb (0x8c01),a
	
	ldb a,202
	ldb (0x8808),a
	ldb a,0y00011110 ;turn on h/v chain
	ldb (0x8809),a
	ldb a,248 ;offset -8 px from prev sprite on x axis
	ldb (0x880a),a
	ldb a,8 ;offset 8 px on y axis
	ldb (0x880b),a
	ldb a,0
	ldb (0x8c02),a		
	
	
	ldb a,203
	ldb (0x880c),a
	ldb a,0y00011110 ;turn on h/v chain
	ldb (0x880d),a
	ldb a,8 ;offset 8 px from prev sprite on x axis
	ldb (0x880e),a
	ldb a,0 ;offset 0 px on y axis
	ldb (0x880f),a
	ldb a,0
	ldb (0x8c03),a		
	
	
;-------------------------------------------------------
; main loop
;-------------------------------------------------------
main:
	cpb (stopper),0 ;spin until vblank resets var
	j z,main

	cpb (User_Shutdown),0 ;turn off the system if we get a shutdown req
	j eq,main_100

	ldb rw3,VECT_SHUTDOWN
	cal SYSTEM_CALL

main_100:
	
	bit BIT_UP,(Sys_lever)
	j z,not_up
	subw (screen_y),1
not_up:
	bit BIT_DOWN,(Sys_lever)
	j z,not_down
	addw (screen_y),1
not_down:
	bit BIT_LEFT,(Sys_lever)
	j z,not_left
	subw (screen_x),1
not_left:
	bit BIT_RIGHT,(Sys_lever)
	j z,not_right
	addw (screen_x),1
not_right:

	ldw wa,(screen_x)
	ldw bc,(screen_y)
	cal scroll_set
	
	
	ldb (stopper),0
	j main
	
String:
	db "hello world",0
	align 2
JoyStr:
	db "joypad: xx",0
	align 2
FrameStr:
	db "frame: xxxx",0
	align 2
	
;-------------------------------------------------------
; v-blank interrupt
;-------------------------------------------------------
v_int:
	pushl xix
	pushl xiy
	pushl xiz
	pushl xwa
	pushl xbc
	pushl xde
	pushl xhl
	pushw sr
;	--------------------------------
	ldb	(WDCR),WD_CLR ;watch dog clear
	ldb	(stopper),0xff
	cal scroll_copy
;	--------------------------------
    popw sr
	popl xhl
	popl xde
	popl xbc
	popl xwa
	popl xiz
	popl xiy
	popl xix

	reti

;-------------------------------------------------------
; other interrupts
;-------------------------------------------------------
h_int:
	reti

timer1:
	reti

timer2:
	reti

alarm_int:
	reti

z80_int:
	reti

sound_int:
	reti

dummy:
	reti

;-------------------------------------------------------
	end
;-------------------------------------------------------
