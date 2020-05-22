;*****************************************
;	Scroll functions 
;*****************************************
	$MAXIMUM
	module player

;  ---------------------------------
;	EXTERNAL LOOK UP
;  ---------------------------------
	; extern medium
	
;  ---------------------------------
;   EXTERNAL DEFINITION
;  ---------------------------------
	public player_init
	public player_move

;  ---------------------------------
;	INCLUDE
;  ---------------------------------
	$include "k1head.inc"
	$include "system.inc"
	$include "graphics.inc"
	$include "glbwork.inc"
	$include "scroll.inc"
	
SPRITE_X equ 72
SPRITE_Y equ 72

;-------------------------------------------------------
PROG section code large
;-------------------------------------------------------
	
;-------------------------------------------------------
; player_init: initialize player sprite
;-------------------------------------------------------	
player_init:
	ldw wa,0
	ldw qwa,SPRITE_X
	ldl (player_x),xwa
	
	ldw wa,0
	ldw qwa,SPRITE_Y
	ldl (player_y),xwa
	
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

	;upper left
	ldb a,160 ;tile number
	ldb (SPR_VRAM),a
	ldb a,0y00011000 ;attributes
	ldb (SPR_VRAM+1),a
	ldb a,SPRITE_X ;x position
	ldb (SPR_VRAM+2),a
	ldb a,SPRITE_Y
	ldb (SPR_VRAM+3),a ;y position
	ldb a,0 ;palette number
	ldb (SPR_PALCODE),a	
	;upper right
	ldb a,161
	ldb (SPR_VRAM+4),a
	ldb a,0y00011110 ;turn on h/v chain
	ldb (SPR_VRAM+5),a
	ldb a,8 ;offset 8 px from prev sprite on x axis
	ldb (SPR_VRAM+6),a
	ldb a,0
	ldb (SPR_VRAM+7),a
	ldb a,0
	ldb (SPR_PALCODE+1),a
	;lower left
	ldb a,162
	ldb (SPR_VRAM+8),a
	ldb a,0y00011110 ;turn on h/v chain
	ldb (SPR_VRAM+9),a
	ldb a,248 ;offset -8 px from prev sprite on x axis
	ldb (SPR_VRAM+10),a
	ldb a,8 ;offset 8 px on y axis
	ldb (SPR_VRAM+11),a
	ldb a,0
	ldb (SPR_PALCODE+2),a		
	;lower right
	ldb a,163
	ldb (SPR_VRAM+12),a
	ldb a,0y00011110 ;turn on h/v chain
	ldb (SPR_VRAM+13),a
	ldb a,8 ;offset 8 px from prev sprite on x axis
	ldb (SPR_VRAM+14),a
	ldb a,0 ;offset 0 px on y axis
	ldb (SPR_VRAM+15),a
	ldb a,0
	ldb (SPR_PALCODE+3),a
	ret
	
PLAYER_ACCEL equ 0x8000
MAX_SPEED equ 0x40000
;-------------------------------------------------------
; player_move: handle player movement
;-------------------------------------------------------
player_move:
	;---horizontal movement---
	ldb a,(Sys_lever)
	ldl xbc,(player_dx)
	bit BIT_LEFT,a
	j z,not_left
	cpl xbc,-MAX_SPEED
	j mi,not_left
	subl xbc,PLAYER_ACCEL
not_left:
	bit BIT_RIGHT,a
	j z,not_right
	cpl xbc,MAX_SPEED
	j pl,not_right
	addl xbc,PLAYER_ACCEL
not_right:
	;---if we're not pressing left or right, decelerate---
	ldb a,(Sys_lever)
	andb a,JOY_LEFT | JOY_RIGHT
	j nz,no_decel
	cpl xbc,0
	j z,no_decel ;if player_dx is 0, don't have to decelerate
	j pl,decel_right
	j mi,decel_left
decel_right:
	subl xbc,PLAYER_ACCEL
	;if value goes under 0, make it 0
	cpl xbc,0
	j pl,no_decel
	ldl xbc,0
	j no_decel
decel_left:
	addl xbc,PLAYER_ACCEL
	;if value goes over 0, make it 0
	cpl xbc,0
	j mi,no_decel
	ldl xbc,0
no_decel:	
	ldl xwa,(player_x)
	ldl (player_dx),xbc
	addl xwa,xbc
	ldl (player_x),xwa	
	
	ldw wa,(player_x+2) ;move pixel portion of x coord into wa
	subw wa,SPRITE_X
	ldw bc,(player_y+2)
	subw bc,SPRITE_Y
	cal scroll_set
	ret
	
	
;-------------------------------------------------------
	end
;-------------------------------------------------------