;=======================================================

;		SYSTEM RELATED EQU

;=======================================================

DISP_CTL0		EQU	0x08000			;interrupt control register

;D7 : 1 = Vint allowed / 0 = not allowed

;D6 : 1 = Hint allowed / 0 = not allowed



STS_RG_ADD		EQU	0x08010			;2D status register (READ)

;D7 : 1 = character over / 0 = no character over

;D6 : 1 = while V blanking / 0 = while in display mode



LCD_CTR_ADD		EQU	0x08012			;2D control register

;D7 : 1 = screen color inverse display / 0 = normal display

;D2Å`D0 : outside window frame color CODE



BG_COLOR		EQU 0x08118			;Background color register

;D7`D6: BGON. D7 = 1, D6 = 0: Use specified BG color. Defaults to D7/D6 both 0

;D2`D0: BG color code




RESET_ADD		EQU	0X087E0			;2D software reset (WRITE)

;2D cicuit initialization with "52" write



VERSION_ADD		EQU	0x087FE			;2D cicuit version (READ)

;D7 : 1 = white LCD panel /0 = balck LCD panel 

;D5Å`D0 : 2D circuit version





;=======================================================

;		CHARACTER EQU

;=======================================================

CHR_VRAM		EQU	0x0A000			;character data RAM address





;=======================================================

;		SCROLL EQU

;=======================================================

SCRL1_VRAM		EQU	0x09000

SCRL2_VRAM		EQU	0x09800



SCRL_PRIO_ADR		EQU	0X08030			;scroll priority level invert register 

SCRL_X1_ADR		EQU	0x08032			;scroll 1 offset H register

SCRL_Y1_ADR		EQU	0x08033			;scroll 1 offset V register

SCRL_X2_ADR		EQU	0x08034			;scroll 2 offset H register

SCRL_Y2_ADR		EQU	0x08035			;scroll 2 offset V register



;=======================================================

;		SPRITE EQU

;=======================================================

SPR_VRAM		EQU	0x08800

SPR_OFFSET_X_ADR	EQU	0x08020			;sprite offset H

SPR_OFFSET_Y_ADR	EQU	0x08021			;sprite offset V

SPR_PALCODE EQU 0x8C00 ;what palette # to use for each sprite 




;=======================================================

;		WINDOW SYSTEM EQU

;=======================================================

WIN_WBAX_ADR		EQU	0x08002			;window origin H

WIN_WBAY_ADR		EQU	0x08003			;window origin V

WIN_WSIX_ADR		EQU	0x08004			;window size H

WIN_WSIY_ADR		EQU	0x08005			;window size V



WD_LCDST_HPOS		EQU	0x08008			;raster H position register (READ)

WD_LCDST_VPOS		EQU	0x08009			;raster V position register (READ)



;=======================================================

;		PALETTE EQU

;=======================================================

;sprite palette 0

PL_SPR_00		EQU	0x08101	

PL_SPR_01		EQU	0x08102

PL_SPR_02		EQU	0x08103

;sprite palette 1

PL_SPR_10		EQU	0x08105

PL_SPR_11		EQU	0x08106

PL_SPR_12		EQU	0x08107



;scroll 0 palette 0

PL_SCR0_00		EQU	0x08109

PL_SCR0_01		EQU	0x0810A

PL_SCR0_02		EQU	0x0810B

;scroll 0 palette 1

PL_SCR0_10		EQU	0x0810D

PL_SCR0_11		EQU	0x0810E

PL_SCR0_12		EQU	0x0810F

;scroll 1 palette 0

PAL_SCR1_00		EQU	0x08111

PAL_SCR1_01		EQU	0x08112

PAL_SCR1_02		EQU	0x08113

;scroll 1 palette 1

PAL_SCR1_10		EQU	0x08115

PAL_SCR1_11		EQU	0x08116

PAL_SCR1_12		EQU	0x08117


;=======================================================

;		COLOR PALETTE RAM EQU

;=======================================================

SPRITE_CRAM		EQU 0x08200

SCROLL1_CRAM	EQU 0x08280

SCROLL2_CRAM	EQU 0x08300

BGCOL_CRAM		EQU 0x083E0 ;for the background color

WINDOW_CRAM		EQU 0x083F0


;=======================================================



