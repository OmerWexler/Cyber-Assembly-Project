;===== Keys Array =====
keys dq 18 dup (00000000h)

keysArrayLength dw 72d

P1 equ offset keys + 0d * 8d
P2 equ offset keys + 1d * 8d
P3 equ offset keys + 2d * 8d
P4 equ offset keys + 3d * 8d
P5 equ offset keys + 4d * 8d
P6 equ offset keys + 5d * 8d
P7 equ offset keys + 6d * 8d
P8 equ offset keys + 7d * 8d
P9 equ offset keys + 8d * 8d
P10 equ offset keys + 9d * 8d
P11 equ offset keys + 10d * 8d
P12 equ offset keys + 11d * 8d
P13 equ offset keys + 12d * 8d
P14 equ offset keys + 13d * 8d
P15 equ offset keys + 14d * 8d
P16 equ offset keys + 15d * 8d
P17 equ offset keys + 16d * 8d
P18 equ offset keys + 17d * 8d
 
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

