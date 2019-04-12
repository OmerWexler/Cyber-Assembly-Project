;=========== MACROS (Support) =========== STABLE, NO DOC
macro 
	
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop bp
	
endm

macro 
	
	push bp
	push bx
	push cx
	push dx
	push di
	push si
	
endm

macro endBasicProc EF_SpOffset_PARAM
	
	add sp, EF_SpOffset_PARAM
	pop bp
	
	
endm

macro initBasicProc IF_SpOffset_PARAM
	
	push bp
	mov bp, sp
	sub sp, IF_SpOffset_PARAM
	
endm

;=========== MACROS =========== STABLE , NO DOC
macro print P_printableVariable_PARAM ;STABLE
	
	

	mov ax, offset P_printableVariable_PARAM
	push ax
	call print_PROC
	
	
	
endm

macro printChar PC_CharToWrite_PARAM
	
	
	
	push PC_CharToWrite_PARAM
	call printChar_PROC
	
	
	
endm
;===========PROCEDURES========== STABLE, NO DOC
; =====prints from the address at the top of the stack===== STABLE, NO DOC
P_printableAdress_VAR equ [bp + 4]
proc print_PROC
	
	initBasicProc 0
	
	mov dx, P_printableAdress_VAR
	mov ah, 9h
	int 21h
	
	endBasicProc 0
	ret 2
	
endp print_PROC
;----------------------------------------------------------

PC_CharToWrite_VAR equ [bp + 4] ; STABLE, NO DOC
proc printChar_PROC

	initBasicProc 0
	
	mov al, PC_CharToWrite_VAR
	mov ah, 0eh
	int 10h
	
	endBasicProc 0
	ret 2
endp printChar_PROC
	
	
	
	
	


