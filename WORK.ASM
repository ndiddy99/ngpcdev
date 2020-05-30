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
	public joypad
	public joylast
	public joyedge
	public frame_cnt
	public screen_x
	public screen_y
	public scroll_x
	public scroll_y
	public scroll_mode
	public player_x
	public player_y
	public player_dx
	public player_dy
	public player_mode
;  ---------------------------------
;		INCLUDE
;  ---------------------------------


;-------------------------------------------------------
WORK	section data medium				;
;-------------------------------------------------------
start_work:
;-------------- WORK -----------------
stopper	dsb	1
joypad dsb 1
joylast dsb 1
joyedge dsb 1
	align   2
frame_cnt dsb 2
screen_x dsb 2
screen_y dsb 2
;---scroll.asm---
	align   2
scroll_x dsb 2
scroll_y dsb 2
scroll_mode dsb 1
;---player.asm---
	align 2
player_x dsb 4
player_y dsb 4
player_dx dsb 4
player_dy dsb 4
player_mode dsb 1
	
	
;-------------------------------------------------------
        end						;
;-------------------------------------------------------
