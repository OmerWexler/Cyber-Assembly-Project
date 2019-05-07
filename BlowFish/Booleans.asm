;===== Set boolFlag =====
macro setBoolFlag boolean
    push ax
    
    mov al, boolean
    mov [boolflag], al
    
    pop ax
endm setBoolFlag

;===== Compares between two oparands and sets the boolean flag accordingly =====
macro compare oparand1, operator, oparand2

    push oparand1
    push operator
    push oparand2
    call compare_PROC

endm compare

C_Oparand1_VAR equ bp + 8
C_Operator_VAR equ bp + 6
C_Oparand2_VAR equ bp + 4
proc compare_PROC
    initBasicProc 0

    mov ax, [C_Operator_VAR] 
    
    cmp ax, '>'
    je C_Greater_LABEL

    cmp ax, '<'
    je C_Below_LABEL

    cmp ax, '=='
    je C_Equal_LABEL

    cmp ax, '!='
    je C_NotEqual_LABEL

    cmp ax, '<='
    je C_BelowEqual_LABEL
    
    cmp ax, '>='
    je C_GreaterEqual_LABEL   
    
    jmp C_End_LABEL

    C_Greater_LABEL:
        mov ax, [C_Oparand1_VAR]
        mov dx, [C_Oparand2_VAR]

        cmp ax, [C_Oparand2_VAR]
        je C_False_LABEL
        ja C_True_LABEL 
        jb C_False_LABEL
    
    C_Below_LABEL:
        mov ax, [C_Oparand1_VAR]
        mov dx, [C_Oparand2_VAR]

        cmp ax, dx
        je C_False_LABEL
        jb C_True_LABEL 
        ja C_False_LABEL 
        
    C_Equal_LABEL:
        mov ax, [C_Oparand1_VAR]
        mov dx, [C_Oparand2_VAR]

        cmp ax, dx
        je C_True_LABEL 
        jne C_False_LABEL 
        
    C_NotEqual_LABEL:
        mov ax, [C_Oparand1_VAR]
        mov dx, [C_Oparand2_VAR]

        cmp ax, dx
        jne C_True_LABEL 
        je C_False_LABEL 
        
    C_BelowEqual_LABEL:
        mov ax, [C_Oparand1_VAR]
        mov dx, [C_Oparand2_VAR]

        cmp ax, dx
        je C_True_LABEL
        jbe C_True_LABEL 
        ja C_False_LABEL 
        
    C_GreaterEqual_LABEL:
        mov ax, [C_Oparand1_VAR]
        mov dx, [C_Oparand2_VAR]

        cmp ax, dx
        je C_True_LABEL
        jae C_True_LABEL 
        jb C_False_LABEL 

    C_True_LABEL:
        setBoolFlag [true]
        jmp C_End_LABEL

    C_False_LABEL:
        setBoolFlag [false]
        jmp C_End_LABEL

    C_End_LABEL:
        endBasicProc 0
        ret 6
endp compare_PROC

;===== Copy boolFlag =====
macro copyBoolFlag booleanVar
    push ax

    mov al, [boolflag]
    mov booleanVar, al

    pop ax
endm copyBoolFlag

;===== Check boolean and jump to correct label =====
macro checkBoolean boolean, labelToTrue, labelToFalse

    mov al, [true]
    cmp boolean, al
    je labelToTrue

    mov al, [false]
    cmp boolean, al
    je labelToFalse
    
endm checkBoolFlag

;===== Check if between =====
macro checkIfBetween number, lowThresh, highThresh

    push number
    push lowThresh
    push highThresh
    call checkIfBetween_PROC

endm checkIfBetween

CIB_Number_VAR equ bp + 8
CIB_Low_Thresh_VAR equ bp + 6
CIB_High_Thresh_VAR equ bp + 4 
proc checkIfBetween_PROC
    initBasicProc 0 

    mov ax, [CIB_Number_VAR]
    cmp ax, [CIB_Low_Thresh_VAR]
    jge CIB_NumberIsGreaterEqual_LABEL
    
    cmp ax, [CIB_High_Thresh_VAR]
    jle CIB_NumberIsLowerEqual_LABEL

    setBoolFlag [false]
    jmp CIB_Return_LABEL

CIB_NumberIsLowerEqual_LABEL:
    cmp ax, [CIB_Low_Thresh_VAR]
    jge CIB_NumberIsInside_LABEL
    
    setBoolFlag [false]
    jmp CIB_Return_LABEL

CIB_NumberIsGreaterEqual_LABEL:
    cmp ax, [CIB_High_Thresh_VAR]
    jle CIB_NumberIsInside_LABEL
    
    setBoolFlag [false]
    jmp CIB_Return_LABEL

CIB_NumberIsInside_LABEL:
    setBoolFlag [true]
    jmp CIB_Return_LABEL

CIB_Return_LABEL:
    endBasicProc 0
    ret 6
endp checkIfBetween_PROC