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
	mov bh, 0  ; Page numbertlot
	
	mov ah, 2
	int 10h
	
	EndBasicProc 0
	ret 4
	
endp SetCursorPos_PROC
;-----------------------------------