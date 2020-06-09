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
	$include "tlcs900.inc"
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
	incw 1,(frame_cnt)
	ldb (hint_cnt),0 ;reset number of times horizontal interrupt was called
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
	
	;keep scroll 2 from scrolling off screen
	ldw wa,(scroll_y)
	srlw 1,wa
	cpb a,102
	j c,normal_scroll
	ldb a,102
normal_scroll:	
	ldb (SCRL_Y2_ADR),a
	
	;set up bank 2 registers for horizontal interrupt
	ldw bc,(scroll_x)
	ldb d,c
	srlw 1,bc
	ldb rc2,c ;x / 2
	srlw 1,bc
	ldb rb2,c ;x / 4
	srlw 1,bc
	ldb ra2,c ;x / 8
	ldb e,c
	; the 3 "split points" are at 88, 128, and 168.
	ldb w,0
	
	ldw hl,88
	subw hl,wa
	cpw hl,5
	j mi,low_vals
	j normal_vals
low_vals:
	ldb l,128
	subb l,a
	ldb (SCRL_X2_ADR),e
	ldb rw2,1
	ldb re2,40
	j done_vals
normal_vals:
	ldb a,(frame_cnt)
	ldb (SCRL_X2_ADR),a
	ldb rw2,0
	ldb rd2,40
	ldb re2,40
done_vals:
	
	;enable horizontal interrupt
set_int:
	di
	andb (TRUN),0xfe ;disable timer 0
	andb (TMOD),0xfc ;timer 0: external clock (hblank)
	ldb (TREG0),l ;what line to trigger interrupt on
	ldb rw3,VECT_INTLVSET ;enable interrupt through bios call
	ldb rb3,3
	ldb rc3,2
	swi 1 ;go to bios call
	orb (TRUN),0x1 ;enable timer 0
	ei 0
	j done_int
no_int:
	di
	andb (TRUN),0xfe ;disable timer 0
	ei 0
	
done_int:	
	
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
; horizontal interrupt happens so quickly that we don't want to bother
; touching ram, so instead we use register bank 2
;
; seams for hill bg are at 88, 128, and 168
;-------------------------------------------------------
; register map:
; w: counts how many times horizontal interrupt has been called
; a: x position for first zone (furthest back hill)
; b: x position for second zone (middle hill)
; c: x position for third zone (closest hill)
; d: y position for second split
; e: y position for third split
;-------------------------------------------------------
h_int:
	ldf 2 ;load register bank 2
	ldb h,(WD_LCDST_HPOS)
	cpb h,152 ;don't mess with scroll if in vblank
	j nc,done_h_int
	cpb w,1
	j c,first
	j eq,second
third:
	ldb (SCRL_X2_ADR),c
	di
	andb (TRUN),0xfe ;disable timer 0
	ei 0
	ldf 0
	reti
second:
	ldb (SCRL_X2_ADR),b
	ldb w,2
	di
	andb (TRUN),0xfe ;disable timer 0
	ldb (TREG0),e ;scanline to fire next horizontal interrupt
	orb (TRUN),0x1 ;enable timer 0
	ei 0
	ldf 0
	reti
first:
	ldb (SCRL_X2_ADR),a
	ldb w,1
	di
	andb (TRUN),0xfe ;disable timer 0
	ldb (TREG0),d ;scanline to fire next horizontal interrupt
	orb (TRUN),0x1 ;enable timer 0
	ei 0
done_h_int:	
	ldf 0
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
