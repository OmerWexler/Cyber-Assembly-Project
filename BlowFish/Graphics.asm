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

;===== Sets the BMP_CharBuffer to the requested name and print a character by an XY set =====
macro setBMPCharToPrint SBCT_CharToPrint_PARAM
	
	mov al, SBCT_CharToPrint_PARAM
	mov [byte ptr BMP_CharBMPBuffer + BMPChar], al

endm setBMPCharToPrint

;===== Uses the printBMPByPosition in order to print a character on screen =====
macro printBMPCharacter PBC_Character_PARAM, PBC_X_PARAM, PBC_Y_PARAM

	setBMPCharToPrint PBC_Character_PARAM
	printBMPByPosition BMP_CharBMPBuffer, PBC_X_PARAM, PBC_Y_PARAM, 7d, 12d
	
endm printBMPCharacter

;===== Prints the requested picture in the requested XY and RES, while removing all white pixels =====
macro printBMPByPosition PBMPBP_Name_PARAM, PBMPBP_X_PARAM, PBMPBP_Y_PARAM, PBMPBP_W_PARAM, PBMPBP_H_PARAM
	
	openFile PBMPBP_Name_PARAM, PBMP_TempHandle, 'r'
	call ReadHeader	
	call ReadPalette	
	call CopyPal
	
	hideMouse

	push PBMPBP_X_PARAM
	push PBMPBP_Y_PARAM
	push PBMPBP_W_PARAM
	push PBMPBP_H_PARAM
	call CopyBitmapForPrintByPosition
	
	showMouse
	call CloseBMP

endm printBMPByPosition

;===== Prints the current bmp picture in name buffer =====
macro printBMP
	call printBMP_PROC
endm 

proc printBMP_PROC
	initBasicProc 0

	validateFile nextScreen
	checkBoolean [boolFlag], PBMP_Filevalid_LABEL, PBMP_FileInvalid_LABEL
	
	PBMP_Filevalid_LABEL:
		copyFileName currentScreen, nextScreen
		call OpenBMP   
		call ReadHeader
		call ReadPalette
		call CopyPal
		hideMouse
		call CopyBitmap
		showMouse
		call CloseBMP

	PBMP_FileInvalid_LABEL:
		copyFileName nextScreen, currentScreen

		endBasicProc 0
		ret 0
endp printBMP_PROC
;---------------------------------------------------------------;
proc OpenBMP 
	mov ah, 3Dh    
	xor al, al
	mov dx, offset currentScreen
	int 21h
	mov [PBMP_TempHandle], ax
	ret
endp OpenBMP
;---------------------------------------------------------------;
proc ReadHeader
; Read BMP file header, 54 bytes
	mov ah,3fh
	mov bx, [PBMP_TempHandle]
	mov cx,54
	mov dx,offset PBMP_TempHeader
	int 21h
	ret
endp ReadHeader
;---------------------------------------------------------------;
proc ReadPalette
	; Read BMP file color palette, 256 colors * 4 bytes (400h)
	mov ah,3fh
	mov cx,400h
	mov dx,offset PBMP_TempPallete
	int 21h
	ret
endp ReadPalette 
;---------------------------------------------------------------;
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
	add si,4 ; Point to next color.
	 ; (There is a null chr. after every color.)
	 loop PalLoop
	ret
endp CopyPal
;---------------------------------------------------------------;
proc CopyBitmap
	; BMP graphics are saved upside-down.
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	mov ax, 0A000h
	mov es, ax
	mov cx, SCREEN_HEIGHT
	
PrintBMPLoop:
	push cx 
	; di = cx*320, point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	; Read one line
	mov ah,3fh
	mov cx,SCREEN_WIDTH
	mov dx,offset PBMP_ScrLine
	int 21h
	cld ; Clear direction flag, for movsb
	mov cx,SCREEN_WIDTH
	mov si,offset PBMP_ScrLine 
	; Copy one line into video memory
	rep movsb ; Copy line to the screen
	;rep movsb is same as the following code:
	;mov es:di, ds:si
	;inc si
	;inc di
	;dec cx
	;loop until cx=0
	pop cx
	loop PrintBMPLoop
	ret
endp CopyBitmap  
;---------------------------------------------------------------;
proc CloseBMP
	mov ah, 3Eh
	mov bx, [PBMP_TempHandle]
	int 21h
	ret
endp CloseBMP
;---------------------------------------------------------------;
CBMPP_x_VAR equ bp + 10
CBMPP_y_VAR equ bp + 8
CBMPP_w_VAR equ bp + 6
CBMPP_h_VAR equ bp + 4
proc CopyBitmapForPrintByPosition	
	push bp
	mov bp, sp 
	;same code as CopyBitmap except the x,y positions 
	;specifies res for (h * w) for any pic
	mov ax, 0A000h
	mov es, ax
	mov cx, [CBMPP_h_VAR]
	CBMPP_PositionPrintBMPLoop_LABEL:
	push cx
	add cx, [CBMPP_y_VAR] ;y
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di, [CBMPP_x_VAR] ; x
	
	mov cx, [CBMPP_w_VAR]
	inc cx
	mov ah,3fh
	mov dx,	offset PBMP_ScrLine
	int 21h

	cld 
	mov cx, [CBMPP_w_VAR]
	mov si,offset PBMP_ScrLine
		; rep movsb 
	CBMPP_PrintLineLoop_LABEL:
		mov al, [byte ptr si]
		cmp al, 230d
		ja CBMPP_SkipCopy_LABEL
		
		movsb
		jmp CBMPP_ContinueLoop_LABEL

		CBMPP_SkipCopy_LABEL:
			inc si
			inc di
			jmp CBMPP_ContinueLoop_LABEL

		CBMPP_ContinueLoop_LABEL:

		loop CBMPP_PrintLineLoop_LABEL

	pop cx
	loop CBMPP_PositionPrintBMPLoop_LABEL
	pop bp
	ret 8
endp CopyBitmapForPrintByPosition