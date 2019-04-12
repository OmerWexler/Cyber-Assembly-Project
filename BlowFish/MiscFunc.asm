;===== Read from data block =====
macro readFromDataBlockBuffer WordID

    mov ax, [word ptr dataBlockBuffer + 0d]
    mov bx, [word ptr dataBlockBuffer + 2d]
    mov cx, [word ptr dataBlockBuffer + 4d]
    mov dx, [word ptr dataBlockBuffer + 6d]
    
endm readFromDataBlockBuffer