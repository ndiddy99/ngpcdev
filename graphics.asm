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
	public palette,tiles,map,guy,guy_pal
	public palette_end,tiles_end,map_end,guy_end,guy_pal_end

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
	$include "gfx\bg_pal.inc"
palette_end:	
	
	align 2
tiles:
	$include "gfx\bg_tle.inc"
tiles_end:

	align 2
map:
	$include "gfx\map1.map"
map_end:

	align 2
guy:
	$include "gfx\guy_tle.inc"
guy_end:

	align 2
guy_pal:
	$include "gfx\guy_pal.inc"
guy_pal_end:

;-------------------------------------------------------
	end
;-------------------------------------------------------
