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