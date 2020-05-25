;*****************************************
;	Scroll functions 
;*****************************************
	$MAXIMUM
	module scroll

;  ---------------------------------
;	EXTERNAL LOOK UP
;  ---------------------------------
	extern medium scroll_x,scroll_y,scroll_mode
	
;  ---------------------------------
;   EXTERNAL DEFINITION
;  ---------------------------------
	public scroll_set
	public scroll_get_tile
	public scroll_copy

;  ---------------------------------
;	INCLUDE
;  ---------------------------------
	$include "k1head.inc"
	$include "system.inc"
	$include "graphics.inc"
	
TILES_X equ 20
TILES_Y equ 19
COPY_LEFT equ 1
COPY_RIGHT equ 2
COPY_UP equ 4
COPY_DOWN equ 8

;-------------------------------------------------------
PROG section code large
;-------------------------------------------------------
	
;-------------------------------------------------------
; scroll_set: set scroll to specified coords
;-------------------------------------------------------
; wa: x pos
; bc: y pos
;-------------------------------------------------------
scroll_set:
	cpw wa,(scroll_x)
	j z,no_x
	j p,right_x
	
left_x: ;if scrolling to the left
	ldb d,COPY_LEFT
	j done_x	
right_x: ;if scrolling to the right
	ldb d,COPY_RIGHT
	j done_x
no_x: ;if values are the same
	ldb d,0
done_x:
	ldw (scroll_x),wa
	
	cpw bc,(scroll_y)
	j z,done_y
	j p,down_y

up_y: ;if scrolling up
	orb d,COPY_UP
	j done_y
down_y: ;if scrolling down
	orb d,COPY_DOWN
	j done_y
done_y: ;if values are the same
	ldb (scroll_mode),d
	ldw (scroll_y),bc
	ret


;-------------------------------------------------------
; scroll_get_tile: returns tile # at given coordinates in wa
;-------------------------------------------------------
; wa: x pos
; bc: y pos
;-------------------------------------------------------
scroll_get_tile:
	srlw 3,wa ;change pixels to 8x8 tiles
	srlw 3,bc
	slaw 6,bc ;64 tiles per row
	addw bc,wa
	slaw 1,bc ;bytes->words
	ldw qbc,0
	addl xbc,map
	ldw wa,(xbc)
	; andw wa,0x1ff ;tile number is low 9 bits of map word
	ret
	
	
;-------------------------------------------------------
; scroll_copy: carry out scroll changes made in scroll_set (run during vblank)
;-------------------------------------------------------	
scroll_copy:
	ldb a,(scroll_x)
	ldb c,(scroll_y)
	ldb (SCRL_X1_ADR),a
	ldb (SCRL_Y1_ADR),c
	
	ldb a,(scroll_mode)
	andb a,COPY_LEFT
	j z,no_left
	;scrolling left
	ldw qwa,0
	ldw wa,(scroll_x)
	srll 3,xwa ;divide by 8 to change pixels to 8x8 tiles
	decl 1,xwa ;start copying 1 tile before the screen
	ldw qbc,0
	ldw bc,(scroll_y)
	srll 3,xbc
	decl 1,xbc ;start copying 1 tile higher than the screen
	cal copy_column
	
no_left:
	ldb a,(scroll_mode)
	andb a,COPY_RIGHT
	j z,no_right
	;scrolling right
	ldw qwa,0
	ldw wa,(scroll_x)
	srll 3,xwa ;divide by 8 to change pixels to 8x8 tiles
	addl xwa,TILES_X ;start copying 1 tile after the screen
	ldw qbc,0
	ldw bc,(scroll_y)
	srll 3,xbc
	decl 1,xbc ;start copying 1 tile higher than the screen
	cal copy_column
	
no_right:
	ldb a,(scroll_mode)
	andb a,COPY_UP
	j z,no_up
	;scrolling up
	ldw qwa,0
	ldw wa,(scroll_x)
	srll 3,xwa ;divide by 8 to change pixels to 8x8 tiles
	decl 1,xwa ;start copying 1 tile before the screen
	ldw qbc,0
	ldw bc,(scroll_y)
	srll 3,xbc
	decl 1,xbc ;start copying 1 tile higher than the screen
	cal copy_row
	
no_up:
	ldb a,(scroll_mode)
	andb a,COPY_DOWN
	j z,no_down
	;scrolling down
	ldw qwa,0
	ldw wa,(scroll_x)
	srll 3,xwa ;divide by 8 to change pixels to 8x8 tiles
	decl 1,xwa ;start copying 1 tile before the screen
	ldw qbc,0
	ldw bc,(scroll_y)
	srll 3,xbc
	addl xbc,TILES_Y ;start copying 1 tile lower than the screen
	cal copy_row	
no_down:
	ret
	
;-------------------------------------------------------
; copy_column: copy a column of scroll data into vram
;-------------------------------------------------------
; xwa: tile x
; xbc: tile y
;-------------------------------------------------------	
copy_column:
;get source address
	ldl xde,xwa
	slal 1,xde ;tile # to word #
	ldl xiy,xbc
	slal 7,xiy ;tile # * 128 bytes per row
	addl xiy,xde ;source offset now in xiy
	lda xde,map
;get destination address
	andl xwa,0x1f ;virtual screen is 32x32 tiles
	slal 1,xwa
	andl xbc,0x1f
	ldl xix,xbc
	slal 6,xix ;tile # * 64 bytes per row
	addl xix,xwa
	addl xix,SCRL1_VRAM
	
	ldb a,TILES_Y+2 ;want to go from 1 tile before the screen to 1 tile after
copy_col_loop:
	andl xiy,0x1fff ;keep source offset within tilemap (64*64*2)
	andl xix,0x97ff ;keep destination within scroll 1 vram	
	ldl xde,xiy
	addl xde,map ;get absolute source address
	ldw bc,(xde)
	ldw (xix),bc
	addl xiy,128 ;map is 64x64, so 128 bytes per row	
	addl xix,64 ;vram is 32x32, so 64 bytes per row
	djnz a,copy_col_loop
	ret

;-------------------------------------------------------
; copy_row: copy a row of scroll data into vram
;-------------------------------------------------------
; xwa: tile x
; xbc: tile y
;-------------------------------------------------------	
copy_row:	
;get source address
	ldl xde,xwa
	slal 1,xde ;tile # to word #
	ldl xiy,xbc
	slal 7,xiy ;tile # * 128 bytes per row
	addl xiy,xde
	addl xiy,map ;source address in xiy
;get destination address
	andb a,0x1f ;virtual screen is 32x32 tiles
	slab 1,a ;row offset in a
	andl xbc,0x1f
	ldl xix,xbc
	slal 6,xix ;tile # * 64 bytes per row
	addl xix,SCRL1_VRAM ;destination address in xix

	ldb l,TILES_X+2 ;1 tile before the screen to 1 tile after
copy_row_loop:
	andb a,0x3f ;keep offset within 1 row of scroll 1 vram
	andl xix,0x97ff ;keep destination within scroll 1 vram
	ldw bc,(xiy+)
	ldw (xix+a),bc
	addb a,2
	djnz l,copy_row_loop
	ret
	


	
;-------------------------------------------------------
	end
;-------------------------------------------------------
