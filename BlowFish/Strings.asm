;===== Checks if the two given strings are equal =====
macro compareStrings CS_String1_PARAM, CS_String2_PARAM

    push offset CS_String1_PARAM
    push offset CS_String2_PARAM
    call compareString_PROC
    
endm compareStrings

CS_String1Offset equ bp + 6
CS_String2Offset equ bp + 4
CS_IsEqual_VAR equ bp - 2
proc compareString_PROC
    initBasicProc 2

    mov si, [CS_String1Offset]
    mov di, [CS_String2Offset]

    CS_CompareLoop_LABEL:
        mov ax, [di]
        compare ax,'==', Ascii_0
        checkBooleanSingleJump [boolFlag], CS_ReturnCurrentState_LABEL 
        
        mov ax, [si]
        compare ax,'==', Ascii_0
        checkBooleanSingleJump [boolFlag], CS_ReturnCurrentState_LABEL 

        xor ax, ax
        xor dx, dx

        mov al, [byte ptr si]
        mov dl, [byte ptr di]
        compare ax, '==', dx
        getBoolFlag [CS_IsEqual_VAR]

        inc si
        inc di

        checkBoolean [boolFlag], CS_CompareLoop_LABEL, CS_ReturnFalse_LABEL

    CS_ReturnFalse_LABEL:
        setBoolFlag [false]
        jmp CS_Exit_LABEL

    CS_ReturnCurrentState_LABEL:
        setBoolFlag [CS_IsEqual_VAR]
        jmp CS_Exit_LABEL

    CS_Exit_LABEL:
        endBasicProc 2
        ret 4
endp compareString_PROC