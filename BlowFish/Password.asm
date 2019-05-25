;===== PasswordValidation =====
macro validatePassword

    call validatePassword_PROC

endm validatePassword

; VP_CapitalValid_VAR equ byte ptr bp - 2
; VP_LowerCaseValid_VAR equ byte ptr bp - 4
; VP_NumberValid_VAR equ byte ptr bp - 6
; VP_ReturnValue_VAR equ byte ptr bp - 8
proc validatePassword_PROC
    initBasicProc 0
    
    push si

    xor si, si

    mov si, offset password

    setBoolFlag [false]

    VP_StartingPos_LABEL:

        xor ax, ax
        mov al, [byte ptr si]
        checkIfBetween ax, Ascii_CA, Ascii_CZ
        checkBooleanSingleJump [boolFlag], VP_PasswordValid_LABEL

        xor ax, ax
        mov al, [byte ptr si]
        checkIfBetween ax, Ascii_A, Ascii_Z
        checkBooleanSingleJump [boolFlag], VP_PasswordValid_LABEL

        xor ax, ax
        mov al, [byte ptr si]
        checkIfBetween ax, Ascii_0, Ascii_9
        checkBooleanSingleJump [boolFlag], VP_PasswordValid_LABEL
        
        jmp VP_PasswordInvalid_LABEL

    VP_PasswordValid_LABEL:
        setBoolFlag [true]

        inc si
        jmp VP_StartingPos_LABEL    

    VP_PasswordInvalid_LABEL:
        xor dx, dx
        mov dl, [byte ptr si]
        compare dx, '==', 00d

        jmp VP_Return_LABEL
    
    VP_Return_LABEL:
        pop si
        endBasicProc 0
        ret 0    
endp validatePassword_PROC