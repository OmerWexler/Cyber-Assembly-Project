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

;===== Prints the current bmp picture in name buffer =====
macro printBMP
	validateNextScreen
	call OpenBMP   
	call ReadHeader
	call ReadPalette
	call CopyPal
	hideMouse
	call CopyBitmap
	showMouse
	call CloseBMP
endm 
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
x equ [word ptr bp + 4]
y equ [word ptr bp + 6]
w equ [word ptr bp + 8]
h equ [word ptr bp + 10]
proc CopyBitmapForPrintByPosition	
	push bp
	mov bp, sp 
	;same code as CopyBitmap except the x,y positions 
	;specifies res for (h * w) for any pic
	mov ax, 0A000h
	mov es, ax
	mov cx, h
	PositionPrintBMPLoop:
	push cx
	add cx, y ;y
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di, x ; x
	mov ah,3fh
	mov cx, w
	mov dx,offset PBMP_ScrLine
	int 21h
	cld 
	mov cx, w
	mov si,offset PBMP_ScrLine
	rep movsb 
	pop cx
	loop PositionPrintBMPLoop
	pop bp
	ret 8
endp CopyBitmapForPrintByPosition