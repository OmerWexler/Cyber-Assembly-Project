;=========  MACROS ========== STABLE, NO DOC
macro SwitchGraphicsMode SGM_DesiredMode_PARAM
	
	InitFunction
	
	push SGM_DesiredMode_PARAM
	call SwitchGraphicsMode_PROC

	EndFunction
endm

macro SetPixel SP_Color_PARAM, SP_PixelX_PARAM, SP_PixelY_PARAM

	InitFunction
	push SP_Color_PARAM
	push SP_PixelX_PARAM
	push SP_PixelY_PARAM
	call SetPixel_PROC
	EndFunction

endm

macro GetPixel GP_PixelX_PARAM, GP_PixelY_PARAM

	InitFunction
	push GP_PixelX_PARAM
	push GP_PixelY_PARAM
	call GetPixel_PROC
	EndFunction

endm

macro GetPixelIntoVar GPIV_PixelX_PARAM, GPIV_PixelY_PARAM, GPIV_Var_PARAM

	InitFunction
	push GPIV_PixelX_PARAM
	push GPIV_PixelY_PARAM
	call GetPixel_PROC
	mov [GPIV_Var_PARAM], al
	EndFunction

endm

	
;=========== PROCEDURES =========== STABLE, NO DOC
;===== Set Graphics Mode =====
SGM_DesiredMode_VAR equ [bp + 4]
PROC SwitchGraphicsMode_PROC
	
	InitBasicProc 0
	
	mov ah, SGM_DesiredMode_VAR 
	
	cmp ah, 'g'
	je SGM_SwitchToGraphicMode_LABEL
	
	cmp ah, 't'
	je SGM_SwitchToTextMode_LABEL
	
SGM_SwitchToTextMode_LABEL:
	mov al, 03h
	jmp SGM_Finish_LABEL
	
SGM_SwitchToGraphicMode_LABEL:
	mov al, 13h
	jmp SGM_Finish_LABEL
	
SGM_Finish_LABEL:

	mov ah, 0
	INT 10h
	
	EndBasicProc 0
	ret 2
	
ENDP SwitchGraphicsMode_PROC
;----------------------------------------------------------------------------------------------

;===== Set Pixel =====
SP_Color_VAR equ [bp + 8]
SP_PixelX_VAR equ [bp + 6]
SP_PixelY_VAR equ [bp + 4]
proc SetPixel_PROC

	InitBasicProc 0
	
	mov al, SP_Color_VAR
	mov dx, SP_PixelY_VAR
	mov cx, SP_PixelX_VAR
	mov ah, 0ch
	int 10h
	
	EndBasicProc 0
	ret 6
endp SetPixel_PROC

;===== Get Pixel =====
GP_PixelX_VAR equ [bp + 6]
GP_PixelY_VAR equ [bp + 4]
proc GetPixel_PROC
	
	InitBasicProc 0
	
	mov cx, GP_PixelX_VAR
	mov dx, GP_PixelY_VAR
	mov ah, 0dh
	int 10h
	
	EndBasicProc 0 
	ret 4
endp GetPixel_PROC

PBMPS_BMP_Name_Offset_VAR equ [bp + 8]	
PBMPS_X_Start_Pos_VAR equ [bp + 6]
PBMPS_Y_Start_Pos_VAR equ [bp + 4]
proc PrintBMPSquare_PROC
	
	InitBasicProc 4
	
	mov ah, 3Dh
	xor al, al
	mov dx, PBMPS_BMP_Name_Offset_VAR
	int 21h
	
	jc openerror
	mov [PBMPS_BMPFileHandle], ax

openerror:
	mov dx, offset PBMPS_Error_Msg
	mov ah, 9h
	int 21h
	
	
	
	EndBasicProc 4
	ret
endp PrintBMPSquare_PROC


PBMPS_BMP_Name_VAR equ [bp + 4]	
proc PrintBMPFullScreen_PROC
	
	InitBasicProc 0
	
	
	EndBasicProc 0
	ret
endp PrintBMPSquare_PROC	

    ; Process BMP file
    ;call OpenFile
    ;call ReadHeader
    ;call ReadPalette
    ;call CopyPal
    ;call CopyBitmap






proc OpenFile

    ; Open file

    mov ah, 3Dh
    xor al, al
    mov dx, offset filename
    int 21h

    jc openerror
    mov [filehandle], ax
    ret

    openerror:
    mov dx, offset ErrorMsg
    mov ah, 9h
    int 21h
	
	mov ah,3fh
	mov bx, [filehandle]
	mov cx,54
	mov dx,offset Header
	int 21h 

    ret
endp OpenFile
proc ReadHeader

    ; Read BMP file header, 54 bytes

    mov ah,3fh
    mov bx, [filehandle]
    mov cx,54
    mov dx,offset Header
    int 21h
    ret
    endp ReadHeader
    proc ReadPalette

    ; Read BMP file color palette, 256 colors * 4 bytes (400h)

    mov ah,3fh
    mov cx,400h
    mov dx,offset Palette
    int 21h
    ret
endp ReadPalette
proc CopyPal

    ; Copy the colors palette to the video memory
    ; The number of the first color should be sent to port 3C8h
    ; The palette is sent to port 3C9h

    mov si,offset Palette
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
    mov al,[si] ; Get blue value.
    shr al,2
    out dx,al ; Send it.
    add si,4 ; Point to next color.

    ; (There is a null chr. after every color.)

    loop PalLoop
    ret
endp CopyPal

proc CopyBitmap

    ; BMP graphics are saved upside-down.
    ; Read the graphic line by line (200 lines in VGA format),
    ; displaying the lines from bottom to top.

    mov ax, 0A000h
    mov es, ax
    mov cx,200
    PrintBMPLoop:
    push cx

    ; di = cx*320, point to the correct screen line

    mov di,cx
    shl cx,6
    shl di,8
    add di,cx

    ; Read one line

    mov ah,3fh
    mov cx,320
    mov dx,offset ScrLine
    int 21h

    ; Copy one line into video memory

    cld 

    ; Clear direction flag, for movsb

    mov cx,320
    mov si,offset ScrLine
    rep movsb 

    ; Copy line to the screen
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