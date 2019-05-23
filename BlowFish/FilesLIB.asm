;===== Creates a file with the inserted parameters =====
macro createFile CF_FileName_PARAM, CF_FileHandle_PARAM
	
	pushAll
	push offset CF_FileName_PARAM
	call createFile_PROC
	
	mov CF_FileHandle_PARAM, ax
	popAll

endm

CF_FileNameOffset_VAR equ bp + 4
proc createFile_PROC
	
	initBasicProc 0
	
	mov cx, 0
	mov dx, [CF_FileNameOffset_VAR]
	mov ah, 3ch
	int 21h
	jc CF_Error_LABEL
	
	;mov bx, [CF_FileHandleOffset_VAR]
	;mov [bx] , ax
	jmp CF_Finish_LABEL
	
	CF_Error_LABEL:
		printChar 'E'
		
	CF_Finish_LABEL:
		endBasicProc 0
		ret 2
endp createFile_PROC

;===== Opens existing file for use =====
macro openFile OF_FileName_PARAM, OF_FileHandle_PARAM, OF_AccessMode_PARAM
	
	pushAll ;pushes all registers
	push offset OF_FileName_PARAM
	push offset OF_FileHandle_PARAM
	push OF_AccessMode_PARAM
	call openFile_PROC
	popAll ;pops all registers back
	
endm

OF_FileNameOffset_VAR equ [bp + 8]
OF_FileHandleOffset_VAR equ [bp + 6]
OF_AccessMode_VAR equ [bp + 4]
proc openFile_PROC 
	
	initBasicProc 0 
	
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
	jmp OF_End_LABEL
	
OF_Error_LABEL:
	printChar 'E'
	jmp OF_End_LABEL
	
OF_End_LABEL:
	endBasicProc 0
	ret 6
endp openFile_PROC

;===== Closes a file in use =====
macro closeFile COF_FileHandle_PARAM

	pushAll ;pushes all registers
	push COF_FileHandle_PARAM
	call closeFile_PROC
	popAll ;pops all registers back
	
endm

COF_FileHandle_VAR equ [bp + 4]
proc closeFile_PROC
	
	initBasicProc 0
	mov bx, COF_FileHandle_VAR
	mov ah, 3Eh
	int 21h
	endBasicProc 0
	ret 2
	
endp
	
;===== Deletes a file =====
macro DeleteFile DF_FileName_PARAM
	
	pushAll ;pushes all registers
	push offset DF_FileName_PARAM
	call DeleteFile_PROC
	popAll ;pops all registers back
	
endm

DF_FileNameOffset_VAR equ [bp + 4]
proc DeleteFile_PROC
	
	initBasicProc 0
	mov dx, DF_FileNameOffset_VAR
	mov ah, 41h
	int 21h
	
	endBasicProc 0
endp

;===== Reads from a file =====
macro readFromFile RFF_FileHandle_PARAM, RFF_BytesToRead_PARAM, RFF_VarToInsertTo_PARAM
	
	push [RFF_FileHandle_PARAM]
	push RFF_BytesToRead_PARAM
	push offset RFF_VarToInsertTo_PARAM
	call readFromFile_PROC
	
endm

RFF_FileHandle_VAR equ [bp + 8]
RFF_BytesToRead_VAR equ [bp + 6]
RFF_OffsetToInsertTo_VAR equ [bp + 4]
proc readFromFile_PROC
	
	initBasicProc 0
		
	mov dx, offset readBuffer
	mov bx, RFF_FileHandle_VAR 
	mov cx, RFF_BytesToRead_VAR
	mov ah, 3fh
	int 21h

	push ax

	xor di, di
	mov bx, RFF_OffsetToInsertTo_VAR
	mov cx, RFF_BytesToRead_VAR
	InsertToTarget:
		mov al, [readBuffer + di]
		mov [bx + di], al
		
		inc di
	loop InsertToTarget
	
	pop ax

	endBasicProc 0
	ret 6
	
endp readFromFile_PROC	

;===== Seek File =====
macro seekFile fileHandle, originOfMove, lowOffset, highOffset
	pushAll

	push fileHandle
	push originOfMove
	push lowOffset
	push highOffset
	call SeekFile_PROC

	popAll
endm seekFile


SF_FileHandle_VAR equ  bp + 10
SF_Origin_Of_Move_VAR equ bp + 8
SF_Low_Offset_VAR equ bp + 6
SF_High_Offset_VAR equ bp + 4
proc seekFile_PROC
	initBasicProc 0

	mov bx, [SF_FileHandle_VAR]
	mov al, [SF_Origin_Of_Move_VAR]
	mov cx, [SF_Low_Offset_VAR]
	mov dx, [SF_High_Offset_VAR]
	mov ah, 42h
	int 21h

	endBasicProc 0
	ret 8
endp seekFile_PROC

macro writeToFile WTFUL_FileHandle_PARAM, WTFUL_BytesToWrite_PARAM, WTFUL_DataToWrite_PARAM
	pushAll

	push WTFUL_FileHandle_PARAM
	push WTFUL_BytesToWrite_PARAM
	push offset WTFUL_DataToWrite_PARAM
	call writeToFile_PROC

	popAll
endm writeToFile

WTFUL_FileHandle_VAR equ bp + 8
WTFUL_BytesToWrite_VAR equ bp + 6
WTFUL_DataToWrite_VAR equ bp + 4
proc writeToFile_PROC
	initBasicProc 0

	mov bx, [WTFUL_FileHandle_VAR] 
	mov cx, [WTFUL_BytesToWrite_VAR]  
	mov dx, [WTFUL_DataToWrite_VAR]
	mov ah, 40h 
	int 21h 
	
	jc WTFUL_Error_LABEL
	jmp WTFUL_Exit_LABEL

	WTFUL_Error_LABEL:
		printChar 'E'
		jmp WTFUL_Exit_LABEL
	
	WTFUL_Exit_LABEL:
		endBasicProc 0
		ret 6
endp writeToFile_PROC


;===== Custom reset file pointer macro =====
macro resetCurrentReadFilePointer
	seekFile [currentReadFileHandle], 0, 0, 0
endm resetCurrentReadFilePointer

;===== Checks if a file exists =====
macro validateFile VF_FileName_PARAM
	
	push offset VF_FileName_PARAM
	call validateFile_PROC
endm validateFile

VF_FileNameOffset_VAR equ bp + 4
proc validateFile_PROC
	initBasicProc 0

	mov al, 0
	mov dx, [VF_FileNameOffset_VAR]
	mov ah, 3dh
	int 21h 
	
	jc VF_ReturnFalse_LABEL
	jnc VF_ReturnTrue_LABEL

	VF_ReturnFalse_LABEL:
		setBoolFlag [false]
		jmp VF_Exit_LABEL

	VF_ReturnTrue_LABEL:
		closeFile ax

		setBoolFlag [true]
		jmp VF_Exit_LABEL
	
	VF_Exit_LABEL:
	endBasicProc 0
	ret 2
endp validateFile_PROC