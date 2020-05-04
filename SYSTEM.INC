;-----------------------------------------------------------------

;	SYSTEM CALL

;-----------------------------------------------------------------

SYS_SUCCESS		equ	0x00			;run success

SYS_FAILURE		equ	0xff			;run failure

;-----------------------------------------------------------------

VECT_SHUTDOWN		equ	0x00			;shutdown (power OFF)

VECT_CLOCKGEARSET	equ	0x01			;clock gear change

VECT_RTCGET		equ	0x02			;obtain time

VECT_INTLVSET		equ	0x04			;set interrupt level

VECT_SYSFONTSET	equ	0x05			;set system font

VECT_FLASHWRITE	equ	0x06			;flash memory data write

VECT_FLASHALLERS	equ	0x07			;flash memory erase all blocks

VECT_FLASHERS		equ	0x08			;flash memory erase specified blocks

VECT_ALARMSET		equ	0x09			;game alarm setting

VECT_ALARMDOWNSET	equ	0x0b			;alarm setting during shutdown

VECT_FLASHPROTECT	equ	0x0d			;protect using tool

VECT_GEMODESET	equ	0x0e			;switching GE mode

;-----------------------------------------------------------------

;	SYSTEM BIT EQU

;-----------------------------------------------------------------

INT_CLR_BIT		equ	0x07			;interrupt request clear bit

_INT_CLR_BIT		equ	0y10000000		;

;-----------------------------------------------------------------

;	SYSTEM WORK

;-----------------------------------------------------------------

Battery_Voltage	equ	0x6f80			;estimated voltage

Sys_lever		equ	0x6f82			;lever value

Language		equ	0x6f87			;language chosen

User_Shutdown		equ	0x6f85			;shutdown re1uest bit

User_Boot		equ	0x6f84			;startup bit flag

User_Answer		equ	0x6f86			;user request bit

OS_Version		equ	0x6f91			;system version reserve work

;-----------------------------------------------------------------

;	WATCH DOG

;-----------------------------------------------------------------

WDCR			equ	0x06F		;watch dog control address

WD_CLR			equ	0x04e		;watch dog clear code

;-----------------------------------------------------------------

;	SYSTEM WORK BIT

;-----------------------------------------------------------------

;======================================================= 

;	USER START UP BIT

;======================================================= 

;User_Boot

;	00000000

;	||+------ resume startup			0:not resume startup		1:resume startup

;	|+------- POWER startup			0:not POWER startup		1:POWER startup

;	+-------- alarm startup			0:not alarm statup		1:alarm statup

;	=================================================



ALARM_BOOT_REQ		equ	0x07

POWER_BOOT_REQ		equ	0x06

RESUME_BOOT_REQ		equ	0x05

_ALARM_BOOT_REQ		equ	0y10000000

_POWER_BOOT_REQ		equ	0y01000000

_RESUME_BOOT_REQ	equ	0y00100000



;======================================================= 

;	USER SHUTDOWN BIT

;======================================================= 

;User_Shutdown

;	00000000

;	||+--------- main power use shutdown request	0:no request	1:request

;	|+---------- no use shutdown request		0:no request	1:request

;	+----------- power off shutdown request		0:no request	1:request

;	=================================================



MP_SHUTDOWN_REQ	equ	0x07

TIME_SHUTDOWN_REQ	equ	0x06

BAT_SHUTDOWN_REQ	equ	0x05

_MP_SHUTDOWN_REQ	equ	0y10000000

_TIME_SHUTDOWN_REQ	equ	0y01000000

_BAT_SHUTDOWN_REQ	equ	0y00100000



;======================================================= 

;	USER ANSWER BIT

;======================================================= 

;User_Answer

;	00000000

;	|+----------- no use shutdown operation	0:non-existent	1:exists

;	+------------ resume operation		0:non-existent	1:exists

;	=================================================



RESUME_ANS		equ	0x07

TIMER_SHUTDOWN_ANS	equ	0x06

_RESUME_ANS		equ	0y10000000

_TIMER_SHUTDOWN_ANS	equ	0y01000000

