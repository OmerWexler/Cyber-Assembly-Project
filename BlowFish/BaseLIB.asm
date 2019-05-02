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

;===== prints from the address at the top of the stack =====
macro print P_printableVariable 
	
	pushAll
	
	mov ax, offset P_printableVariable
	push ax
	call print_PROC
	
	popAll

endm

P_printableAdress_VAR equ [bp + 4]
proc print_PROC
	
	initBasicProc 0
	
	mov dx, P_printableAdress_VAR
	mov ah, 9h
	int 21h
	
	endBasicProc 0
	ret 2
	
endp print_PROC

;===== Prints one given char =====
macro printChar PC_CharToWrite
	pushAll	

	push PC_CharToWrite
	call printChar_PROC
	
	popAll
endm

PC_CharToWrite_VAR equ [bp + 4] ; STABLE, NO DOC
proc printChar_PROC

	initBasicProc 0
	
	mov al, PC_CharToWrite_VAR
	mov ah, 0eh
	int 10h
	
	endBasicProc 0
	ret 2
endp printChar_PROC

;===== Read the system's time =====
;Hours - ch
;Minutes - cl
;Seconds - dh
;Miliseconds - dl
macro readSystemTime
	mov ah, 2ch
	int 21h
endm readSystemTime