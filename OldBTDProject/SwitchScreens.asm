IDEAL
MODEL small
STACK 100h
DATASEG
xRangeMax db 90
xRangeMin db 42

yRangemax db 61
yRangeMin db 55

print db 'I guess it works$'
CODESEG
start:
	mov ax, @data
	mov ds, ax
	
enterCheck:
	checkX:
		cmp cx, xRangeMax
		jb notInRange
		
		cmp cx, xRangeMin
		ja notInRange
		
		jmp checkY
	
	checkY:
		
		
	
	
	
notInRange:
	jmp enterCheck
	
inRange:
	jmp codeToRun
	
codeToRun
	mov dx, offset print
	mov ah, 9h
	int 21
	
exit:
mov ax, 4C00h
int 21h
END start