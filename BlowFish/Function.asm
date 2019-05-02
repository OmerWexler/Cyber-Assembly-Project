;===== Checks a certain character for it's key =====
macro proccesCharacter character

    push character
    call proccesCharacter_PROC
    
endm proccesCharacter

CC_Char_VAR equ bp + 4
CC_IsCapital_VAR equ byte ptr bp - 2
proc proccesCharacter_PROC
    initBasicProc 2

    mov ax, [CC_Char_VAR]
    checkIfBetween ax, Ascii_CA, Ascii_CZ
    copyBoolFlag [CC_IsCapital_VAR]

    checkBoolean [CC_IsCapital_VAR], CC_CapitalLetter_LABEL, CC_LowerCaseLetter_LABEL

CC_CapitalLetter_LABEL:
    mov dx, Ascii_CA
    jmp CC_Proccess_LABEL

CC_LowerCaseLetter_LABEL:
    mov dx, Ascii_A
    jmp CC_Proccess_LABEL

CC_Proccess_LABEL:
    mov ax, [CC_Char_VAR]
    sub ax, dx
    inc ax

    readFromKey 'f', ax

    endBasicProc 2
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