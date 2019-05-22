;===== Read from keyboard buffer =====
macro waitForKeyboardInput
    
    ;clear buffer
    mov ah, 0Ch
    mov al, 0d
    int 21h

    ;wait for key
    mov ah, 1d
    int 21h
    
    xor ah, ah

endm waitForKeyboardInput

;===== Read one character from the keyboard buffer (no delay, no wait, no echo) and retuns if the buffer was read from =====
macro readCharacterFromKeyboard 

    call readCharacterFromKeyboard_PROC

endm readCharacterFromKeyboard

proc readCharacterFromKeyboard_PROC
        
    mov ah, 06h
    mov dl, 255
    int 21h
    
    mov ah, 00d

    jnz RCFK_ReturnTrue_LABEL
    jz RCFK_ReturnFalse_LABEL

    RCFK_ReturnFalse_LABEL:
        setBoolFlag [false]
        jmp RCFK_Exit_LABEL        

    RCFK_ReturnTrue_LABEL:
        setBoolFlag [true]
        jmp RCFK_Exit_LABEL

    RCFK_Exit_LABEL:
    ret 0
endp readCharacterFromKeyboard_PROC

;===== Read a string until enter is pressed =====
macro readStringFromKeyboard RSFK_ReadTarget_PARAM, RSFK_StopAscii_PARAM, RSFK_LengthLimit_PARAM

    push 0000d ;reserve room for return value
    push RSFK_LengthLimit_PARAM
    push RSFK_StopAscii_PARAM
    push offset RSFK_ReadTarget_PARAM
    call readStringFromKeyboard_PROC
    
endm readStringFromKeyboard

RSFK_CharacterRead_VAR equ bp + 10
RSFK_LengthLimit_VAR equ bp + 8
RSFK_StopAscii_VAR equ bp + 6
RSFK_ReadTargetOffset_VAR equ bp + 4
proc readStringFromKeyboard_PROC
    initBasicProc 0
    
    mov di, [RSFK_ReadTargetOffset_VAR]

    RSFK_ReadLoop_LABEL:
        xor ax, ax
        waitForKeyboardInput

        mov dx, [RSFK_StopAscii_VAR] 
        compare ax, '==', dx
        checkBoolean [boolFlag], RSFK_Exit_LABEL, RSFK_MoveIntoDest_LABEL

        RSFK_MoveIntoDest_LABEL:
            mov [byte ptr di], al
            inc di

            mov ax, [RSFK_CharacterRead_VAR]
            inc ax
            mov [RSFK_CharacterRead_VAR], ax

            mov dx, [RSFK_LengthLimit_VAR]
            compare ax, '==', dx
            checkBoolean [boolFlag], RSFK_Exit_LABEL, RSFK_ReadLoop_LABEL

    RSFK_Exit_LABEL:
        endBasicProc 0
        ret 6
endp readStringFromKeyboard_PROC

;===== Reads one character from the keyboard buffer (if available), and copies it into a given var
macro readStringFromKeyboardITER RKC_VarToInsertInto_PARAM, RKC_OffsetFromStart_PARAM
    
    push 0000d ;allocate room for retur value
    push RKC_OffsetFromStart_PARAM
    push offset RKC_VarToInsertInto_PARAM
    call readStringFromKeyboardITER_PROC

endm readStringFromKeyboardITER

RKC_NewOffsetToReturn equ bp + 8
RKC_OffsetFromStart_VAR equ bp + 6
RKC_OffsetToInsertInto_VAR equ bp + 4
proc readStringFromKeyboardITER_PROC
    initBasicProc 0
    
    xor ax, ax

    mov di, [RKC_OffsetToInsertInto_VAR]
    add di, [RKC_OffsetFromStart_VAR]

    readCharacterFromKeyboard
    checkBoolean [boolFlag], RKC_CharacterReadSuccesfuly_LABEL, RKC_Exit_LABEL

    RKC_CharacterReadSuccesfuly_LABEL:
        compare ax, '==', Ascii_Backspace
        checkBoolean [boolFlag], RKC_BackSpace_LABEL, RKC_CheckEnter_LABEL
        
        RKC_CheckEnter_LABEL:
            compare ax, '==', Ascii_Enter
            checkBoolean [boolFlag], RKC_ReturnEndOfString_LABEL, RKC_InsertChar_LABEL

            RKC_InsertChar_LABEL:
                mov [byte ptr di], al
                inc di

                jmp RKC_ReturnNotEndOfString_LABEL

        RKC_BackSpace_LABEL:
            compare di, '==', 0d
            checkBoolean [boolFlag], RKC_RemoveCharacter_LABEL, RKC_DecIndex_LABEL

            RKC_DecIndex_LABEL:
                dec di
                jmp RKC_RemoveCharacter_LABEL
            
            RKC_RemoveCharacter_LABEL:
                mov al, 00d
                mov [byte ptr di], al
            
            jmp RKC_ReturnNotEndOfString_LABEL

    RKC_ReturnEndOfString_LABEL:
        setBoolFlag [true]
        jmp RKC_Exit_LABEL
                
    RKC_ReturnNotEndOfString_LABEL:
        setBoolFlag [false]
        jmp RKC_Exit_LABEL
                
    RKC_Exit_LABEL:
        sub di, [RKC_OffsetToInsertInto_VAR]
        mov [RKC_NewOffsetToReturn], di

        endBasicProc 0
        ret 4
endp readStringFromKeyboardITER_PROC

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