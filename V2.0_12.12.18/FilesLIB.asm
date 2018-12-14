;========== CONSTANTS ========== NO DOC
FileCreateErr db 'Error while creating file', '$'

;=========== MACROS =========== STABLE, NO DOC
macro CreateFile CF_FileName_PARAM, CF_FileHandleOffset_PARAM
	
	InitFunction 
	
	push offset CF_FileName_PARAM
	push offset CF_FileHandleOffset_PARAM
	call CreateFile_PROC
	
	EndFunction
	
endm
	
;=========== PROCEDURES ========== STABLE, NO DOC 
;===== Creates a file with the inserted parameters =====
CF_FileName_VAR equ [bp + 6]
CF_FileHandleOffset_VAR equ [bp + 4]
proc CreateFile_PROC
	
	InitBasicProc 0
	
	mov ah, 3ch
	mov cx, 0
	mov dx, CF_FileName_VAR
	mov ah, 3ch
	int 21h
	jc openerror2
	
	mov bx, CF_FileHandleOffset_VAR
	mov [bx] , ax
	jmp finishCreatFile
	
	openerror2:
	
	mov dx, offset FileCreateErr 
	mov ah, 9h
	int 21h
	
	finishCreatFile:
	EndBasicProc 0
	ret 4
	
endp CreateFile_PROC