;===== Resets all the buttons on next screen (unlights them) =====
macro resetButtons
    
    mov al, Ascii_0
    mov [byte ptr nextScreen + backButton], al 
    mov [byte ptr nextScreen + nextButton], al 
    mov [byte ptr nextScreen + decryptButton], al 
    mov [byte ptr nextScreen + encryptButton], al 
    mov [byte ptr nextScreen + restartButton], al 

endm resetButtons 

;===== Makes sure the file named in NextScreen exists, and ajusts accordingly =====
macro validateNextScreen
    
    call validateNextScreen_PROC
    
endm validateNextScreen

proc validateNextScreen_PROC

    mov al, 2
    mov dx, offset nextScreen
    mov ah, 3dh
    int 21h

    jc VCS_InValid_LABEL
    jnc VCS_Valid_LABEL 

    VCS_Valid_LABEL:
        copyFileName currentScreen, nextScreen
        jmp VCS_Exit_LABEL
        
    VCS_InValid_LABEL:
        copyFileName nextScreen, currentScreen
        jmp VCS_Exit_LABEL

    VCS_Exit_LABEL:
    ret 0
endp validateNextScreen_PROC

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
macro updateButtons
    call updateButtons_PROC
endm updateButtons

proc updateButtons_PROC

    UB_Check_LABEL:
        setBoolFlag [false]
        resetButtons
        readMouse

        UB_CheckBack_LABEL:
            checkTile backButtonBase
            checkBoolean [boolFlag], UB_CheckNewUpdate_LABEL, UB_CheckNext_LABEL
            
        UB_CheckNext_LABEL:
            checkTile nextButtonBase
            checkBoolean [boolFlag], UB_CheckNewUpdate_LABEL, UB_CheckDecrypt_LABEL

        UB_CheckDecrypt_LABEL:
            checkTile decryptButtonBase
            checkBoolean [boolFlag], UB_CheckNewUpdate_LABEL, UB_CheckEncrypt_LABEL

        UB_CheckEncrypt_LABEL:
            checkTile encryptButtonBase
            checkBoolean [boolFlag], UB_CheckNewUpdate_LABEL, UB_CheckRestart_LABEL

        UB_CheckRestart_LABEL:
            checkTile restartButtonBase
            checkBoolean [boolFlag], UB_CheckNewUpdate_LABEL, UB_Check_LABEL

    UB_CheckNewUpdate_LABEL:
        
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