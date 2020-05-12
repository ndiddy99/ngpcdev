;*****************************************
;	SAMPLE PROGRAM (INITIALIZATION)
;*****************************************
$MAXIMUM						;
	module  init					;

;  ---------------------------------
;	EXTERNAL LOOKUP
;  ---------------------------------
	extern	RAM_Vector

;  ---------------------------------
;   EXTERNAL DEFIINITION
;  ---------------------------------
	public  init_setting     			;

;  ---------------------------------
;	INCLUDE
;  ---------------------------------
	$include	"system.inc"
	$include	"k1head.inc"
	$include	"glbwork.inc"
	$include	"game.inc"
	
;-------------------------------------------------------
PROG	section code large				;
;-------------------------------------------------------
;-------------------------------------------------------
;		INITIALIZATION
;-------------------------------------------------------
init_setting:
;  ---- SHUTDOWN ON DUE TO NO USE ---- 
	setb	TIMER_SHUTDOWN_ANS,(User_Answer)

;  ---- VECTOR DEFINITION ----
	lda	xix,RAM_Vector
	lda	xiy,0x06fb8				;vector start address
	ldb	b,18
vect_copy:
	ldl	xwa,(xix+)
	ldl	(xiy+),xwa
	djnz	b,vect_copy

;  ---- INITIALIZATION OF VRAM ----
	calr	sprite_clr
	calr	scroll_clr
	calr	plaet_seting

	ldl	xwa,0

;  ---- I/O INITIALIZATION ----
;sprites
	ldb	(SPR_OFFSET_X_ADR),a			;
	ldb	(SPR_OFFSET_Y_ADR),a			;
;scroll plane
	ldb	(SCRL_X1_ADR),a			;
	ldb	(SCRL_Y1_ADR),a			;
	ldb	(SCRL_X2_ADR),a			;
	ldb	(SCRL_Y2_ADR),a			;
	ldb	(SCRL_PRIO_ADR),a			;
;window
	ldb	(WIN_WBAX_ADR),a			;
	ldb	(WIN_WBAY_ADR),a			;
	ldb	(WIN_WSIX_ADR),disp_size_x		;screen horizontal size
	ldb	(WIN_WSIY_ADR),disp_size_y		;screen vertical size

;  ---- WORK INITIALIZATION ----
	ldw     bc,0x2000/4/4			;all work area
	ldl	xix,start_work			;
	
work_init_loop:
	ldl	(xix+),xwa				;
	ldl	(xix+),xwa				;
	ldl	(xix+),xwa				;
	ldl	(xix+),xwa				;
	djnz    bc,work_init_loop			;

	ret
;-------------------------------------------------------

;-------------------------------------------------------
;		SPRITE RAM CLEAR
;-------------------------------------------------------
sprite_clr:
	ldw	wa,0
	ldw     bc,obj_max				;display VRAM and display work clear
	ldl	xix,SPR_VRAM

sprite_loop:
	ldw	(xix+),wa
	ldw	(xix+),wa
	djnz    bc,sprite_loop

	ret
;-------------------------------------------------------
;-------------------------------------------------------
; 		SCROLL RAM CLEAR
;-------------------------------------------------------
scroll_clr:
	ldw     bc,1024				;display RAM and display work clear
	ldl	xix,SCRL1_VRAM

scroll_loop:
	ldw	(xix+),0x0020
	ldw	(xix+),0x0020
	djnz    bc,scroll_loop

	ret
;-------------------------------------------------------
;-------------------------------------------------------
;		PALETTE DEIFINITION	
;-------------------------------------------------------
plaet_seting:
	ldal	xix,PL_SPR_00
	ldal	xiy,pal_data
	ldw	bc,0x0603				;sprite palette 2 + scroll palette 4

palet_loop:
	ldb	a,(xiy+)
	ldb	(xix+),a
	djnz    c,palet_loop

	ldb     c,3
	incl	1,xix
	djnz    b,palet_loop
	ret
;-------------------------------------------------------
;=======================================================
;		PALETTE DATA
;=======================================================
pal_data:
	db	0x00,0x00,0x07				;sprite palette 0
	db	0x00,0x00,0x07				;sprite palette 1

	db	0x01,0x02,0x03				;scroll 0 palette 0
	db	0x01,0x02,0x03				;scroll 0 palette 1
	db	0x01,0x02,0x03				;scroll 1 palette 0
	db	0x01,0x02,0x03				;scroll 1 palette 1
	align   2	
;=======================================================
;-------------------------------------------------------
	end
;-------------------------------------------------------
