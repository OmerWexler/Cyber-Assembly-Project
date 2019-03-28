;=========== MACROS =========== STABLE, NO DOC
macro CreateFile CF_FileName_PARAM, CF_FileHandle_PARAM
	
	InitFunction ;pushes all registers 
	push offset CF_FileName_PARAM ;provides the file name.
	push offset CF_FileHandle_PARAM ; provides the file handle
	call CreateFile_PROC
	EndFunction ;pops all registers back
	
endm
	
macro OpenFile OF_FileName_PARAM, OF_FileHandle_PARAM, OF_AccessMode_PARAM
	
	InitFunction ;pushes all registers
	push offset OF_FileName_PARAM
	push offset OF_FileHandle_PARAM
	push OF_AccessMode_PARAM
	call OpenFile_PROC
	EndFunction ;pops all registers back
	
endm

macro WriteToFile WTF_FileHandle_PARAM, WTF_DataToWrite_PARAM

	InitFunction ;pushes all registers
	push [WTF_FileHandle_PARAM]
	push offset WTF_DataToWrite_PARAM
	call WriteToFile_PROC
	EndFunction ;pops all registers back
	
endm

macro CloseFile COF_FileHandle_PARAM

	InitFunction ;pushes all registers
	push [COF_FileHandle_PARAM]
	call CloseFile_PROC
	EndFunction ;pops all registers back
	
endm

macro DeleteFile DF_FileName_PARAM
	
	InitFunction ;pushes all registers
	push offset DF_FileName_PARAM
	call DeleteFile_PROC
	EndFunction ;pops all registers back
	
endm

macro ReadFromFile RFF_FileHandle_PARAM, RFF_BytesToRead_PARAM, RFF_VarToInsertTo_PARAM
	
	InitFunction ;pushes all registers
	push [RFF_FileHandle_PARAM]
	push [RFF_BytesToRead_PARAM]
	push offset RFF_VarToInsertTo_PARAM
	call ReadFromFile_PROC
	EndFunction ;pops all registers back
	
endm

;=========== PROCEDURES ========== STABLE, NO DOC 
;===== Creates a file with the inserted parameters =====
CF_FileNameOffset_VAR equ [bp + 6]
CF_FileHandleOffset_VAR equ [bp + 4]
proc CreateFile_PROC
	
	InitBasicProc 0
	
	mov cx, 0
	mov dx, CF_FileNameOffset_VAR
	mov ah, 3ch
	int 21h
	jc CF_Error_LABEL
	
	mov bx, CF_FileHandleOffset_VAR
	mov [bx] , ax
	jmp CF_Finish_LABEL
	
CF_Error_LABEL:
	PrintChar 'E'
	
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
	
	cmp al, 'r'
	je OF_SetToRead_LABEL

OF_SetToWrite_LABEL:
	mov al, 1
	jmp OF_Continue_LABEL
	
OF_SetToBoth_LABEL:
	mov al, 2
	jmp OF_Continue_LABEL
	
OF_SetToRead_LABEL:	
	mov al, 0
	jmp OF_Continue_LABEL
	
OF_Continue_LABEL: 
	mov dx, OF_FileNameOffset_VAR
	mov ah, 3dh
	int 21h 
	jc OF_Error_LABEL
	
	mov bx, OF_FileHandleOffset_VAR
	mov [bx], ax
	EndBasicProc 0
	jmp OF_End_LABEL
	
OF_Error_LABEL:
	PrintChar 'E'
	EndBasicProc 0
	jmp OF_End_LABEL
	
OF_End_LABEL:
	ret 4
endp OpenFile_PROC

;===== Writes into an open file ===== STABLE, NO DOC
WTF_FileHandle_VAR equ [bp + 6]
WTF_DataToWriteOffset_VAR equ [bp + 4]
WTF_CharsCounter_VAR equ [bp - 2]
proc WriteToFile_PROC

	InitBasicProc 2 ;prepares to run the procedure
	xor di, di ;cleans up di
	
WTF_DollarSignLoop_LABEL:
	
	mov bx, WTF_DataToWriteOffset_VAR ;saves msg offset
	mov ah, [bx + di] ;saves the current char into ah
	cmp ah, '$' ;compares the saved char to a $ sign. if equals it breaks the count
	je WTF_Continue_LABEL ;continues the write procces
	
	inc di ;increments the chars to write countes
	jmp WTF_DollarSignLoop_LABEL ;restarts the check with the next char
	
WTF_Continue_LABEL:

	mov ax, di ;gets the number of chars
	sub ax, 1 ;removes ome char to account for the dollar sign
	mov WTF_CharsCounter_VAR, ax ;moves the actual char number (without dollar) into the local variable
	
	mov bx, WTF_FileHandle_VAR ;feeds the file handle to the write interrupt
	mov cx, WTF_CharsCounter_VAR ;feeds the number of chars to write to the write interrupt
	mov dx, WTF_DataToWriteOffset_VAR ;feeds the starting offset to write to the write interrupt
	mov ah, 40h ;prepares to run by "selecting the interrupt"
	int 21h ;calls the chosen interrupt
	
	mov ax, WTF_CharsCounter_VAR ;passes the number of written chars via ax.
	EndBasicProc 2 ;cleans up using the library
	ret 4 ;returns to the rest of the runtime code
	
endp WriteToFile_PROC

;===== Closes a file in use ===== STABLE, NO DOC
COF_FileHandle_VAR equ [bp + 4]
proc CloseFile_PROC
	
	InitBasicProc 0
	mov bx, COF_FileHandle_VAR
	mov ah, 3Eh
	int 21h
	EndBasicProc 0
	ret 2
	
endp
	
;===== Deletes a file =====
DF_FileNameOffset_VAR equ [bp + 4]
proc DeleteFile_PROC
	
	InitBasicProc 0
	mov dx, DF_FileNameOffset_VAR
	mov ah, 41h
	int 21h
	
	EndBasicProc 0
endp

;===== Reads from a file =====
RFF_FileHandle_VAR equ [bp + 8]
RFF_BytesToRead_VAR equ [bp + 6]
RFF_OffsetToInsertTo_VAR equ [bp + 4]
proc ReadFromFile_PROC
	
	InitBasicProc 0
	
	OpenFile tempFileName, tempFileHandle, 'r' 
	
	mov dx, offset readBuffer
	mov bx, RFF_FileHandle_VAR
	mov cx, RFF_BytesToRead_VAR
	mov ah, 3fh
	int 21h
	
	xor di, di
	mov bx, RFF_OffsetToInsertTo_VAR
	mov cx, RFF_BytesToRead_VAR

InsertToTarget:
		mov al, [readBuffer + di]
		mov [bx + di], al
		
		inc di
		loop InsertToTarget
	
	EndBasicProc 0
	ret 6
	
endp ReadFromFile_PROC	

;===== Set Temp File Name =====
STFN_OGFileNameOffset_VAR equ [bp + 2]
proc SetTempFileName_PROC
	InitBasicProc 0
	
	mov cx, 8d
	transfer
	mov bx, STFN_OGFileNameOffset_VAR
	mov ax, [bx + si] 
	mov [tempFileName + di], ax
	
	EndBasicProc 0
	ret 2
endp SetTempFileName_PROC
