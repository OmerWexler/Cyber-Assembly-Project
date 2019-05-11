;=========== MACROS ===========
macro printBMP PBMP_Name
	
	
	push offset PBMP_Name
	call PBMP_openFile_PROC
	call PBMP_ReadHeader_PROC
	call PBMP_ReadPalette_PROC
	call PBMP_CopyPal_PROC
	call PBMP_CopyBitmap_PROC
	
	
endm

macro SwitchGraphicsMode SGM_DesiredMode_PARAM
	
	push SGM_DesiredMode_PARAM
	call SwitchGraphicsMode_PROC
	
endm

macro ClearScreen 
	
	call ClearScreen_PROC
	
endm


;=========== PROCEDURES ==========
proc ClearScreen_PROC

	initBasicProc 0
	
	mov ax, 13h
	INT 10h
	
	endBasicProc 0
	ret
	
endp ClearScreen_PROC

SGM_DesiredMode_VAR equ [bp + 4]
PROC SwitchGraphicsMode_PROC
	
	initBasicProc 0
	
	mov ah, SGM_DesiredMode_VAR 
	
	cmp ah, 'g'
	je SGM_SwitchToGraphicMode_LABEL
	
	cmp ah, 't'
	je SGM_SwitchToTextMode_LABEL
	
SGM_SwitchToTextMode_LABEL:
	mov ax, 03h
	jmp SGM_Finish_LABEL
	
SGM_SwitchToGraphicMode_LABEL:
	mov ax, 13h
	jmp SGM_Finish_LABEL
	
SGM_Finish_LABEL:

	mov ah, 0
	INT 10h
	
	endBasicProc 0
	ret 2
	
ENDP SwitchGraphicsMode_PROC


OP_NameOffset_VAR equ [bp + 4]
proc PBMP_openFile_PROC
	initBasicProc 2

	mov ah, 3Dh
	xor al, al
	mov dx, OP_NameOffset_VAR
	int 21h
	
	jc OP_OpenError_LABEL
	mov [PBMP_TempHandle], ax
	jmp OP_End_LABEL
	
OP_OpenError_LABEL:
	mov dx, offset PBMP_ErrorMsg
	mov ah, 9h
	int 21h
	
OP_End_LABEL:
	endBasicProc 2
	ret 2
	
endp PBMP_openFile_PROC


proc PBMP_ReadHeader_PROC
	initBasicProc 0

	mov ah, 3fh
	mov bx, [PBMP_TempHandle]
	mov cx, 54
	mov dx, offset PBMP_TempHeader
	int 21h
	
	endBasicProc 0
	ret 0
endp PBMP_ReadHeader_PROC

proc PBMP_ReadPalette_PROC
	initBasicProc 0
	
	mov ah, 3fh
	mov cx, 400h
	mov dx, offset PBMP_TempPallete
	int 21h
	
	endBasicProc 0
	ret 0
endp PBMP_ReadPalette_PROC


proc PBMP_CopyPal_PROC
	; Copy the colors palette to the video memory
	; The number of the first color should be sent to port 3C8h
	; The palette is sent to port 3C9h
	initBasicProc 0
	
	mov si,	offset PBMP_TempPallete
	mov cx,	256
	mov dx,	3C8h
	mov al, 0
	; Copy starting color to port 3C8h
	out dx, al
	; Copy palette itself to port 3C9h
	inc dx
	PalLoop:
	; Note: Colors in a BMP file are saved as BGR values rather than RGB.
	mov al, [si + 2] ; Get red value.
	shr al, 2 ; Max. is 255, but video palette maximal
	; value is 63. Therefore dividing by 4.
	out dx, al ; Send it.
	mov al, [si+1] ; Get green value.
	shr al, 2
	out dx, al ; Send it.
	mov al, [si] ; Get blue value.
	shr al, 2
	out dx, al ; Send it.
	add si, 4 ; Point to next color.
	; (There is a null chr. after every color.)
	loop PalLoop
	
	endBasicProc 0
	ret
endp PBMP_CopyPal_PROC


proc PBMP_CopyBitmap_PROC
	; BMP graphics are saved upside-down.
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	mov ax, 0A000h
	mov es, ax
	mov cx, SCREEN_HEIGHT
	
printBMPLoop:
	push cx
	; di = cx * Width, point to the correct screen line
	mov di, cx
	shl cx, 6
	shl di, 8
	add di,	cx
	; Read one line
	mov ah, 3fh
	mov cx, SCREEN_WIDTH
	mov dx, offset PBMP_ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx, SCREEN_WIDTH
	mov si, offset PBMP_ScrLine
	rep movsb ; Copy line to the screen
	 ;rep movsb is same as the following code:
	 ;mov es:di, ds:si
	 ;inc si
	 ;inc di
	 ;dec cx
     ;loop until cx=0
	pop cx
	loop printBMPLoop
	
	ret
endp PBMP_CopyBitmap_PROC