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
	$include "player.inc"


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
	;---copy hill palette to bg 2---
	lda xiy,hills_pal
	lda xix,SCROLL2_CRAM
	ldl xbc,hills_pal_end-hills_pal
palette_copy2:
	ldw wa,(xiy+)
	ldw (xix+),wa
	djnz bc,palette_copy2

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
	
	lda xiy,hills
	lda xix,CHR_VRAM+0xA00
	ldl xbc,hills_end-hills
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
	
	lda xiy,hills_map
	lda xix,SCRL2_VRAM
	ldl xbc,32*32
map2_loop: ;have to add 160 to each tile because 160 tiles in the foreground
	ldw wa,(xiy+)
	addw wa,160
	ldw (xix+),wa
	djnz bc,map2_loop
	cal player_init
	
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
	cal player_move
	
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
	;set up joypad variables
	ldb a,(joypad)
	ldb (joylast),a
	ldb w,(Sys_lever)
	ldb (joypad),w
	xorb a,0xff ;flip the bits
	andb a,w ;check if there's any overlap between what was pressed this frame
	ldb (joyedge),a ;and what wasn't pressed last frame
	
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
