;-------------------------------------------------------
; scroll_set: set scroll to specified coords
;-------------------------------------------------------
; wa: x pos
; bc: y pos
;-------------------------------------------------------
extern scroll_set

;-------------------------------------------------------
; scroll_copy: carry out scroll changes made in scroll_set (run during vblank)
;-------------------------------------------------------
extern scroll_copy