;===== Switch graphics mode ('t' pt 'g') =====
macro switchGraphicsMode SGM_DesiredMode_PARAM
	
	push SGM_DesiredMode_PARAM
	call switchGraphicsMode_PROC
	
endm

SGM_DesiredMode_VAR equ [bp + 4]
proc switchGraphicsMode_PROC
	
	initBasicProc 0
	
	mov ah, SGM_DesiredMode_VAR 
	
	cmp ah, Ascii_g
	je SGM_SwitchToGraphicMode_LABEL
	
	cmp ah, Ascii_t
	je SGM_SwitchToTextMode_LABEL
	
	SGM_SwitchToTextMode_LABEL:
		mov ax, 03h
		int 10h

		jmp SGM_Finish_LABEL
		
	SGM_SwitchToGraphicMode_LABEL:
		mov ax, 13h
		int 10h

		jmp SGM_Finish_LABEL
		
	SGM_Finish_LABEL:
		endBasicProc 0
		ret 2
endp switchGraphicsMode_PROC

;===== Prints a BMP photo at a given location ===== 
macro printBMP PBMP_Name_PARAM, PBMP_X_PARAM, PBMP_Y_PARAM, PBMP_ColorToFilter
	
	push PBMP_X_PARAM
	push PBMP_Y_PARAM

	openFile PBMP_Name_PARAM, PBMP_TempHandle 'r'
	call ReadHeader
	call ReadPalette
	call CopyPal
	
	pop dx
	pop cx
	
	push PBMP_ColorToFilter
	push cx
	push dx

	call CopyBitmapForPrintByPosition
		
	closeFile [PBMP_TempHandle]

endm printBMP

;===== Uses the CopyBitmapForPrintByPosition in order to print a character on screen =====
macro printBMPCharacter PBC_Character_PARAM, PBC_X_PARAM, PBC_Y_PARAM

	push PBC_Character_PARAM
	push PBC_X_PARAM
	push PBC_Y_PARAM
	call printBMPCharacter_PROC

endm printBMPCharacter

PBC_Character_VAR equ bp + 8
PBC_X_VAR equ bp + 6
PBC_Y_VAR equ bp + 4
proc printBMPCharacter_PROC
	initBasicProc 0

	xor ax, ax
	mov ax, [PBC_Character_VAR]

	mov al, [PBC_Character_VAR]
	mov [byte ptr BMP_CharBMPBuffer], al

	checkIfBetween ax, Ascii_CA, Ascii_CZ
	checkBoolean [boolFlag], PBC_PrintCapital, PBC_PrintRegular

	PBC_PrintCapital:
		mov al, 'C'
		mov [byte ptr BMP_CharBMPBuffer + 1d], al 
		jmp PBC_StartPrePrint_LABEL

	PBC_PrintRegular:
		compare ax, '==', '.'
		checkBooleanSingleJump [boolFlag], PBC_PrintDot

		mov al, '0'
		mov [byte ptr BMP_CharBMPBuffer + 1d], al
		jmp PBC_StartPrePrint_LABEL

		PBC_PrintDot:
			mov [word ptr BMP_CharBMPBuffer], 'OD'
			jmp PBC_StartPrePrint_LABEL


	PBC_StartPrePrint_LABEL:
		validateFile BMP_CharBMPBuffer
		xor [boolFlag], 01d
		checkBooleanSingleJump [boolFlag], PBC_Exit_LABEL

		mov cx, [PBC_X_VAR]
		mov dx, [PBC_Y_VAR]
		printBMP BMP_CharBMPBuffer, cx, dx, 255

		showMouse
		closeFile [PBMP_TempHandle]

	PBC_Exit_LABEL:
		endBasicProc 0
		ret 6
endp printBMPCharacter_PROC

;===== Prints the current bmp picture in name buffer =====
macro printScreen
	call printScreen_PROC
endm 

proc printScreen_PROC
	initBasicProc 0

	validateFile nextScreen
	checkBoolean [boolFlag], PBMP_Filevalid_LABEL, PBMP_FileInvalid_LABEL
	
	PBMP_Filevalid_LABEL:
		copyString currentScreen, nextScreen

		printBMP currentScreen, 0, 0, 'N'

	PBMP_FileInvalid_LABEL:
		copyString nextScreen, currentScreen

		endBasicProc 0
		ret 0
endp printScreen_PROC

;===== Reads the header from the bmp file and allocate all the critical variables using it (e.g width. height) =====
proc ReadHeader
	; Read BMP file header, 54 bytes
	mov ah,3fh
	mov bx, [PBMP_TempHandle]
	mov cx,54
	mov dx,offset PBMP_TempHeader
	int 21h
	
	mov bx,offset PBMP_TempHeader
	add bx,18
	mov ax,[word ptr bx]
	mov [PBMP_Width],ax
	add bx,4
	mov ax,[word ptr bx]
	mov [PBMP_Height],ax
	
	mov bl,4
	mov ax,[PBMP_Width]
	div bl
	mov al,4
	sub al,ah
	mov ah,0
	mov [PBMP_Padding],ax
	ret
endp ReadHeader

;===== Reads the color palette from the current BMP File ===== 
proc ReadPalette
	; Read BMP file color palette, 256 colors * 4 bytes (400h)
	mov ah,3fh
	mov bx, [PBMP_TempHandle]
	mov cx,400h
	mov dx,offset PBMP_TempPallete
	int 21h
	ret
endp ReadPalette 

;===== Copies the palette from the buffer into the graphic memory ===== 
proc CopyPal
	; Copy the colors palette to the video memory
	; The number of the first color should be sent to port 3C8h
	; The palette is sent to port 3C9h
	mov si,offset PBMP_TempPallete
	mov cx,256
	mov dx,3C8h
	mov al,0
	; Copy starting color to port 3C8h
	out dx,al
	; Copy palette itself to port 3C9h 
	inc dx
	
	PalLoop:
	; Note: Colors in a BMP file are saved as BGR values rather than RGB.
		
		mov al,[si+2] ; Get red value.
		shr al,2 ; Max. is 255, but video palette maximal
		; value is 63. Therefore dividing by 4.
		out dx,al ; Send it.
		
		mov al,[si+1] ; Get green value.
		shr al,2
		out dx,al ; Send it.
		
		mov al,[si] ; Get blue value
		shr al,2
		out dx,al ; Send it.
		
		add si,4 ; Point to next color (There is a null chr. after every color.)
		loop PalLoop
	ret
endp CopyPal

CBMPP_ColorToFilter_VAR equ bp + 8
CBMPP_x_VAR equ bp + 6
CBMPP_y_VAR equ bp + 4
proc CopyBitmapForPrintByPosition	
	initBasicProc 0
	mov ax, 0A000h
	mov es, ax
	mov cx, [PBMP_Height]

	PrintBMPLoopA:
		push cx
		dec cx

		; di = cx*320, point to the correct screen line
		add cx, [CBMPP_y_VAR]
		mov di, cx
		shl cx, 6
		shl di, 8
		add di, cx
		add di, [CBMPP_x_VAR]
		
		; Read one line
		mov ah, 3fh
		mov cx, [PBMP_Width]
		mov dx, offset PBMP_ScrLine
		int 21h

		;clear trash
		cmp [PBMP_Padding], 4
		je CBMPP_PrintOnScreen_LABEL
		
		mov ah, 3fh
		mov cx, [PBMP_Padding]
		mov dx, offset PBMP_TrashPadding
		int 21h
	CBMPP_PrintOnScreen_LABEL:
		hideMouse

		mov ax, [CBMPP_ColorToFilter_VAR]
		cmp ax, 'N'
		je CBMPP_QuickPrint_LABEL
		jne CBMMP_FilterColor_LABEL

		CBMPP_QuickPrint_LABEL:
			
			cld
			mov cx,[PBMP_Width]
			mov si,offset PBMP_ScrLine
			rep movsb

			jmp CBMMP_RunNextLine

		CBMMP_FilterColor_LABEL:
			cld

			mov cx, [PBMP_Width]
			mov si, offset PBMP_ScrLine
			CBMPP_PrintLineLoop_LABEL:
	
				xor ax, ax
				mov al, [byte ptr si]
				cmp ax, [CBMPP_ColorToFilter_VAR]

				je CBMPP_SkipCopy_LABEL

					movsb
					jmp CBMPP_ContinueFilterLoop

				CBMPP_SkipCopy_LABEL:
					inc si
					inc di

					jmp CBMPP_ContinueFilterLoop
				
				CBMPP_ContinueFilterLoop:
					loop CBMPP_PrintLineLoop_LABEL

		CBMMP_RunNextLine:
			showMouse

			pop cx
			loop PrintBMPLoopA

	endBasicProc 0
	ret 6
endp CopyBitmapForPrintByPosition

;===== Prints a string to the screen using BMP characters (at a given XY) =====
macro printString PS_StringToPrint_PARAM, PS_X_PARAM, PS_Y_PARAM

	mov [stringOffset], offset PS_StringToPrint_PARAM 
	mov [stringX], PS_X_PARAM
	mov [stringY], PS_Y_PARAM

	push offset PS_StringToPrint_PARAM
	push PS_X_PARAM
	push PS_Y_PARAM
	call printString_PROC

endm printString

PS_StringToPrintOffset_VAR equ bp + 8
PS_X_VAR equ bp + 6
PS_Y_VAR equ bp + 4
proc printString_PROC
	initBasicProc 0	
	
	checkBoolean [isStringBuffingAllowed], PS_AllowPrint_LABEL, PS_Exit_LABEL

	jmp PS_Exit_LABEL

	PS_AllowPrint_LABEL:
	mov si, [PS_StringToPrintOffset_VAR]

	PS_PrintLoop_LABEL:
		xor ax, ax
		mov al, [si]
		inc si

		compare ax, '==', 0d
		checkBooleanSingleJump [boolFlag], PS_Exit_LABEL
		
		push si

		mov cx, [PS_X_VAR]
		mov dx, [PS_Y_VAR]
		printBMPCharacter ax, cx, dx

		mov ax, [PBMP_Width]
		inc ax
		add [PS_X_VAR], ax

		pop si
	
		jmp PS_PrintLoop_LABEL

	PS_Exit_LABEL:
	endBasicProc 0
	ret 6
endp printString_PROC

;===== Sets the string buffering boolean to a given value =====
macro enableStringBuffering ESB_IsAllowed_PARAM
	
	mov al, ESB_IsAllowed_PARAM
	mov [isStringBuffingAllowed], al

endm enableStringBuffering