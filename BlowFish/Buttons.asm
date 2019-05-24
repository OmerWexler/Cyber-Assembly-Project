;===== Runs the logic of what happnes when you press the back Button =====
proc executeBackButton_PROC

    setBoolFlag [false]

    mov al, [byte ptr nextScreen + stage]
    compare ax, '>', STAGE_Intro
    checkBoolean [boolFlag], EBB_DecStage_LABEL, EBB_ShouldDecType_LABEL

    EBB_ShouldDecType_LABEL:    
        xor ax, ax

        mov al, [byte ptr nextScreen + sType]
        compare ax, '==', TYPE_OpeningScreen
        checkBoolean [boolFlag], EBB_LeaveSoftware_LABEL, EBB_CheckEncrypt_LABEL  

        EBB_CheckEncrypt_LABEL:
            xor ax, ax

            mov al, [byte ptr nextScreen + sType]
            compare ax, '==', TYPE_Encryption
            checkBoolean [boolFlag], EBB_GoToOpeningScreen_LABEL, EBB_CheckDecrypt_LABEL    

        EBB_CheckDecrypt_LABEL:
            xor ax, ax       
             
            mov al, [byte ptr nextScreen + sType]
            compare ax, '==', TYPE_Decryption
            checkBoolean [boolFlag], EBB_GoToOpeningScreen_LABEL, EBB_Exit_LABEL    

    EBB_DecStage_LABEL:
        xor ax, ax

        mov al, [byte ptr nextScreen + stage]
        compare ax, '==', STAGE_EndGame
        checkBoolean [boolFlag], EBB_LeaveSoftware_LABEL, EBB_ShouldDecNormal_LABEL ;because it's the final stage, and the user can't come back, only exit using button
        
            EBB_ShouldDecNormal_LABEL:
                xor ax, ax

                mov al, [byte ptr nextScreen + stage]
                dec al
                mov [byte ptr nextScreen + stage], al    

                setNextScreenProperty status, Ascii_0
                jmp EBB_Exit_LABEL

    EBB_GoToOpeningScreen_LABEL:
        setNextScreenProperty sType, TYPE_OpeningScreen
        jmp EBB_Exit_LABEL

    EBB_LeaveSoftware_LABEL:
        mov ax, 4C00h
        int 21h

    EBB_Exit_LABEL:
        ret 0
endp executeBackButton_PROC

;===== Runs the logic of what happnes when you press the next Button =====
proc executeNextButton_PROC
    initBasicProc 0

    xor ax, ax
    mov al, [byte ptr nextScreen + stage]
    inc al
    mov [byte ptr nextScreen  + stage], al

    endBasicProc 0
    ret 0
endp executeNextButton_PROC

;===== Runs the logic of what happnes when you press the decrypt Button =====
proc executeDecryptButton_PROC
    initBasicProc 0

    setNextScreenProperty sType, TYPE_Decryption

    endBasicProc 0
    ret 0
endp executeDecryptButton_PROC

;===== Runs the logic of what happnes when you press the encrypt Button =====
proc executeEncryptButton_PROC
    initBasicProc 0

    setNextScreenProperty sType, TYPE_Encryption

    endBasicProc 0
    ret 0
endp executeEncryptButton_PROC

;===== Runs the logic of what happnes when you press the restart Button =====
proc executeRestartButton_PROC
    initBasicProc 0

    setNextScreenProperty sType, TYPE_OpeningScreen

    endBasicProc 0
    ret 0
endp executeRestartButton_PROC