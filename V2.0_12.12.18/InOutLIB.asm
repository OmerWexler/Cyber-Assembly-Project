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
