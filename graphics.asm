;*****************************************
;	Graphics data 
;*****************************************
	$MAXIMUM
	module print

;  ---------------------------------
;	    EXTERNAL LOOK UP
;  ---------------------------------

;  ---------------------------------
;           EXTERNAL DEFINITION
;  ---------------------------------
	public palette,tiles,map
	public palette_end,tiles_end,map_end

;  ---------------------------------
;	INCLUDE
;  ---------------------------------
	$include "k1head.inc"
	$include "system.inc"

;-------------------------------------------------------
PROG section code large
;-------------------------------------------------------
	align 2
palette:
	$include "tools\tileconv\palette.inc"
palette_end:	
	
	align 2
tiles:
	$include "tools\tileconv\tiles.inc"
tiles_end:

	align 2
map:
	$include "tools\mapconv\map1.map"
map_end:

;-------------------------------------------------------
	end
;-------------------------------------------------------
