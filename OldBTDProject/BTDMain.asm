IDEAL
MODEL small
STACK 100h

DATASEG
include 'Settings.asm'

CODESEG
include 'BaseLIB.asm'
include 'Graphics.asm'
include 'InOutLIB.asm'
include 'UtilLIB.asm'

proc ToggleOpeningScreens

	initBasicProc 0 
	cmp al, ASCII_W
	je TOS_Start_LABEL
	
	cmp al, ASCII_D
	je TOS_Info_LABEL
	
	jmp TOS_Finish_LABEL
	
	TOS_Start_LABEL:
		printBMP 0, 0, START_OPTION_OPENING_SCREEN_NAME
		jmp TOS_Finish_LABEL
		
	TOS_Info_LABEL:
		printBMP 0, 0, INFO_OPTION_OPENING_SCREEN_NAME
		jmp TOS_Finish_LABEL
	
	TOS_Finish_LABEL:
		endBasicProc 0
		ret 0

endp ToggleOpeningScreens

start:
	mov ax, @data
	mov ds, ax

	SwitchGraphicsMode 'g'
	printBMP 0, 0, OPENING_SCREEN_NAME

	
		
exit:
SwitchGraphicsMode 't'
mov ax, 4C00h
int 21h
END start