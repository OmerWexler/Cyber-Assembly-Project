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

;===== Sets a single NEXT screen property =====
macro setNextScreenProperty SNSP_TypeOfProperty_PARAM, SNSP_DataToSet_PARAM
    
    push di
    push ax

    push SNSP_TypeOfProperty_PARAM
    push SNSP_DataToSet_PARAM
    call setNextScreenProperty_PROC

    pop ax
    pop di

endm setNextScreenProperty

SNSP_TypeOfProperty_PARAM equ bp + 6
SNSP_DataToSet_PARAM equ bp + 4
proc setNextScreenProperty_PROC
    initBasicProc 0

    xor ax, ax
    xor di, di

    mov di, [SNSP_TypeOfProperty_PARAM]
    mov ax, [SNSP_DataToSet_PARAM]
    mov [byte ptr nextScreen + di], al

    endBasicProc 0
    ret 4
endp setNextScreenProperty_PROC

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
CIIT_ButtonID_VAR equ word ptr di + 8d
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
macro updateButtons
    call updateButtons_PROC
endm updateButtons

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
            printScreen
            jmp UB_Finish_LABEL

    UB_Finish_LABEL:
    ret 0
endp updateButtons_PROC

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

IBAL_ButtonLit_VAR equ bp + 4
proc isAnyButtonLit_PROC
    initBasicProc 0

    setBoolFlag [false]
    xor ax, ax
    mov [IBAL_ButtonLit_VAR], ax
    
    mov cx, 5d
    IBAL_CheckName_LABEL:

        mov di, cx
        add di, 2d

        xor ax, ax

        mov al, [byte ptr currentScreen + di]
        compare ax, '==', '1'
        checkBoolean [boolFlag], IBAL_ReturnTrue_LABEL, IBAL_ContinueLoop_LABEL
        
        IBAL_ContinueLoop_LABEL:
        loop IBAL_CheckName_LABEL
        
        jmp IABL_Exit_LABEL

    IBAL_ReturnTrue_LABEL:
        mov [IBAL_ButtonLit_VAR], di

        setBoolFlag [true]
        jmp IABL_Exit_LABEL

    IABL_Exit_LABEL:
    endBasicProc 0
    ret 0
endp isAnyButtonLit_PROC

;===== Checks for a mouse click =====
macro checkMouseClick CMC_ButtonLit_PARAM
    
    push 0000d ;allocate room for return value
    push CMC_ButtonLit_PARAM
    call checkMouseClick_PROC

endm checkMouseClick

CMC_ButtonExecuted_VAR equ bp + 6
CMC_ButtonToExecute_VAR equ bp + 4
proc checkMouseClick_PROC
    initBasicProc 0
    
    compare [clickStatus], '==', leftClick
    checkBoolean [boolFlag], CMC_WaitForRealese_LABEL, CMC_Exit_LABEL

    CMC_WaitForRealese_LABEL:
        
        readMouse 
        
        compare [clickStatus], '==', noClick
        checkBoolean [boolFlag], CMC_CheckButtons_LABEL, CMC_WaitForRealese_LABEL

        CMC_CheckButtons_LABEL:
        mov ax, [CMC_ButtonToExecute_VAR]

        CMC_CheckBack_LABEL:
            compare ax, '==', backButton
            checkBoolean [boolFlag], CMC_ExecuteBack_LABEL, CMC_CheckNext_LABEL
            
            CMC_ExecuteBack_LABEL:
                call executeBackButton_PROC
                
                xor ax, ax
                mov ax, backButton
                mov [CMC_ButtonExecuted_VAR], ax 
                 
                jmp CMC_Print_LABEL



        CMC_CheckNext_LABEL:
            compare ax, '==', nextButton
            checkBoolean [boolFlag], CMC_ExecuteNext_LABEL, CMC_CheckDecrypt_LABEL

            CMC_ExecuteNext_LABEL:
                call executeNextButton_PROC
                
                xor ax, ax
                mov ax, nextButton
                mov [CMC_ButtonExecuted_VAR], ax

                jmp CMC_Print_LABEL


                
                
        CMC_CheckDecrypt_LABEL:
            compare ax, '==', decryptButton
            checkBoolean [boolFlag], CMC_ExecuteDecrypt_LABEL, CMC_CheckEncrypt_LABEL
                
            CMC_ExecuteDecrypt_LABEL:
                call executeDecryptButton_PROC

                xor ax, ax
                mov ax, decryptButton
                mov [CMC_ButtonExecuted_VAR], ax

                jmp CMC_Print_LABEL



        CMC_CheckEncrypt_LABEL:
            compare ax, '==', encryptButton
            checkBoolean [boolFlag], CMC_ExecuteEncrypt_LABEL, CMC_CheckRestart_LABEL
                
            CMC_ExecuteEncrypt_LABEL:
                call executeEncryptButton_PROC
                
                xor ax, ax
                mov ax, encryptButton
                mov [CMC_ButtonExecuted_VAR], ax
                
                jmp CMC_Print_LABEL


                
        CMC_CheckRestart_LABEL:
            compare ax, '==', restartButton
            checkBoolean [boolFlag], CMC_ExecuteRestart_LABEL, CMC_ReturnFalse_LABEL
                
            CMC_ExecuteRestart_LABEL:
                call executeRestartButton_PROC

                xor ax, ax
                mov ax, restartButton
                mov [CMC_ButtonExecuted_VAR], ax

                jmp CMC_Print_LABEL
                
    CMC_Print_LABEL:
        setBoolFlag [true]

        resetButtons
        printScreen
        
        jmp CMC_Exit_LABEL

    CMC_ReturnFalse_LABEL:
        setBoolFlag [false]
        jmp CMC_Exit_LABEL

    CMC_Exit_LABEL:
    endBasicProc 0
    ret 2
endp checkMouseClick_PROC

;===== Loops through one screen type/status life cycle (until change occurs) =====
;as described in - (screens/screen logics.png)
macro manageCurrentScreen MCS_ButtonToSwitch1_PARAM, MCS_LabelIfSwitch1_PARAM, MCS_ButtonToSwitch2_PARAM, MCS_LabelIfSwitch2_PARAM

    push 0000d ;allocate return room
    call manageCurrentScreen_PROC
    pop ax

    compare ax, '==', MCS_ButtonToSwitch1_PARAM
    checkBooleanSingleJump [boolFlag], MCS_LabelIfSwitch1_PARAM
    
    compare ax, '==', MCS_ButtonToSwitch2_PARAM
    checkBooleanSingleJump [boolFlag], MCS_LabelIfSwitch2_PARAM

endm manageCurrentScreen

MCS_ButtonPressed_VAR equ bp + 4
proc manageCurrentScreen_PROC
    initBasicProc 0

    readMouse
    updateButtons

    isAnyButtonLit ;Button lit is now in stack, pop needed
    pop ax    

    checkBoolean [boolFlag], MCS_CheckClick_LABEL, MCS_SkipClickCheck_LABEL
    
    MCS_CheckClick_LABEL: ;Check for click only if a button is lit.
        
        checkMouseClick ax
        pop ax
        mov [MCS_ButtonPressed_VAR], ax    

    MCS_SkipClickCheck_LABEL:


    MCS_Exit_LABEL:
        endBasicProc 0
        ret 0
endp manageCurrentScreen_PROC

;===== Check current screen type and sets boolFlag accordigly =====
macro compareCurrentScreenProperty CCSP_PropertyToCheck_PARAM, CCSP_DataToCheckFor_PARAM
    
    push CCSP_DataToCheckFor_PARAM
    push CCSP_PropertyToCheck_PARAM
    call compareCurrentScreenProperty_PROC

endm compareCurrentScreenProperty

CCSP_DataToCheckFor_VAR equ bp + 6
CCSP_PropertyToCheck_VAR equ bp + 4
proc compareCurrentScreenProperty_PROC
    initBasicProc 0

    xor ax, ax
    xor dx, dx

    mov di, [CCSP_PropertyToCheck_VAR]

    mov al, [byte ptr currentScreen + di]
    mov dx, [CCSP_DataToCheckFor_VAR]
    compare ax, '==', dx

    endBasicProc 0
    ret 4
endp compareCurrentScreenProperty_PROC

;===== Sets the is enabled var for all buttons =====
macro setupButtons SB_Back_PARAM, SB_Next_PARAM, SB_Decrypt_PARAM, SB_Encrypt_PARAM, SB_Restart_PARAM
 
    setButton [backEnabled], SB_Back_PARAM
    setButton [nextEnabled], SB_Next_PARAM
    setButton [decryptEnabled], SB_Decrypt_PARAM
    setButton [encryptEnabled], SB_Encrypt_PARAM
    setButton [restartEnabled], SB_Restart_PARAM

endm setupButtons