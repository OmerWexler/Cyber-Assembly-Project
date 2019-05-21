;===== Enables the chosen button to change and be used =====
macro setButton EB_ButtonToEnable_LABEL, EB_Value_PARAM

    mov al, EB_Value_PARAM
    mov EB_ButtonToEnable_LABEL, al

endm setButton 

;===== Resets all the buttons on next screen (unlights them) =====
macro resetButtons
    
    mov al, Ascii_0
    mov [byte ptr nextScreen + backButton], al 
    mov [byte ptr nextScreen + nextButton], al 
    mov [byte ptr nextScreen + decryptButton], al 
    mov [byte ptr nextScreen + encryptButton], al 
    mov [byte ptr nextScreen + restartButton], al 
    
endm resetButtons 

;===== Resets the status into 0 =====
macro resetStatus

    mov al, Ascii_0
    mov [byte ptr nextScreen + status], al
    
endm resetStatus

;===== Compares the current position a given button's area =====
;returns if an update is needed
macro checkTile CIIT_ButtonName_PARAM

    push offset CIIT_ButtonName_PARAM
    call checkTile_PROC
    
endm checkTile

CIIT_ButtonOffset_VAR equ bp + 4

CIIT_LowX_VAR equ word ptr di 
CIIT_LowY_VAR equ word ptr di + 2d 
CIIT_HighX_VAR equ word ptr di + 4d
CIIT_HighY_VAR equ word ptr di + 6d
CIIT_ArcX_VAR equ word ptr di + 8d
CIIT_ArcY_VAR equ word ptr di + 10d
CIIT_ButtonID_VAR equ word ptr di + 12d
proc checkTile_PROC
    initBasicProc 0

    mov di, [CIIT_ButtonOffset_VAR]
    mov si, [CIIT_ButtonID_VAR]

    checkIfBetween [mouseX], [CIIT_LowX_VAR], [CIIT_HighX_VAR] 
    checkBoolean [boolFlag], CIIT_XValid_LABEL, CIIT_ReturnFalse_LABEL 

    CIIT_XValid_LABEL:
        checkIfBetween [mouseY], [CIIT_LowY_VAR], [CIIT_HighY_VAR] 
        checkBoolean [boolFlag], CIIT_ReturnTrue_LABEL, CIIT_ReturnFalse_LABEL 

    CIIT_ReturnTrue_LABEL:
        mov al, Ascii_1
        mov [byte ptr nextScreen + si], al 

        setBoolFlag [true]
        jmp CIIT_Finish_LABEL

    CIIT_ReturnFalse_LABEL:
        mov al, Ascii_0
        mov [byte ptr nextScreen + si], al

        setBoolFlag [false]
        jmp CIIT_Finish_LABEL

    CIIT_Finish_LABEL:
        endBasicProc 0
        ret 2
endp checkTile_PROC

;===== Checks if the mouse is inside the hitbox of any button and changes accordingly =====
proc updateButtons_PROC

    UB_Check_LABEL:
        setBoolFlag [false]
        
        resetButtons
        
        UB_CheckBack_LABEL:
            cmp [backEnabled], 0d
            je UB_CheckNext_LABEL

            checkTile backButtonBase
            checkBoolean [boolFlag], UB_CheckNewUpdate_LABEL, UB_CheckNext_LABEL

        UB_CheckNext_LABEL:
            cmp [nextEnabled], 0d
            je UB_CheckDecrypt_LABEL
            
            checkTile nextButtonBase
            checkBoolean [boolFlag], UB_CheckNewUpdate_LABEL, UB_CheckDecrypt_LABEL
        
        UB_CheckDecrypt_LABEL:
            cmp [decryptEnabled], 0d
            je UB_CheckEncrypt_LABEL

            checkTile decryptButtonBase
            checkBoolean [boolFlag], UB_CheckNewUpdate_LABEL, UB_CheckEncrypt_LABEL
        
        UB_CheckEncrypt_LABEL:
            cmp [encryptEnabled], 0d
            je UB_CheckRestart_LABEL

            checkTile encryptButtonBase
            checkBoolean [boolFlag], UB_CheckNewUpdate_LABEL, UB_CheckRestart_LABEL
        
        UB_CheckRestart_LABEL:
            cmp [restartEnabled], 0d
            je UB_CheckNewUpdate_LABEL
            
            checkTile restartButtonBase
            jmp UB_CheckNewUpdate_LABEL

    UB_CheckNewUpdate_LABEL:
        compareFileNames currentScreen, nextScreen
        checkBoolean [boolFlag], UB_Finish_LABEL, UB_UpdateNeeded_LABEL
        
        UB_UpdateNeeded_LABEL:
            printBMP
            jmp UB_Finish_LABEL

    UB_Finish_LABEL:
    ret 0
endp updateButtons_PROC

;===== Check if the user has clicked on an option =====
;===== Updates the displayed screen based on the next name and about should the screen be updated =====

;===== Sets the current screen type - O (opening), D (decryption), E (encryption) =====
macro setNextType SCT_Type_PARAM
    push ax

    mov al, SCT_Type_PARAM
    mov [nextScreen + SType], al
    

    pop ax
endm setNextType
;===== Sets the current screen type - O (opening), D (decryption), E (encryption) =====
macro setNextType SCT_Type_PARAM
    push ax

    mov al, SCT_Type_PARAM
    mov [nextScreen + SType], al
    

    pop ax
endm setNextType
;===== Sets the current screen type - O (opening), D (decryption), E (encryption) =====
macro setNextType SCT_Type_PARAM
    push ax

    mov al, SCT_Type_PARAM
    mov [nextScreen + SType], al
    

    pop ax
endm setNextType
;===== Sets the current screen type - O (opening), D (decryption), E (encryption) =====
macro setNextType SCT_Type_PARAM
    push ax

    mov al, SCT_Type_PARAM
    mov [nextScreen + SType], al
    

    pop ax
endm setNextType


;===== Checks if any of the currentSCreens Button is currently up =====
macro isAnyButtonLit
    
    push 0000d ;reserve room for return value
    call isAnyButtonLit_PROC

endm isAnyButtonLit

IBAL_ReturnValue_VAR equ bp + 4
proc isAnyButtonLit_PROC
    initBasicProc 0
    setBoolFlag [false]

    mov cx, 5d
    IBAL_CheckName_LABEL:

        mov di, cx
        add di, 2d

        xor ax, ax

        mov al, [byte ptr currentScreen + di]
        compare ax, '==', Ascii_1
        checkBoolean [boolFlag], IBAL_ReturnTrue_LABEL, IBAL_ContinueLoop_LABEL
        
        IBAL_ContinueLoop_LABEL:
        loop IBAL_CheckName_LABEL
        
        jmp IABL_Exit_LABEL

    IBAL_ReturnTrue_LABEL:
        mov [IBAL_ReturnValue_VAR], di

        setBoolFlag [true]
        jmp IABL_Exit_LABEL

    IABL_Exit_LABEL:
    endBasicProc 0
    ret 0
endp isAnyButtonLit_PROC

;===== Checks for a mouse click =====
macro checkMouseClick CMC_ButtonLit_PARAM
    
    push CMC_ButtonLit_PARAM
    call checkMouseCLick_PROC

endm checkMouseClick

CMC_ButtonToExecute_VAR equ bp + 4
proc checkMouseCLick_PROC
    initBasicProc 0
    
    compare [clickStatus], '==', leftClick
    checkBoolean [boolFlag], CMC_Clicked_LABEL, CMC_Exit_LABEL

    CMC_Clicked_LABEL:
        mov ax, [CMC_ButtonToExecute_VAR]
        


    CMC_Exit_LABEL:
    endBasicProc 0
    ret 2
endp checkMouseCLick_PROC

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
        printBMP    

        jmp EBB_Exit_LABEL

    EBB_LeaveSoftware_LABEL:
        mov ax, 4C00h
        int 21h

    EBB_Exit_LABEL:
        ret 0
endp executeBackButton_PROC

;===== Loops through one screen type/status life cycle (until change occurs) =====
;as described in - (/screens/screen logics.png)
macro runScreen RS_screenName_PARAM
    
    call updateButtons_PROC
    call isAnyButtonLit
    pop ax
    checkBoolean [boolFlag], RS_CheckClick_LABEL, RS_Continue_LABEL

    RS_CheckClick_LABEL:

        
    RS_Continue_LABEL:

endm runScreen