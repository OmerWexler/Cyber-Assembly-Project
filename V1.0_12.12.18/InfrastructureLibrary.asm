;===========MACROS===========
macro IntProc_MAC IP_SpOffset_PARAM
	push bp
	mov bp, sp
	sub sp, IP_SpOffset_PARAM

	push ax
	push bx
	push cx
	push dx
	push di
	push si
	
endm

macro EndProc_MAC EP_SpOffset_PARAM
	
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	add sp, EP_SpOffset_PARAM
	ret
endm

macro CreateFile_MAC CF_FileName_PARAM, CF_FileHandleOffset_PARAM 
	push ax
	
	push offset CF_FileName_PARAM
	push offset CF_FileHandleOffset_PARAM
	call CreateFile_PROC
	
	pop ax
endm	



;===========PROCEDURES==========
;=====Creates a file with the inserted parameters=====
CF_FileName_VAR equ [bp + 6]
CF_FileHandleOffset_VAR equ [bp + 4]
proc CreateFile_PROC
	
	IntProc_MAC 0
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
	
	mov dx, offset FileErrorOpening 
	mov ah, 9h
	int 21h
	
	finishCreatFile:
	EndProc_MAC 0
	
endp CreateFile_PROC
;-----------------------------------------------------



;=====Clears the screen=====
proc ClearScreen
	push offset clearBoardLoop
	call print 

	ret
endp ClearScreen
;---------------------------

; =====Basic wait for any key function=====
proc	WaitForInput

		mov ah, 0h	
		int 16h

		ret
		
endp	WaitForInput
;------------------------------------------
; =====test=====
X_Loc equ [bp + 6] 
Y_Loc equ [bp + 4]
Temp_X_Loc equ [bp - 2]
currentCell equ [foodPattern + di]
proc DrawFoodTest
	
	push bp
	mov bp, sp
	sub sp, 2
	
	push di
	push ax
	
	xor di, di
	mov ax, X_Loc
	mov Temp_X_Loc, ax
	drawfoodloop:
		
		cmp currentCell, 'D'
		je cellDown
		
		cmp currentCell, '$'
		je finish1
		
		
		mov al, currentCell
		mov bh, 0h
		mov cx, X_Loc
		mov dx, Y_Loc
		
		mov ah,0ch
		int 10h 
		
		mov ax, X_Loc
		inc ax
		mov X_Loc, ax
	
		inc di
		
		jmp drawfoodloop
		
	cellDown:
		
		mov ax, Temp_X_Loc
		mov X_Loc, ax
		
		mov ax, Y_Loc
		inc ax
		mov Y_Loc, ax	
		
		mov di, 0
		
		jmp drawfoodloop
		
	finish1:
		
		pop ax
		pop di	
		
		add sp, 2
		pop bp
		ret 4
endp DrawFoodTest
;------------------------------------------------------------------------
;=====Prints one segment of the snake using the starting position=====
X_Loc equ [bp + 6]
Y_Loc equ [bp + 4]
proc DrawFood
	
	push bp
	mov bp, sp 
	push ax
	push cx
	
	mov cx, 3h
	push X_Loc
	printheader:
		push cx
		
		mov ax, X_Loc
		inc ax
		mov X_Loc, ax
		
		mov al, 02h
		mov bh, 0h
		mov cx, X_Loc
		mov dx, Y_Loc
	
		mov ah,0ch
		int 10h 
		
		pop cx
	
	loop printheader
	
	pop X_Loc
	mov ax, Y_Loc
	inc ax
	mov Y_Loc, ax
	
	
	mov cx, 3h
	push Y_Loc
	printsegouter:
		push cx
		
		mov cx, 5h
		push X_Loc
		printseginner:	
		
			push cx
		
			mov al, 02h
			mov bh, 0h
			mov cx, X_Loc
			mov dx, Y_Loc
		
			mov ah,0ch
			int 10h 
		
			pop cx
		
			mov ax, X_Loc
			inc ax
			mov X_Loc, ax
		
		loop printseginner
		pop X_Loc
		
		mov ax, Y_Loc
		inc ax
		mov Y_Loc, ax
		
		pop cx
	loop printsegouter
	
	pop Y_Loc
	mov ax, Y_Loc
	add ax, 3d
	mov Y_Loc, ax
	
	
	mov cx, 3h
	push X_Loc
	printlower:
		push cx
		
		mov ax, X_Loc
		inc ax
		mov X_Loc, ax
		
		
		mov al, 02h
		mov bh, 0h
		mov cx, X_Loc
		mov dx, Y_Loc
	
		mov ah,0ch
		int 10h 
		
		pop cx
	
	loop printlower
	pop X_Loc
	
	
	pop bp	
	pop cx
	pop ax
	
	ret 4
endp DrawFood
;------------------------------------------------------------------------

; =====Sets the cursor position=====
X equ [bp + 6]
Y equ [bp + 4]
PROC SetCursorPos

	push bp
	mov bp, sp
	
	mov dl, X	; X
	mov dh, Y	; Y
	mov bh, 0  ; Page numbertlot
	
	mov ah, 2
	int 10h
	
	pop bp
	ret 4
ENDP SetCursorPos
;-----------------------------------


; =====Earases a character=====
proc EaraseCharacter

	mov ah, 9h
	mov al, 2
	mov bx, 0
	mov cx, 1h
	int 10h
	
	ret 
endp EaraseCharacter




; =====Prints from the address at the top of the stack=====
printableAdress equ [bp + 4]
PROC Print
	
	push bp
	mov bp, sp
	
	mov dx, printableAdress
	mov ah, 9h
	int 21h
	
	pop bp
	
	ret 2
	
ENDP Print
;----------------------------------------------------------

; =====Switching graphic modes. 1 for graphic, 0 for text (draws from the top of the stack)=====
status equ [bp + 4]

PROC IsInGraphicMode?
	
	push bp
	mov bp, sp
	
	push ax
	mov ax, status
	
	cmp ax, 1h
	je SwitchToGraphicMode
	
	cmp ax,00h
	je SwitchToTextMode
	
SwitchToTextMode:
	mov ax, 2h
	int 10h
	ret
	
SwitchToGraphicMode:
	mov ax, 13h
	INT 10h
	
	pop ax
	pop bp
	
	ret 2
	
ENDP IsInGraphicMode?
;----------------------------------------------------------------------------------------------

;=====Checks the status at the end of each move loop=====

PROC CheckStatus
	push ax

reCheck:	
	push 1h
	call SetCursorPos
	
	xor ax, ax
	
	call WaitForInput
	cmp ah, 11h
	JE moveUp
	
	cmp ah, 1Fh
	JE moveDown
	
	cmp ah, 1Eh
	JE moveLeft
	
	cmp ah, 20h
	JE moveRight
	
	cmp ah, 1h
	JE leavegame
	JNE reCheck
moveUp:
		dec [player_Y_Loc]
		jmp continue
moveDown:
		inc [player_Y_Loc]
		jmp continue
moveLeft:
		dec [player_X_Loc]
		jmp continue
moveRight:
		inc [player_X_Loc]
		jmp continue
		
continue:	
	push 1h
	call EaraseCharacter	
	push 1h
	call SetCursorPos
	
	push 100d
	push 100d
	call DrawFood
	jmp reCheck
	
leavegame:	
	mov ax, 4c00h
	int 21h
	
	pop ax
	ret
ENDP CheckStatus


