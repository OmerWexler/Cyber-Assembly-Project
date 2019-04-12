;=========== MACROS =========== STABLE, NO DOC

macro WaitTime WT_TimeInSeconds
	
	
	push WT_TimeInSeconds
	call WaitTime_PROC
	
endm

macro CreateTempRoomInStack

	
	
	

endm
;=========== PROCEDURES ========== STABLE, NO DOC
;=====Clears the screen=====
;---------------------------

WT_TimeInSeconds_VAR equ [bp + 4] ;rework
proc WaitTime_PROC

	initBasicProc 0
	mov ax, 0fh
	;mul WT_TimeInSeconds_VAR
	mov cx, ax
	
	mov ax, 4240h
	;mul WT_TimeInSeconds_VAR
	mov dx, ax

	mov ah, 86h
	int 15h
	
	endBasicProc 0
	ret 2
endp WaitTime_PROC

proc CreateTempRoomInStack_PROC
	
	initBasicProc 0
	
	push bp
	mov bp, sp
	sub sp, 2
	
	endBasicProc 0
	ret 0
endp CreateTempRoomInStack_PROC