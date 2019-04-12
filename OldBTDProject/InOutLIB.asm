;=========== MACROS =========== STABLE, NO DOC
macro WaitForInput
	
	
	call WaitForInput_PROC
	
endm

macro ReadLastKey

	
	call ReadLastKey_PROC
	
	
endm

macro InitMouse
	
	
	call InitMouse_PROC
	

endm

macro DisplayCursor
	
	
	call DisplayCursor_PROC
	
	
endm

macro GetMouseX

	
	call GetMouseX_PROC
	

endm

macro GetMouseY 
	
	
	call GetMouseY_PROC
	

endm

macro CompareMouseXY
	

	
endm
;===========PROCEDURES==========
; ===== Basic wait for any key function ===== STABLE, NO DOC
proc	WaitForInput_PROC
		
	initBasicProc 0
	
	mov ah, 1h	
	int 21h

	endBasicProc 0
	ret	
endp	WaitForInput_PROC
;------------------------------------------

;===== Starts the mouse actor =====
proc InitMouse_PROC
	
	initBasicProc 0
	
	mov ax, 0
	int 33h
	
	endBasicProc 0
	ret
endp	

;===== Allows the emulator to display the cursor =====
proc DisplayCursor_PROC

	initBasicProc 0
	
	mov ax, 1
	int 33h
	
	endBasicProc 0
	ret
endp


proc GetMouseX_PROC 

	initBasicProc 0 
	
	mov ax, 0h
	int 33

	mov ax, cx
	
	endBasicProc 0 
	ret 0 
endp GetMouseX_PROC



proc GetMouseY_PROC 

	initBasicProc 0 
	
	mov ax, 0h
	int 33

	mov ax, dx
	
	endBasicProc 0 
	ret 0
endp GetMouseY_PROC

proc GetLastKey_PROC
	
	initBasicProc 0
	
	endBasicProc 0
	ret 0

endp GetLastKey_PROC

proc ReadLastKey_PROC
	
	initBasicProc 0
	
	mov ah, 1h
	int 16h
	
	endBasicProc 0
	ret 0
endp ReadLastKey_PROC