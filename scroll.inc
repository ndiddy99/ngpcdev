;-------------------------------------------------------
; scroll_set: set scroll to specified coords
;-------------------------------------------------------
; wa: x pos
; bc: y pos
;-------------------------------------------------------
extern scroll_set

;-------------------------------------------------------
; scroll_get_tile: returns tile # at given coordinates in wa
;-------------------------------------------------------
; wa: x pos
; bc: y pos
;-------------------------------------------------------
extern scroll_get_tile

;-------------------------------------------------------
; scroll_copy: carry out scroll changes made in scroll_set (run during vblank)
;-------------------------------------------------------
extern scroll_copy