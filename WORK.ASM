;*****************************************
;		WORK DEFINITION 
;*****************************************
	$MAXIMUM					;
	module  game_work			;
;  ---------------------------------
;  ---------------------------------
;		EXTERNAL LOOKUP
;  ---------------------------------


;  ---------------------------------
;		EXTERNAL DEFINTION
;  ---------------------------------
	public start_work
	public stopper	
	public frame_cnt
	public screen_x
	public screen_y
	public scroll_x
	public scroll_y
	public scroll_mode
;  ---------------------------------
;		INCLUDE
;  ---------------------------------


;-------------------------------------------------------
WORK	section data medium				;
;-------------------------------------------------------
start_work:
;-------------- WORK -----------------
stopper	dsb	1				;
	align   2
frame_cnt dsb 2
screen_x dsb 2
screen_y dsb 2
;---scroll.asm---
	align   2
scroll_x dsb 2
scroll_y dsb 2
scroll_mode dsb 1
	
	
;-------------------------------------------------------
        end						;
;-------------------------------------------------------
