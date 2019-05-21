;===== Runs the logic of what happnes when you press the back Button =====
proc executeBackButton_PROC

    setBoolFlag [false]

    mov al, [byte ptr nextScreen + stage]
    compare ax, '>', Ascii_0
    checkBoolean [boolFlag], EBB_DecStage_LABEL, EBB_ShouldDecType_LABEL

    EBB_ShouldDecType_LABEL:    
        xor ax, ax

        mov al, [byte ptr nextScreen + sType]
        compare ax, '==', 'O'
        checkBoolean [boolFlag], EBB_LeaveSoftware_LABEL, EBB_CheckEncrypt_LABEL  

        EBB_CheckEncrypt_LABEL:
            xor ax, ax

            mov al, [byte ptr nextScreen + sType]
            compare ax, '==', 'E'
            checkBoolean [boolFlag], EBB_GoToOpeningScreen_LABEL, EBB_CheckDecrypt_LABEL    

        EBB_CheckDecrypt_LABEL:
            xor ax, ax       
             
            mov al, [byte ptr nextScreen + sType]
            compare ax, '==', 'D'
            checkBoolean [boolFlag], EBB_GoToOpeningScreen_LABEL, EBB_Exit_LABEL    

    EBB_DecStage_LABEL:
        xor ax, ax

        mov al, [byte ptr nextScreen + stage]
        compare ax, '==', Ascii_4
        checkBoolean [boolFlag], EBB_LeaveSoftware_LABEL, EBB_ShouldDecNormal_LABEL;because it's the final stage, and the user can't come back, only exit using button
        
            EBB_ShouldDecNormal_LABEL:
                xor ax, ax

                mov al, [byte ptr nextScreen + stage]
                dec al
                mov [byte ptr nextScreen + stage], al

                resetButtons
                resetStatus
                printBMP    

                jmp EBB_Exit_LABEL

    EBB_GoToOpeningScreen_LABEL:
        setNextType 'O'
        resetButtons
        resetStatus

        compareFileNames nextScreen, currentScreen
        checkBoolean [boolFlag], EBB_NoUpdate_LABEL, EBB_IsUpdate_LABEL

        EBB_IsUpdate_LABEL:
            printBMP 
            jmp EBB_Exit_LABEL

        EBB_NoUpdate_LABEL:
            jmp EBB_Exit_LABEL

    EBB_LeaveSoftware_LABEL:
        mov ax, 4C00h
        int 21h

    EBB_Exit_LABEL:
        ret 0
endp executeBackButton_PROC


proc executeNextButton_PROC
    initBasicProc 0

    setBoolFlag [false]

    mov al, [byte ptr currentScreen]
    inc al
    mov [byte ptr currentScreen], al

    resetButtons
    resetStatus
    printBMP
    
    endBasicProc 0
    ret 0
endp executeNextButton_PROC


proc executeDecryptButton_PROC
    initBasicProc 0

    setBoolFlag [false]

    setNextType 'D'
    resetButtons

    endBasicProc 0
    ret 0
endp executeDecryptButton_PROC

proc executeEncryptButton_PROC
    initBasicProc 0


    endBasicProc 0
    ret 0
endp executeEncryptButton_PROC

proc executeRestartButton_PROC
    initBasicProc 0


    endBasicProc 0
    ret 0
endp executeRestartButton_PROC
