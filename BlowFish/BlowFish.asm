macro runBlowFishALG	
	;Demo code for key generation.
	call BlowFishAlgorithm_PROC

endm runBlowFishALG

proc BlowFishAlgorithm_PROC
	
	initBasicProc 0
	
	mov ax, 1234h
	mov [word ptr dataBlockBuffer + 0d], ax
	mov [word ptr dataBlockBuffer + 2d], ax
	mov [word ptr dataBlockBuffer + 4d], ax
	mov [word ptr dataBlockBuffer + 6d], ax

	endBasicProc 0 
	ret 0
endp BlowFishAlgorithm_PROC 