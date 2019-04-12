;===== Keys Array =====
keys dq 18 dup (00000000h)

keysArrayLength dw 72d
 
;===== Zero String =====
zeroString dw 0000d

;===== Password =====
password db 'defaultpass$'

;===== Files Library =====
readBuffer db 256d dup (0)

;===== File Related Data =====
currentFileName db 'tester.txt' ;TODO: Add changable by input name
currentFileHandle dw ? 

;===== Blow Fish Algorithm =====
dataBlockBuffer db '00000000' 

