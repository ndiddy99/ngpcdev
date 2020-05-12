;*****************************************
;		GAME VECTOR
;*****************************************
$MAXIMUM
        module  game_vect		;

;  ---------------------------------
;		EXTERNAL LOOKUP
;  ---------------------------------
	extern	reset,v_int,h_int,dummy,timer1,timer2
	extern	alarm_int,z80_int,sound_int

;  ---------------------------------
;		EXTERNAL DEFINITION
;  ---------------------------------
	public	RAM_Vector
	public	Header_Data

;  ---------------------------------
;		INCLUDE
;  ---------------------------------


;-----------------------------------------
;		VECTOR TABLE
;-----------------------------------------
INT_TBL	section romdata large		;vector

Header_Data:
	db	" LICENSED BY SNK CORPORATION"	;recognition code
	dl	reset					;startup address
	dw	0x0000					;GAME ID Code
	db	0x02					;GAME Version
	db	0x10					;0x10 = Color, 0x00 = Monochrome
	db	"TEST GAME 2 "			;GAME NAME 12 Byte
	dl	0x00,0x00,0x00,0x00			;Dummy 16 Byte


RAM_Vector:
	dl	dummy					;00 0xffff14 SWI3
	dl	dummy					;01 0xffff18 SWI4
	dl	dummy					;02 0xffff14 SWI5
	dl	dummy					;03 0xffff18 SWI6
	dl	alarm_int				;04 RTC alarm
	dl	v_int					;05 V-interrupt
	dl	z80_int				;06 Z80 sound source control CPU request
	dl	h_int					;07 INT T0
	dl	timer1					;08 INT T1
	dl	timer2					;09 INT T2
	dl	sound_int				;10 INT T3 (interrupt to Z80)
	dl	dummy					;11 serial reception
	dl	dummy					;12 serial communication
	dl	dummy					;13 reserved
	dl	dummy					;14 end micro DMA Channel 0
	dl	dummy					;15 
	dl	dummy					;16 
	dl	dummy					;17 


;-----------------------------------------------
        end					;
;-----------------------------------------------