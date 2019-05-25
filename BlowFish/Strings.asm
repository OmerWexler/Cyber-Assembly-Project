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
        xor ax, ax
        mov al, [byte ptr si]
        compare ax,'==', 00d
        checkBooleanSingleJump [boolFlag], CS_ReturnCurrentState_LABEL 

        xor ax, ax
        xor dx, dx

        mov al, [byte ptr si]
        mov dl, [byte ptr di]

        xor al, dl
        jne CS_ReturnFalse_LABEL

        inc si
        inc di
        
        jmp CS_CompareLoop_LABEL

    CS_ReturnFalse_LABEL:
        setBoolFlag [false]
        jmp CS_Exit_LABEL

    CS_ReturnCurrentState_LABEL:
        setBoolFlag [true]
        jmp CS_Exit_LABEL

    CS_Exit_LABEL:
        endBasicProc 2
        ret 4
endp compareString_PROC

;===== Copies from one file name to another (including type) =====
macro copyString CFN_StringToCopyTo_PARAM, CFN_StringToCopyFrom_PARAM 
    pushAll

    push offset CFN_StringToCopyTo_PARAM
    push offset CFN_StringToCopyFrom_PARAM
    call copyString_PROC

    popAll
endm copyString

CFN_StringToCopyToOffset_VAR equ bp + 6
CFN_StringToCopyFromOffset_VAR equ bp + 4
proc copyString_PROC
    initBasicProc 0

    mov di, [CFN_StringToCopyToOffset_VAR]
    mov si, [CFN_StringToCopyFromOffset_VAR]
    xor ax, ax

    CFN_CopyLoop_LABEL:
        xor ax, ax
        
        mov al, [byte ptr si]
        mov [byte ptr di], al

        inc si
        inc di

        compare ax, '==', 0000d
        checkBoolean [boolFlag], CFN_Exit_LABEL, CFN_CopyLoop_LABEL



    CFN_Exit_LABEL:
    endBasicProc 0 
    ret 4
endp copyString_PROC

;===== Makes sure a string is fully valid =====
macro validateString VS_StringToValidate_PARAM, VS_IncludeDot_PARAM

    xor ax, ax
    mov al, VS_IncludeDot_PARAM
    push ax
    push offset VS_StringToValidate_PARAM
    call validateString_PROC
    
endm validateString

VS_IncludeDot_VAR equ bp + 6
VS_StringToValidateOffset_VAR equ bp + 4
proc validateString_PROC
    initBasicProc 0

    mov si, [VS_StringToValidateOffset_VAR]
    dec si

    VS_CompareLoop_LABEL:
        inc si

        xor ax, ax
        mov al, [byte ptr si]
        checkIfBetween ax, Ascii_A, Ascii_Z 
        checkBooleanSingleJump [boolFlag], VS_CompareLoop_LABEL
        
        xor ax, ax
        mov al, [byte ptr si]
        checkIfBetween ax, Ascii_CA, Ascii_CZ 
        checkBooleanSingleJump [boolFlag], VS_CompareLoop_LABEL
        
        xor ax, ax
        mov al, [byte ptr si]
        checkIfBetween ax, Ascii_0, Ascii_9 
        checkBooleanSingleJump [boolFlag], VS_CompareLoop_LABEL
        
        setBoolFlag [VS_IncludeDot_VAR]
        flipBoolFlag
        checkBooleanSingleJump [boolFlag], VS_SkipDotCheck_LABEL

        xor ax, ax
        mov al, [byte ptr si]
        compare ax, '==', Ascii_Dot 
        checkBooleanSingleJump [boolFlag], VS_CompareLoop_LABEL 

        VS_SkipDotCheck_LABEL:
            xor ax, ax
            mov al, [byte ptr si]
            compare ax, '!=', 00
            checkBooleanSingleJump [boolFlag], VS_ReturnFalse_LABEL
        
            mov di, [VS_StringToValidateOffset_VAR]
            compare si, '>', di
            checkBoolean [boolFlag], VS_ReturnTrue_LABEL, VS_ReturnFalse_LABEL

    VS_ReturnTrue_LABEL:
        setBoolFlag [true]
        jmp VS_Exit_LABEL

    VS_ReturnFalse_LABEL:
        setBoolFlag [false]
        jmp VS_Exit_LABEL

    VS_Exit_LABEL:
        endBasicProc 0
        ret 4
endp validateString_PROC 