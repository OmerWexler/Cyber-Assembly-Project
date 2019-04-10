;===== Keys Array =====
keys dq 18 dup (00000000h)

keysArrayLength dw 72d

P1 equ offset keys + 0d * 4d
P2 equ offset keys + 1d * 4d
P3 equ offset keys + 2d * 4d
P4 equ offset keys + 3d * 4d
P5 equ offset keys + 4d * 4d
P6 equ offset keys + 5d * 4d
P7 equ offset keys + 6d * 4d
P8 equ offset keys + 7d * 4d
P9 equ offset keys + 8d * 4d
P10 equ offset keys + 9d * 4d
P11 equ offset keys + 10d * 4d
P12 equ offset keys + 11d * 4d
P13 equ offset keys + 12d * 4d
P14 equ offset keys + 13d * 4d
P15 equ offset keys + 14d * 4d
P16 equ offset keys + 15d * 4d
P17 equ offset keys + 16d * 4d
P18 equ offset keys + 17d * 4d
 
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

