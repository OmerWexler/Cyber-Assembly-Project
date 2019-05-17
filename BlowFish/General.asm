;===== PasswordValidation =====
macro validatePassword

    call validatePassword_PROC

endm validatePassword

VP_CapitalValid_VAR equ byte ptr bp - 2
VP_LowerCaseValid_VAR equ byte ptr bp - 4
VP_NumberValid_VAR equ byte ptr bp - 6
VP_ReturnValue_VAR equ byte ptr bp - 8
proc validatePassword_PROC
    initBasicProc 8
    
    push si

    xor si, si

    mov si, offset password

    VP_StartingPos_LABEL:

        xor ax, ax
        mov al, [byte ptr si]
        checkIfBetween ax, Ascii_CA, Ascii_CZ
        copyBoolFlag [VP_CapitalValid_VAR] 

        xor ax, ax
        mov al, [byte ptr si]
        checkIfBetween ax, Ascii_A, Ascii_Z
        copyBoolFlag [VP_LowerCaseValid_VAR]

        xor ax, ax
        mov al, [byte ptr si]
        checkIfBetween ax, Ascii_0, Ascii_9
        copyBoolFlag [VP_NumberValid_VAR]
        
        cmp [VP_CapitalValid_VAR], 1d
        je VP_PasswordValid_LABEL

        cmp [VP_LowerCaseValid_VAR], 1d
        je VP_PasswordValid_LABEL

        cmp [VP_NumberValid_VAR], 1d
        je VP_PasswordValid_LABEL
        
        jmp VP_PasswordInvalid_LABEL

    VP_PasswordValid_LABEL:
        mov al, [true]
        mov [VP_ReturnValue_VAR], al

        inc si
        jmp VP_StartingPos_LABEL    

    VP_PasswordInvalid_LABEL:
        mov dl, [byte ptr si]
        cmp dl, Ascii_$
        je VP_Return_LABEL

        mov al, [false]
        mov [VP_ReturnValue_VAR], al
        jmp VP_Return_LABEL    

    VP_Return_LABEL:
        setBoolFlag [VP_ReturnValue_VAR]
        pop si

    endBasicProc 8
    ret 0    
endp validatePassword_PROC

;===== Sends all below params into an outside file =====
;Params:
; -Pkeys
; -Fkeys
; -Password
macro createDataFile
    pushAll
    
	call createDataFile_PROC

    popAll
endm createDataFile

proc createDataFile_PROC
    initBasicProc 0

    createFile dataFileName, [currentWriteFileHandle]

    writeToFile [currentWriteFileHandle], [keysArrayLength], Pkeys
    writeToFile [currentWriteFileHandle], [FkeysArrayLength], Fkeys    
    writeToFile [currentWriteFileHandle], [passwordLength], password    
    writeToFile [currentWriteFileHandle], 2d, passwordLength    
    
    closeFile [currentWriteFileHandle]

    ;add a close file statement for data file
    endBasicProc 0
    ret 0
endp createDataFile_PROC

;===== Copies all the data from the data file back into the CPU =====
macro retrieveDataFile
    pushAll
        
    call retrieveDataFile_PROC

    popAll
endm retrieveDataFile

proc retrieveDataFile_PROC
    initBasicProc 0

    openFile dataFileName, currentReadFileHandle, 'b'
    
    readFromFile currentReadFileHandle, [keysArrayLength], Pkeys
    readFromFile currentReadFileHandle, [FkeysArrayLength], Fkeys    
    readFromFile currentReadFileHandle, [passwordLength], password  
    readFromFile currentReadFileHandle, 2d, passwordLength  

    closeFile [currentReadFileHandle]

    endBasicProc 0
    ret 0
endp retrieveDataFile_PROC