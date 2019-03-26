IDEAL
MODEL small
STACK 100h

DATASEG
include 'Keys.asm'

CODESEG
include 'FuntSupp.asm'

start:


	
		
exit:
SwitchGraphicsMode 't'
mov ax, 4C00h
int 21h
END start