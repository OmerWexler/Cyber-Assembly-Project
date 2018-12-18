;=========== MACROS =========== STABLE, NO DOC
macro WaitForInput
	
	call WaitForInput_PROC
endm

;===========PROCEDURES==========
; ===== Basic wait for any key function ===== STABLE, NO DOC
proc	WaitForInput_PROC
		
		InitBasicProc 0
		
		mov ah, 0h	
		int 16h

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
endp	

;===== Allows the emulator to display the cursor =====
proc DisplayCursor_PROC

	mov ax, 1
	int 33h
	
endp