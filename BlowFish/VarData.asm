;===== PKeys Array =====
PKeys dq 18 dup (00000000h)
keysArrayLength dw 72d

;===== Password =====
password db 'defaultpass20202$'

;===== File Related Data =====
currentReadFileName db '00000000.00000'
currentReadFileHandle dw ?

currentWriteFileName db '00000000.00000'
currentWriteFileHandle dw ?

dataFileName db 'datafile.txt', 0

encryptedFileName db 'encrypte.txt', 0

decryptedFileName db 'decrypte.txt', 0

;===== Blow Fish Algorithm =====
dataBlockBuffer dq 3333333333333333h ;64 BIT 
LStream         dd 11111111h ;32 BIT
RStream         dd 11111111h ;32 BIT

runMode dw 0000d
 
;===== FKeys Array =====
Fkeys dq 62 dup (00000000h)
FkeysArrayLength dw 248d

;===== FFunction =====
currentPasswordIndex dw 0000h
lowerCaseAIndex dw 1d
capitalAIndex dw 27d
number0Index dw 53d

;===== Boolean ======
true db 0001h
false db 0000h

boolFlag db 1d

;===== Files Library =====
readBuffer db 256d dup (00h)
writeBuffer db 256d dup (00h)

; ===== BMP printing =====
SCREEN_WIDTH equ 320
SCREEN_HEIGHT equ 200

PBMP_TempHeader db 54 dup (0)
PBMP_TempPallete db 256 * 4 dup (0)
PBMP_TempHandle dw ?
PBMP_ScrLine db SCREEN_WIDTH dup (0)
PBMP_ErrorMsg db 'Error', 13, 10,'$'


;===== Ascii =====
Ascii_0 equ 48d
Ascii_1 equ 49d
Ascii_2 equ 50d
Ascii_3 equ 51d
Ascii_4 equ 52d
Ascii_5 equ 53d
Ascii_6 equ 54d
Ascii_7 equ 55d
Ascii_8 equ 56d
Ascii_9 equ 57d
Ascii_CA equ 65d
Ascii_CB equ 66d
Ascii_CC equ 67d
Ascii_CD equ 68d
Ascii_CE equ 69d
Ascii_CF equ 70d
Ascii_CG equ 71d
Ascii_CH equ 72d
Ascii_CI equ 73d 
Ascii_CJ equ 74d
Ascii_CK equ 75d
Ascii_CL equ 76d 
Ascii_CM equ 77d
Ascii_CN equ 78d
Ascii_CO equ 79d
Ascii_CP equ 80d
Ascii_CQ equ 81d
Ascii_CR equ 82d
Ascii_CS equ 83d
Ascii_CT equ 84d
Ascii_CU equ 85d 
Ascii_CV equ 86d
Ascii_CW equ 87d
Ascii_CX equ 88d 
Ascii_CY equ 89d
Ascii_CZ equ 90d 
Ascii_A equ 97d
Ascii_B equ 98d 
Ascii_C equ 99d 
Ascii_D equ 100d
Ascii_E equ 101d
Ascii_F equ 102d 
Ascii_G equ 103d
Ascii_H equ 104d
Ascii_I equ 105d 
Ascii_J equ 106d
Ascii_K equ 107d 
Ascii_L equ 108d
Ascii_M equ 109d
Ascii_N equ 110d
Ascii_O equ 111d
Ascii_P equ 112d
Ascii_Q equ 113d
Ascii_R equ 114d
Ascii_S equ 115d
Ascii_T equ 116d
Ascii_U equ 117d
Ascii_V equ 118d
Ascii_W equ 119d
Ascii_X equ 120d
Ascii_Y equ 121d
Ascii_Z equ 122d
Ascii_Enter equ 10d
Ascii_$ equ 36d