;=======================================================

;		TLCS-900 CPU Equates

;=======================================================

TRUN            equ     0x0020   ; Timer Operation Control
TREG0           equ     0x0022   ; Timer Register 0
TREG1           equ     0x0023   ; Timer Register 1
TMOD            equ     0x0024   ; Timer Mode Control
TFFCF           equ     0x0025   ; Timer Flip-Flop Control
TREG2           equ     0x0026   ; Timer Register 2
TREG3           equ     0x0027   ; Timer Register 3
P0MOD           equ     0x0028   ; 8-Bit PWM 0 Mode Control
P1MOD           equ     0x0029   ; 8-Bit PWM 1 Mode Control
PFFCR           equ     0x002A   ; 8-Bit PWM Flip-Flop Control

TREG4L          equ     0x0030   ; Timer 4 Low Byte
TREG4H          equ     0x0031   ; Timer 4 High Byte
TREG5L          equ     0x0032   ; Timer 5 Low Byte
TREG5H          equ     0x0033   ; Timer 5 High Byte
CAP1L           equ     0x0034   ; Capture 1 Low Byte
CAP1H           equ     0x0035   ; Capture 1 High Byte
CAP2L           equ     0x0036   ; Capture 2 Low Byte
CAP2H           equ     0x0037   ; Capture 2 High Byte
T4MOD           equ     0x0038   ; 16-Bit Timer 4 Mode Control
T4FFCR          equ     0x0039   ; 16-Bit Timer 4 Flip-Flop Control
T45CR           equ     0x003A   ; 16-Bit Timer 4/5 Control

TREG6L          equ     0x0040   ; Timer 6 Low Byte
TREG6H          equ     0x0041   ; Timer 6 High Byte
TREG7L          equ     0x0042   ; Timer 7 Low Byte
TREG7H          equ     0x0043   ; Timer 7 High Byte
CAP3L           equ     0x0044   ; Capture 3 Low Byte
CAP3H           equ     0x0045   ; Capture 3 High Byte
CAP4L           equ     0x0046   ; Capture 4 Low Byte
CAP4H           equ     0x0047   ; Capture 4 High Byte
T5MOD           equ     0x0048   ; 16-Bit Timer 4 Mode Control
T5FFCR          equ     0x0049   ; 16-Bit Timer 4 Flip-Flop Control

PG0REG          equ     0x004C   ; Pattern Generator 0
PG1REG          equ     0x004D   ; Pattern Generator 1
PG01CR          equ     0x004E   ; Pattern Generator 0/1 Control

SC0BUF          equ     0x0050   ; Serial Channel 0 Buffer Data
SC0CR           equ     0x0051   ; Serial Channel 0 Control
SC0MOD          equ     0x0052   ; Serial Channel 0 Mode Control
BR0CR           equ     0x0053   ; Bit Rate Ser. Channel 0 Control
SC1BUF          equ     0x0054   ; Serial Channel 1 Buffer Data
SC1CR           equ     0x0055   ; Serial Channel 1 Control
SC1MOD          equ     0x0056   ; Serial Channel 1 Mode Control
BR1CR           equ     0x0057   ; Bit Rate Ser. Channel 1 Control

ADMOD           equ     0x005E   ; A/D Control
ADREG0L         equ     0x0060   ; A/D Result Channel 0 Bit 7..6 = AD1..0
ADREG0H         equ     0x0061   ; A/D Result Channel 0 Bit 7..0 = AD9..2
ADREG1L         equ     0x0062   ; A/D Result Channel 1 Bit 7..6 = AD1..0
ADREG1H         equ     0x0063   ; A/D Result Channel 1 Bit 7..0 = AD9..2
ADREG2L         equ     0x0064   ; A/D Result Channel 2 Bit 7..6 = AD1..0
ADREG2H         equ     0x0065   ; A/D Result Channel 2 Bit 7..0 = AD9..2
ADREG3L         equ     0x0066   ; A/D Result Channel 3 Bit 7..6 = AD1..0
ADREG3H         equ     0x0067   ; A/D Result Channel 3 Bit 7..0 = AD9..2

B0CS            equ     0x0068   ; Block 0 CS/WAIT Control
B1CS            equ     0x0069   ; Block 1 CS/WAIT Control
B2CS            equ     0x006A   ; Block 2 CS/WAIT Control

INTE0AD         equ     0x0070   ; Interrupt Enable/Level AD/Timer 0
INTE45          equ     0x0071   ; Interrupt Enable/Level IRQ 5/4
INTE67          equ     0x0072   ; Interrupt Enable/Level IRQ 7/6
INTET10         equ     0x0073   ; Interrupt Enable/Level Timer 1/0
INTEPW10        equ     0x0074   ; Interrupt Enable/Level Timer 3/2 (PWM 1/0)
INTET54         equ     0x0075   ; Interrupt Enable/Level TREG 5/4
INTET76         equ     0x0076   ; Interrupt Enable/Level TREG 7/6
INTES0          equ     0x0077   ; Interrupt Enable/Level Serial Channel 0
INTES1          equ     0x0078   ; Interrupt Enable/Level Serial Channel 1
IIMC            equ     0x007B   ; Interrupt Input Mode Control

DMA0V           equ     0x007C   ; fDMA 0 Start Vector
DMA1V           equ     0x007D   ; fDMA 1 Start Vector
DMA2V           equ     0x007E   ; fDMA 2 Start Vector
DMA3V           equ     0x007F   ; fDMA 3 Start Vector
