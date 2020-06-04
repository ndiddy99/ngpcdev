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
	public palette,palette_end
	public tiles,tiles_end
	public map,map_end
	public hills,hills_end
	public hills_map,hills_map_end
	public hills_pal,hills_pal_end
	public guy,guy_end
	public guy_pal,guy_pal_end

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
hills:
	$include "gfx\hills_tle.inc"
hills_end:

	align 2
hills_map:
	$include "gfx\hills.map"
hills_map_end:

	align 2
hills_pal:
	$include "gfx\hills_pal.inc"
hills_pal_end:

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
