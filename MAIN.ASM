;*****************************************
;	Main Program 
;*****************************************
	$MAXIMUM
	module game_main

;  ---------------------------------
;	    EXTERNAL LOOK UP
;  ---------------------------------
	extern SYS_PATCH
	extern SYSTEM_CALL
	extern init_setting

;  ---------------------------------
;           EXTERNAL DEFINITION
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
	cal	init_setting ;VRAM, work initialization
	cal print_init ;load system font
	ei 0 ;allow interrupts with a priority >= 0
;-------------------------------------------------------
; main loop
;-------------------------------------------------------
main:
	cpb	(stopper),0 ;spin until vblank resets var
	j z,main

	cpb (User_Shutdown),0 ;turn off the system if we get a shutdown req
	j eq,main_100

	ldb	rw3,VECT_SHUTDOWN
	cal SYSTEM_CALL

main_100:
	ldw wa,3 ;x pos
	ldw bc,4 ;y pos
	lda xix,String	
	cal print_string
	
	ldw wa,0 ;x pos
	ldw bc,6 ;y pos
	lda xix,JoyStr	
	cal print_string
	
	ldw wa,8
	ldw bc,6
	lda xix,Sys_lever
	cal print_byte
	
	ldw wa,0 ;x pos
	ldw bc,7 ;y pos
	lda xix,FrameStr	
	cal print_string	
	
	incw 1,(frame_cnt)
	ldw wa,7
	ldw bc,7
	lda xix,frame_cnt
	cal print_word
	
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
	pushl	xix
	pushl	xiy
	pushl	xiz
	pushl	xwa
	pushl	xbc
	pushl	xde
	pushl	xhl
	pushw    sr
;	--------------------------------
	ldb	(WDCR),WD_CLR ;watch dog clear
	ldb	(stopper),0xff
;	--------------------------------
    popw     sr
	popl	xhl
	popl	xde
	popl	xbc
	popl	xwa
	popl	xiz
	popl	xiy
	popl	xix

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
