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
	endBasicProc 0
	jmp OF_End_LABEL
	
OF_Error_LABEL:
	printChar 'E'
	endBasicProc 0
	jmp OF_End_LABEL
	
OF_End_LABEL:
	ret 4
endp openFile_PROC

;===== Writes into an open file =====
macro writeToFile WTF_FileHandle_PARAM, WTF_DataToWrite_PARAM

	push bx
	push cx
	push dx
	push di
	push si

	push WTF_FileHandle_PARAM
	push offset WTF_DataToWrite_PARAM
	call writeToFile_PROC

	pop si
	pop di
	pop dx
	pop cx
	pop bx
	
endm

WTF_FileHandle_VAR equ [bp + 6]
WTF_DataToWriteOffset_VAR equ [bp + 4]
WTF_CharsCounter_VAR equ [bp - 2]
proc writeToFile_PROC

	initBasicProc 2 ;prepares to run the procedure
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
	mov WTF_CharsCounter_VAR, ax ;moves the actual char number (without dollar) into the local variable
	
	mov bx, WTF_FileHandle_VAR ;feeds the file handle to the write interrupt
	mov cx, WTF_CharsCounter_VAR ;feeds the number of chars to write to the write interrupt
	mov dx, WTF_DataToWriteOffset_VAR ;feeds the starting offset to write to the write interrupt
	mov ah, 40h ;prepares to run by "selecting the interrupt"
	int 21h ;calls the chosen interrupt
	
	mov ax, WTF_CharsCounter_VAR ;passes the number of written chars via ax.
	endBasicProc 2 ;cleans up using the library
	ret 4 ;returns to the rest of the runtime code
	
endp writeToFile_PROC

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

;===== Custom reset file pointer macro =====
macro resetCurrentFilePointer
	seekFile [currentFileHandle], 0, 0, 0
endm resetCurrentFilePointer