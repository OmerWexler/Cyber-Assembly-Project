;===== Read from keyboard buffer =====
macro waitForKeyboardInput
    
	;wait for key
    mov ah, 0Ch
    mov al, 0d
    int 21h

    mov ah, 1d
    int 21h
    
    xor ah, ah

endm waitForKeyboardInput

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