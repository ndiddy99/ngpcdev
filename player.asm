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
	public get_sensor

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
PLAYER_WIDTH equ 16
PLAYER_HEIGHT equ 16
PLAYER_ACCEL equ 0x8000
MAX_SPEED equ 0x38000

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
	;---collision detection---
	;left foot
	ldw wa,(player_x+2)
	ldw bc,(player_y+2)
	addw bc,PLAYER_HEIGHT
	cal get_sensor
	pushb a
	; ;right foot
	ldw wa,(player_x+2)
	addw wa,PLAYER_WIDTH
	ldw bc,(player_y+2)
	addw bc,PLAYER_HEIGHT
	cal get_sensor ;right sensor height in a
	popb b ;left sensor height in b
	cpb b,a
	j mi,left_higher
	ldb a,b
left_higher:
	ldw bc,(player_y+2)
	addw bc,PLAYER_HEIGHT ;foot pos in bc
	andw bc,0xfff0 ;place feet at bottom of block
	addw bc,16
	extsw wa
	subw bc,wa
	subw bc,PLAYER_HEIGHT ;foot pos to regular pos
	ldw (player_y+2),bc
	
	ldw wa,(player_x+2) ;move pixel portion of x coord into wa
	subw wa,SPRITE_X
	ldw bc,(player_y+2)
	subw bc,SPRITE_Y
	cal scroll_set
	ret

;-------------------------------------------------------
; get_sensor: returns # of pixels needed to change height by
;-------------------------------------------------------
; wa: pixel x
; bc: pixel y
;-------------------------------------------------------
get_sensor:
	ldw qde,wa ;stash original values
	ldw qhl,bc
	cal get_height
	andb a,a
	j z,check_below ;if height is 0, check below block
	cpb a,16
	j z,check_above ;if height is 16, check above block
	j get_sensor_end ;otherwise just return
check_below:
	ldw wa,qde
	ldw bc,qhl
	addw bc,16 ;below tile
	cal get_height
	subb a,16 ;have to subtract 16 to counter the 16 we added
	j get_sensor_end
check_above:
	ldw wa,qde
	ldw bc,qhl
	subw bc,16 ;above tile
	cal get_height
	addb a,16 ;have to add 16 to counter the 16 we subtracted

get_sensor_end:
	ret

;-------------------------------------------------------
; get_height: returns height of given pixel in a
;-------------------------------------------------------
; wa: pixel x
; bc: pixel y
;-------------------------------------------------------	
get_height:
	ldb d,a
	andb d,0xf ;d has x position within tile
	cal scroll_get_tile
	ldw hl,wa
	andw hl,0x8000 ;isolate horizontal mirror bit
	j z,no_mirror
	ldb e,d ;if tile is mirrored, array index = 15 - array index
	ldb d,15
	subb d,e
no_mirror:
	;my bg tile image is 128 pixels wide so taking off that bit and shiftng
	;left 1 allows me to convert from 8x8 to 16x16
	andw wa,0x1ef
	srlw 1,wa
	lda xbc,block_types
	addw bc,wa
	ldl xwa,0
	ldb a,(xbc)
	slaw 4,wa ;each array entry is 16 bits
	addb a,d
	lda xbc,block_arrs
	addl xbc,xwa
	ldb a,(xbc)
	ret
	
;TODO refactor into separate source
block_arrs:
;empty block
TYPE_EMPTY equ 0
HeightEmpty:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
;full block
TYPE_FULL equ 1
HeightFull:
	db 16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16
	
;45 degree
TYPE_45 equ 2
Height45:
	db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
	
;22.5 degree part 1
TYPE_2251 equ 3
Height2251:
	db 0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7
	
;22.5 degree part 2
TYPE_2252 equ 4
Height2252:
	db 8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15
	
;what angle each 16x16 block is
block_types:
	db TYPE_EMPTY,TYPE_FULL,TYPE_45,TYPE_2251,TYPE_2252,TYPE_FULL,TYPE_FULL,TYPE_FULL
	db TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL
	db TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL
	db TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL,TYPE_FULL
	
;-------------------------------------------------------
	end
;-------------------------------------------------------