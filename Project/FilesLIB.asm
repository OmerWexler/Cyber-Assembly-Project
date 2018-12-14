;========== CONSTANTS ========== NO DOC
FileCreateErr db 'Error while creating file', '$'
FileOpenErr db 'Error while openning file', '$'
OF_FileName dw ?, ?
OF_AccessMode dw ?
;=========== MACROS =========== STABLE, NO DOC
macro CreateFile CF_FileName_PARAM, CF_FileHandleOffset_PARAM
	
	InitFunction 
	
	push offset CF_FileName_PARAM
	push offset CF_FileHandleOffset_PARAM
	call CreateFile_PROC
	
	EndFunction
	
endm
	
macro OpenFile OF_FileNameOffset_PARAM, OF_AccessMode_VAR
	
	InitFunction
	push offset OF_FileNameOffset_PARAM
	push OF_AccessMode_VAR
	call OpenFile_PROC
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
	jc CF_Error_LABEL
	
	mov bx, CF_FileHandleOffset_VAR
	mov [bx] , ax
	jmp CF_Finish_LABEL
	
CF_Error_LABEL:
	Print FileCreateErr
	
CF_Finish_LABEL:
	EndBasicProc 0
	ret 4
	
endp CreateFile_PROC

;===== Opens existing file for use ===== STABLE, NO DOC
OF_FileNameOffset_VAR equ [bp + 6]
OF_AccessMode_VAR equ [bp + 4]
proc OpenFile_PROC 
	
	InitBasicProc 0 
	
	mov ax, OF_AccessMode_VAR
	mov [OF_AccessMode], ax
	
	cmp [OF_AccessMode], 'w'
	je OF_SetToWrite_LABEL
	
	cmp [OF_AccessMode], 'b'
	je OF_SetToBoth_LABEL
	
	mov al, 0
	jmp OF_Continue_LABEL
	
OF_SetToWrite_LABEL:
	mov al, 1
	jmp OF_Continue_LABEL
	
OF_SetToBoth_LABEL:
	mov al, 2
	jmp OF_Continue_LABEL
	
OF_Continue_LABEL: 
	mov dx, OF_FileNameOffset_VAR
	mov ah, 3dh
	int 21h 
	jc OF_Error_LABEL
	
OF_Error_LABEL:
	Print FileOpenErr
	
	EndBasicProc 0
	
endp OpenFile_PROC


















