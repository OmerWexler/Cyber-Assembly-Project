;===== Checks if the next screen exists =====
macro validateNextScreen
    
    call validateNextScreen_PROC

endm validateNextScreen

proc validateNextScreen_PROC

    mov al, 2   
    mov dx, offset PBMP_NextScreen
	mov ah, 3dh
    int 21h 
    
    jc VNS_ReturnFalse_LABEL
    jnc VNS_ReturnTrue_LABEL
    
    VNS_ReturnFalse_LABEL:
        setBoolFlag [false]
        
    VNS_ReturnTrue_LABEL:
        setBoolFlag [true]

    ret 0
endp validateNextScreen_PROC
;===== Checks if the mouse is inside the hitbox of any button and changes accordingly =====
macro updateButtons
    
endm updateButtons

proc updateButtons_PROC


endp updateButtons_PROC

;===== Compares the current position a given button's area =====
macro checkIfInTile CIIT_ButtonName_PARAM

    
    
endm checkIfInTile

proc checkIfInTile_PROC
    
endp checkIfInTile_PROC

;===== Check if the user has clicked on an option =====
;===== Updates the displayed screen based on the next name and about should the screen be updated =====