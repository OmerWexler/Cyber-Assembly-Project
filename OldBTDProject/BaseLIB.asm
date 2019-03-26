;=========== MACROS (Support) =========== STABLE, NO DOC
macro EndFunction
	
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop bp
	
endm

macro InitFunction
	
	push bp
	push bx
	push cx
	push dx
	push di
	push si
	
endm

macro EndBasicProc EF_SpOffset_PARAM
	
	add sp, EF_SpOffset_PARAM
	pop bp
	
	
endm

macro InitBasicProc IF_SpOffset_PARAM
	
	push bp
	mov bp, sp
	sub sp, IF_SpOffset_PARAM
	
endm

;=========== MACROS =========== STABLE , NO DOC
macro Print P_PrintableVariable_PARAM ;STABLE
	
	InitFunction

	mov ax, offset P_PrintableVariable_PARAM
	push ax
	call Print_PROC
	
	EndFunction
	
endm

macro PrintChar PC_CharToWrite_PARAM
	
	InitFunction
	
	push PC_CharToWrite_PARAM
	call PrintChar_PROC
	
	EndFunction
	
endm
;===========PROCEDURES========== STABLE, NO DOC
; =====Prints from the address at the top of the stack===== STABLE, NO DOC
P_PrintableAdress_VAR equ [bp + 4]
proc Print_PROC
	
	InitBasicProc 0
	
	mov dx, P_PrintableAdress_VAR
	mov ah, 9h
	int 21h
	
	EndBasicProc 0
	ret 2
	
endp Print_PROC
;----------------------------------------------------------

PC_CharToWrite_VAR equ [bp + 4] ; STABLE, NO DOC
proc PrintChar_PROC

	InitBasicProc 0
	
	mov al, PC_CharToWrite_VAR
	mov ah, 0eh
	int 10h
	
	EndBasicProc 0
	ret 2
endp PrintChar_PROC
	
	
	
	
	


