;=========== MACROS (Support) =========== STABLE, NO DOC
macro initBasicProc IF_SpOffset
	
	push bp
	mov bp, sp
	sub sp, IF_SpOffset
	
endm

macro endBasicProc EF_SpOffset
	
	add sp, EF_SpOffset
	pop bp
	
endm

macro pushAll 
	push ax
	push bx
	push cx
	push dx
	push si
	push di
endm pushAll

macro popAll 
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
endm popAll
;=========== MACROS =========== STABLE , NO DOC
macro print P_printableVariable ;STABLE
	
	pushAll
	
	mov ax, offset P_printableVariable
	push ax
	call print_PROC
	
	popAll

endm

macro printChar PC_CharToWrite
	pushAll	

	push PC_CharToWrite
	call printChar_PROC
	
	popAll
endm

;=========== PROCEDURES ========== STABLE, NO DOC
;===== prints from the address at the top of the stack ===== STABLE, NO DOC
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