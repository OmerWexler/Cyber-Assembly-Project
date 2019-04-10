;===== Read from data block =====
macro readFromDataBlock
    initFunction
    
    mov ax, [word ptr dataBlockBuffer + 0d]
    mov bx, [word ptr dataBlockBuffer + 2d]
    mov cx, [word ptr dataBlockBuffer + 4d]
    mov dx, [word ptr dataBlockBuffer + 6d]

    endFunction
endm readFromDataBlock