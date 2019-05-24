;===== Checks a certain character for it's key =====
macro proccesCharacter character

    push character
    call proccesCharacter_PROC
    
endm proccesCharacter

CC_Char_VAR equ bp + 4
CC_NumberValid_VAR equ bp - 2
CC_LowerValid_VAR equ bp - 4
CC_CapitalValid_VAR equ bp - 6
proc proccesCharacter_PROC
    initBasicProc 6

    ;Determine the type of the char.
    xor ax, ax
    mov al, [CC_Char_VAR]
    checkIfBetween ax, Ascii_CA, Ascii_CZ
    getBoolFlag [CC_CapitalValid_VAR] 

    xor ax, ax
    mov al, [CC_Char_VAR]
    checkIfBetween ax, Ascii_A, Ascii_Z
    getBoolFlag [CC_LowerValid_VAR]

    xor ax, ax
    mov al, [CC_Char_VAR]
    checkIfBetween ax, Ascii_0, Ascii_9
    getBoolFlag [CC_NumberValid_VAR]
    
    mov al, [true]
    cmp [CC_CapitalValid_VAR], al
    je CC_CapitalLetter_LABEL

    cmp [CC_LowerValid_VAR], al
    je CC_LowerCaseLetter_LABEL

    cmp [CC_NumberValid_VAR], al
    je CC_Number_LABEL
        
    ;Set parameters.
    CC_CapitalLetter_LABEL:
        xor ax, ax
        xor dx, dx
        
        mov ax, [capitalAIndex]

        mov dx, [CC_Char_VAR]
        sub dx, Ascii_CA

        add ax, dx
        jmp CC_Proccess_LABEL

    CC_LowerCaseLetter_LABEL:    
        xor ax, ax
        xor dx, dx
        
        mov ax, [lowerCaseAIndex]

        mov dx, [CC_Char_VAR]
        sub dx, Ascii_A

        add ax, dx
        jmp CC_Proccess_LABEL
    
    CC_Number_LABEL:
        xor ax, ax
        xor dx, dx
        
        mov ax, [number0Index]

        mov dx, [CC_Char_VAR]
        sub dx, Ascii_0

        add ax, dx
        jmp CC_Proccess_LABEL

    ;Read according key.
    CC_Proccess_LABEL:
        readFromKey 'f', ax

    endBasicProc 6
    ret 2
endp proccesCharacter_PROC

;===== FFunction =====
macro FFunction 
    pushAll 
    
    call FFunction_PROC
    
    popAll
endm FFunction

proc FFunction_PROC
    initBasicProc 0
    
    xor bx, bx
    add bx, offset password
    add bx, [currentPasswordIndex] 

    proccesCharacter byte ptr bx
    
    xor [word ptr LStream], ax
    xor [word ptr LStream + 2d], dx
    
    inc [currentPasswordIndex]

    endBasicProc 0 
    ret 0 
endp FFunction_PROC