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
	
	mov ah, SGM_DesiredMode_VAR 
	
	cmp ah, 'g'
	je SGM_SwitchToGraphicMode_LABEL
	
	cmp ah, 't'
	je SGM_SwitchToTextMode_LABEL
	
SGM_SwitchToTextMode_LABEL:
	mov al, 3h
	jmp SGM_Finish_LABEL
	
SGM_SwitchToGraphicMode_LABEL:
	mov al, 13h
	jmp SGM_Finish_LABEL
	
SGM_Finish_LABEL:

	mov ah, 0
	INT 10h
	
	EndBasicProc 0
	ret 2
	
ENDP SwitchGraphicsMode_PROC
;----------------------------------------------------------------------------------------------