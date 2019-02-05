;=========== MACROS =========== STABLE, NO DOC
macro ClearScreen 
	
	InitFunction
	call ClearScreen_PROC
	EndFunction

endm

macro SetCursorPos SCP_X_PARAM, SCP_Y_PARAM

	InitFunction
	
	push SCP_X_PARAM
	push SCP_Y_PARAM
	call SetCursorPos_PROC
	
	EndFunction

endm

macro InitMouse 
	
	InitFunction
	call InitMouse_PROC
	EndFunction
	
endm	

macro DisplayCursor

	InitFunction
	call DisplayCursor_PROC
	EndFunction
	
endm

macro WaitTime WT_TimeInSeconds_PARAM
	
	InitFunction
	push WT_TimeInSeconds_PARAM
	call WaitTime_PROC
	EndFunction
endm
;=========== PROCEDURES ========== STABLE, NO DOC
;=====Clears the screen=====
proc ClearScreen_PROC

	InitBasicProc 0
	
	mov ax, 13h
	INT 10h
	
	EndBasicProc 0
	ret
	
endp ClearScreen_PROC
;---------------------------

; =====Sets the cursor position===== 
SCP_X_Var equ [bp + 6]
SCP_Y_Var equ [bp + 4]
proc SetCursorPos_PROC

	InitBasicProc 0
	
	mov dl, SCP_X_Var	; X
	mov dh, SCP_Y_Var	; Y
	mov bh, 0  ; Page number lot
	
	mov ah, 2
	int 10h
	
	EndBasicProc 0
	ret 4
	
endp SetCursorPos_PROC
;-----------------------------------

WT_TimeInSeconds_VAR equ [bp + 4]
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
	





