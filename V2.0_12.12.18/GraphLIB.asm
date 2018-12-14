;=========  MACROS ========== STABLE, NO DOC
macro SwitchGraphicsMode SGM_DesiredMode_PARAM
	
	InitFunction
	
	push SGM_DesiredMode_PARAM
	call SwitchGraphicsMode_PROC

	EndFunction
endm


;=========== PROCEDURES =========== STABLE, NO DOC
; =====Switching graphic modes. 1 for graphic, 0 for text (draws from the top of the stack)=====
SGM_DesiredMode_VAR equ [bp + 4]
PROC SwitchGraphicsMode_PROC
	
	InitBasicProc 0
	
	mov ax, SGM_DesiredMode_VAR 
	
	cmp ax, 1h
	je SGM_SwitchToGraphicMode_LABEL
	
	mov ax, 2h
	int 10h
	ret
	
SGM_SwitchToGraphicMode_LABEL:
	mov ax, 13h
	INT 10h
	
	EndBasicProc 0
	ret 2
	
ENDP SwitchGraphicsMode_PROC
;----------------------------------------------------------------------------------------------