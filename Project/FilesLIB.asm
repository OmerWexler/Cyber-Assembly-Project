;========== CONSTANTS ========== NO DOC
FileCreateErr db 'Error while creating file$'
OF_FileName dw ?, ?
OF_AccessMode dw ?
;=========== MACROS =========== STABLE, NO DOC
macro CreateFile CF_FileName_PARAM, CF_FileHandle_PARAM
	
	InitFunction 
	push offset CF_FileName_PARAM
	push offset CF_FileHandle_PARAM
	call CreateFile_PROC
	EndFunction
	
endm
	
macro OpenFile OF_FileName_PARAM, OF_FileHandle_PARAM, OF_AccessMode_PARAM
	
	InitFunction
	push offset OF_FileName_PARAM
	push offset OF_FileHandle_PARAM
	push OF_AccessMode_PARAM
	call OpenFile_PROC
	EndFunction
	
endm

macro WriteToFile WTF_FileHandle_PARAM, WTF_DataToWrite_PARAM

	InitFunction
	push [WTF_FileHandle_PARAM]
	push offset WTF_DataToWrite_PARAM
	call WriteToFile_PROC
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

OF_FileNameOffset_VAR equ [bp + 8]
OF_FileHandleOffset_VAR equ [bp + 6]
OF_AccessMode_VAR equ [bp + 4]
proc OpenFile_PROC 
	
	InitBasicProc 0 
	
	mov al, OF_AccessMode_VAR
	
	cmp al, 'w'
	je OF_SetToWrite_LABEL
	
	cmp al, 'b'
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
	
	mov bx, OF_FileHandleOffset_VAR
	mov [bx], ax
	EndBasicProc 0
	ret 4
	
OF_Error_LABEL:
	PrintChar 'E'
	EndBasicProc 0
	ret 4
endp OpenFile_PROC

;===== Writes into an open file ===== STABLE, NO DOC
WTF_FileHandle_VAR equ [bp + 6]
WTF_DataToWriteOffset_VAR equ [bp + 4]
WTF_CharsCounter_VAR equ [bp - 2]
proc WriteToFile_PROC

	InitBasicProc 2
	xor di, di
	
WTF_DollarSignLoop_LABEL:
	
	mov bx, WTF_DataToWriteOffset_VAR
	mov ah, [bx + di]
	cmp ah, '$'
	je WTF_Continue_LABEL
	
	inc di
	jmp WTF_DollarSignLoop_LABEL
	
WTF_Continue_LABEL:

	mov ax, di
	sub ax, 2
	mov WTF_CharsCounter_VAR, ax
	
	mov bx, WTF_FileHandle_VAR
	mov cx, WTF_CharsCounter_VAR
	mov dx, WTF_DataToWriteOffset_VAR
	mov ah, 40h
	int 21h
	
	EndBasicProc 2
	ret 4
	
endp WriteToFile_PROC














