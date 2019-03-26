;=========== MACROS =========== STABLE, NO DOC
macro WaitForInput
	
	InitFunction
	call WaitForInput_PROC
	EndFunction
endm

macro ReadLastKey

	InitFunction
	call ReadLastKey_PROC
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

macro GetMouseX

	InitFunction
	call GetMouseX_PROC
	EndFunction

endm

macro GetMouseY 
	
	InitFunction
	call GetMouseY_PROC
	EndFunction

endm

macro CompareMouseXY
	InitFunction

	EndFunction
endm
;===========PROCEDURES==========
; ===== Basic wait for any key function ===== STABLE, NO DOC
proc	WaitForInput_PROC
		
	InitBasicProc 0
	
	mov ah, 1h	
	int 21h

	EndBasicProc 0
	ret	
endp	WaitForInput_PROC
;------------------------------------------

;===== Starts the mouse actor =====
proc InitMouse_PROC
	
	InitBasicProc 0
	
	mov ax, 0
	int 33h
	
	EndBasicProc 0
	ret
endp	

;===== Allows the emulator to display the cursor =====
proc DisplayCursor_PROC

	InitBasicProc 0
	
	mov ax, 1
	int 33h
	
	EndBasicProc 0
	ret
endp


proc GetMouseX_PROC 

	InitBasicProc 0 
	
	mov ax, 0h
	int 33

	mov ax, cx
	
	EndBasicProc 0 
	ret 0 
endp GetMouseX_PROC



proc GetMouseY_PROC 

	InitBasicProc 0 
	
	mov ax, 0h
	int 33

	mov ax, dx
	
	EndBasicProc 0 
	ret 0
endp GetMouseY_PROC

proc GetLastKey_PROC
	
	InitBasicProc 0
	
	EndBasicProc 0
	ret 0

endp GetLastKey_PROC

proc ReadLastKey_PROC
	
	InitBasicProc 0
	
	mov ah, 1h
	int 16h
	
	EndBasicProc 0
	ret 0
endp ReadLastKey_PROC