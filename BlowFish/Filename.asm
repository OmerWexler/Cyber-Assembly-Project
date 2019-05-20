;===== Checks for the type of the given file's name and sets the same type for the encrypte and decrypte files =====
macro copyFileTypeToAlgorithmFiles CFT_FileName_PARAM
    pushAll

    push offset CFT_FileName_PARAM
    call copyFileTypeToAlgorithmFiles_PROC

    popAll
endm copyFileTypeToAlgorithmFiles

CFT_FileNameOffset_VAR equ bp + 4
proc copyFileTypeToAlgorithmFiles_PROC
    initBasicProc 0
    
    xor ax, ax
    xor di, di
    mov si, [CFT_FileNameOffset_VAR]

    CFT_SeekDotLoop_LABEL:
        inc si

        mov al, [byte ptr si]
        compare ax, '==', Ascii_Dot
        checkBoolean [boolFlag], CFT_CopyType_LABEL, CFT_SeekDotLoop_LABEL

        CFT_CopyType_LABEL:    
            xor ax, ax    
            mov al, [byte ptr si]
            compare ax, '==', 0000d

            mov [byte ptr encryptedFileType + di], al
            mov [byte ptr decryptedFileType + di], al
            inc si
            inc di

            checkBoolean [boolFlag], CFT_Exit_LABEL, CFT_CopyType_LABEL

    CFT_Exit_LABEL:
    endbasicProc 0
    ret 0
endp copyFileTypeToAlgorithmFiles_PROC

;===== Copies from one file name to another (including type) =====
macro copyFileName CFN_FileNameToCopyTo_PARAM, CFN_FileNameToCopyFrom_PARAM 
    pushAll

    push offset CFN_FileNameToCopyTo_PARAM
    push offset CFN_FileNameToCopyFrom_PARAM
    call copyFileName_PROC

    popAll
endm copyFileName

CFN_FileNameToCopyToOffset_VAR equ bp + 6
CFN_FileNameToCopyFromOffset_VAR equ bp + 4
proc copyFileName_PROC
    initBasicProc 0

    mov di, [CFN_FileNameToCopyToOffset_VAR]
    mov si, [CFN_FileNameToCopyFromOffset_VAR]
    xor ax, ax

    CFN_CopyLoop_LABEL:

        mov al, [byte ptr si]
        mov [byte ptr di], al

        inc si
        inc di

        compare ax, '==', 0000d
        checkBoolean [boolFlag], CFN_Exit_LABEL, CFN_CopyLoop_LABEL


    CFN_Exit_LABEL:
    endBasicProc 0 
    ret 4
endp copyFileName_PROC