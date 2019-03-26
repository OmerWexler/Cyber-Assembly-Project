;=========== MACROS =========== STABLE, NO DOC

macro WaitTime WT_TimeInSeconds
	
	InitFunction
	push WT_TimeInSeconds
	call WaitTime_PROC
	EndFunction
endm

macro CreateTempRoomInStack

	InitFunction
	
	EndFunction

endm
;=========== PROCEDURES ========== STABLE, NO DOC
;=====Clears the screen=====
;---------------------------

WT_TimeInSeconds_VAR equ [bp + 4] ;rework
proc WaitTime_PROC

	InitBasicProc 0
	mov ax, 0fh
	;mul WT_TimeInSeconds_VAR
	mov cx, ax
	
	mov ax, 4240h
	;mul WT_TimeInSeconds_VAR
	mov dx, ax

	mov ah, 86h
	int 15h
	
	EndBasicProc 0
	ret 2
endp WaitTime_PROC

proc CreateTempRoomInStack_PROC
	
	InitBasicProc 0
	
	push bp
	mov bp, sp
	sub sp, 2
	
	EndBasicProc 0
	ret 0
endp CreateTempRoomInStack_PROC