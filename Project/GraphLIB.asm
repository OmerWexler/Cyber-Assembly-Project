;=========  MACROS ========== STABLE, NO DOC
macro SwitchGraphicsMode SGM_DesiredMode_PARAM
	
	InitFunction
	
	push SGM_DesiredMode_PARAM
	call SwitchGraphicsMode_PROC

	EndFunction
endm

macro SetPixel SP_Color_PARAM, SP_PixelX_PARAM, SP_PixelY_PARAM

	InitFunction
	push SP_Color_PARAM
	push SP_PixelX_PARAM
	push SP_PixelY_PARAM
	call SetPixel_PROC
	EndFunction

endm

macro GetPixel GP_PixelX_PARAM, GP_PixelY_PARAM

	InitFunction
	push GP_PixelX_PARAM
	push GP_PixelY_PARAM
	call GetPixel_PROC
	EndFunction

endm

macro GetPixelIntoVar GPIV_PixelX_PARAM, GPIV_PixelY_PARAM, GPIV_Var_PARAM

	InitFunction
	push GPIV_PixelX_PARAM
	push GPIV_PixelY_PARAM
	call GetPixel_PROC
	mov [GPIV_Var_PARAM], al
	EndFunction

endm

	
;=========== PROCEDURES =========== STABLE, NO DOC
SGM_DesiredMode_VAR equ [bp + 4]
PROC SwitchGraphicsMode_PROC
	
	InitBasicProc 0
	
	mov ah, SGM_DesiredMode_VAR 
	
	cmp ah, 'g'
	je SGM_SwitchToGraphicMode_LABEL
	
	cmp ah, 't'
	je SGM_SwitchToTextMode_LABEL
	
SGM_SwitchToTextMode_LABEL:
	mov al, 03h
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


GC_PixelX_VAR equ [bp - 2]
GC_PixelY_VAR equ [bp - 4]
proc GenerateCharacter_PROC
	
	InitBasicProc 4
	
	
	
	
	EndBasicProc 4
	ret 0
endp GenerateCharacter_PROC

;===== Set Pixel =====
SP_Color_VAR equ [bp + 8]
SP_PixelX_VAR equ [bp + 6]
SP_PixelY_VAR equ [bp + 4]
proc SetPixel_PROC

	InitBasicProc 0
	
	mov al, SP_Color_VAR
	mov dx, SP_PixelY_VAR
	mov cx, SP_PixelX_VAR
	mov ah, 0ch
	int 10h
	
	EndBasicProc 0
	ret 6
endp SetPixel_PROC

GP_PixelX_VAR equ [bp + 6]
GP_PixelY_VAR equ [bp + 4]
proc GetPixel_PROC
	
	InitBasicProc 0
	
	mov cx, GP_PixelX_VAR
	mov dx, GP_PixelY_VAR
	mov ah, 0dh
	int 10h
	
	EndBasicProc 0 
	ret 4
endp GetPixel_PROC
	
	
	
	

