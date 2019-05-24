;===== Read from keyboard buffer =====
macro waitForKeyboardInput
    
    clearKeyboardBuffer
    
    ;wait for key
    mov ah, 0h
    int 16h
    
    xor ah, ah

endm waitForKeyboardInput

;===== Clears the keyboard key buffer =====
macro clearKeyboardBuffer
    push ax
    
    mov ah, 0Ch
    mov al, 0d
    int 21h

    pop ax
endm clearKeyboardBuffer

;===== Read one character from the keyboard buffer (no delay, no wait, no echo) and retuns if the buffer was read from =====
macro readCharacterFromKeyboard

    push 0000d
    call readCharacterFromKeyboard_PROC

endm readCharacterFromKeyboard

RSFK_ReturnChar_VAR equ bp + 4
proc readCharacterFromKeyboard_PROC
    initBasicProc 0

    mov ah, 1h
    int 16h

    jnz RCFK_ReturnTrue_LABEL
    jz RCFK_ReturnFalse_LABEL

    RCFK_ReturnFalse_LABEL:
        setBoolFlag [false]
        jmp RCFK_Exit_LABEL        

    RCFK_ReturnTrue_LABEL:
        
        mov ah, 00h
        int 16h

        mov [RSFK_ReturnChar_VAR], ax

        setBoolFlag [true]
        jmp RCFK_Exit_LABEL

    RCFK_Exit_LABEL: 
        endBasicProc 0
        ret 0
endp readCharacterFromKeyboard_PROC

;===== Reads one character from the keyboard buffer (if available), and copies it into a given var =====
macro readStringFromKeyboardITER RKC_VarToInsertInto_PARAM, RKC_LengthLimit_PARAM

    push RKC_LengthLimit_PARAM
    push offset RKC_VarToInsertInto_PARAM
    call readStringFromKeyboardITER_PROC

endm readStringFromKeyboardITER

RKS_LengthLimit_VAR equ bp + 6
RKS_OffsetToInsertInto_VAR equ bp + 4
RKS_CharacterRead_VAR equ bp - 2
proc readStringFromKeyboardITER_PROC
    initBasicProc 2

    readCharacterFromKeyboard
    pop ax
    mov [RKS_CharacterRead_VAR], ax

    xor [boolFlag], 1d
    checkBooleanSingleJump [boolFlag], RKS_ReturnFalse_LABEL

    mov ax, [RKS_CharacterRead_VAR]
    mov ah, 00d
    compare ax, '==', Ascii_Backspace
    checkBoolean [boolFlag], RKS_RemoveChar_LABEL, RKS_WriteCharacter_LABEL

    RKS_WriteCharacter_LABEL:
        mov ax, [RKS_LengthLimit_VAR]
        dec ax
        compare [currentStringReadIndex], '>=', ax
        checkBooleanSingleJump [boolFlag], RKS_ReturnFalse_LABEL

        mov di, [RKS_OffsetToInsertInto_VAR]
        add di, [currentStringReadIndex]

        mov ax, [RKS_CharacterRead_VAR]
        mov [byte ptr di], al
        mov [byte ptr di + 1], 00d

        sub di, [RKS_OffsetToInsertInto_VAR]
        inc di
        mov [currentStringReadIndex], di

        jmp RKS_ReturnTrue_LABEL

    RKS_RemoveChar_LABEL:
        mov di, [RKS_OffsetToInsertInto_VAR]
        add di, [currentStringReadIndex]
        
        compare [currentStringReadIndex], '==', 0
        checkBooleanSingleJump [boolFlag], RKS_SkipDEC_LABEL

        dec di

        RKS_SkipDEC_LABEL:
            mov [byte ptr di], 00d
            
            sub di, [RKS_OffsetToInsertInto_VAR]
            mov [currentStringReadIndex], di

            jmp RKS_ReturnTrue_LABEL

    RKS_ReturnTrue_LABEL:
        setBoolFlag [true]
        jmp RKS_Exit_LABEL
    
    RKS_ReturnFalse_LABEL:
        setBoolFlag [false]
        jmp RKS_Exit_LABEL

    RKS_Exit_LABEL:
        endBasicProc 2
        ret 4
endp readStringFromKeyboardITER_PROC

macro resetStringReadIndex
    mov [currentStringReadIndex], 0000d
endm resetStringReadIndex
;===== hides the mouse from the user =====
macro hideMouse
    mov ax, 2
    int 33h 
endm hideMouse

;===== shows the mouse to the user =====
macro showMouse
    mov ax, 1
    int 33h
endm showMouse

;===== Starts the mouse pointer =====
macro initMouse 
    mov ax, 0h
    int 33h
endm initMouse

;===== Gets the location of the mouse and status of it's buttons =====
;=== It's a macro so it could work faster ===
macro readMouse

    push ax
    push bx
    push cx
    push dx

    xor bx, bx

    mov ax, 00003d
    int 33h

    mov [mouseY], dx
    mov [clickStatus], bx

    mov ax, cx
	mov dx, 0000d
	mov cx, 2d

	div cx
    mov [mouseX], ax
    
    pop dx
    pop cx
    pop bx
    pop ax

endm readMouse