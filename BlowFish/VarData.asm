;===== PKeys Array =====
PKeys dq 18 dup (00000000h)
keysArrayLength dw 72d

;===== Password =====
insertedPassword db 0,'1111111111111111', 0
password         db 0,'0000000000000000', 0
passwordLength   dw 0d

;===== File Related Data =====
currentReadFileName db '00000000.00000', 0
currentReadFileHandle dw ?

currentWriteFileName db '00000000.00000', 0
currentWriteFileHandle dw ?

dataFileName db 'datafile.txt', 0

encryptedFileName db 'encrypte'
encryptedFileType db '.00000', 0

decryptedFileName db 'decrypte'
decryptedFileType db '.00000', 0

overAllBytesWritten     dd 00000001d 
currentReadFileLength   dd 00000001d 

readBuffer db 512d dup (00h)

;===== Blow Fish Algorithm =====
dataBlockBuffer dq 3333333333333333h ;64 BIT 
LStream         dd 11111111h ;32 BIT
RStream         dd 11111111h ;32 BIT

runMode dw 0000d
proccesProgress dd 0000d
prevProccesProgress dd 0000d
proccesProgressString db '000%', 0

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

;===== BMP printing =====
SCREEN_WIDTH equ 320d
SCREEN_HEIGHT equ 200d

PBMP_TempHeader db 54 dup (0)
PBMP_TempPallete db 400h dup (0)
PBMP_TempHandle dw ?
PBMP_ScrLine db SCREEN_WIDTH dup (0)
PBMP_ErrorMsg db 'Error', 13, 10,'$'

PBMP_Height dw 0d
PBMP_Width dw 0d
PBMP_Padding dw 0d

PBMP_TrashPadding db 3 dup (0) 

;===== Screens =====
currentScreen db 'O0000000.bmp', 0
nextScreen    db 'O0000000.bmp', 0

sType equ 0 
stage equ 1 
status equ 2 
backButton equ 3 
nextButton equ 4 
decryptButton equ 5 
encryptButton equ 6 
restartButton equ 7 

TYPE_OpeningScreen equ Ascii_O
TYPE_Decryption equ Ascii_D
TYPE_Encryption equ Ascii_E

STAGE_Clear equ Ascii_0
STAGE_Intro equ Ascii_0
STAGE_Name equ Ascii_1
STAGE_Password equ Ascii_2
STAGE_Loading equ Ascii_3
STAGE_EndGame equ Ascii_4 ;*SNAP*

STATUS_Clear equ Ascii_0
STATUS_InputInValid equ Ascii_1
STATUS_Loaded equ Ascii_1
STATUS_InputValid equ Ascii_2
STATUS_NoDataFile equ Ascii_4

nextEnabled db 00d 
backEnabled db 00d 
decryptEnabled db 00d 
encryptEnabled db 00d
restartEnabled db 00d 

stringX dw 0000d
stringY dw 0000d
stringOffset dw 0000d
isStringBuffingAllowed db 0000d

;===== General Constants =====
readFileLengthLimit equ 15d
passwordLengthLimit equ 17d

UPDATE_STRING equ 0d
DONT_UPDATE_STRING equ 1d

;===== Screen hitboxes =====
;                    LowX , LowY , HighX, HighY, Button ID
backButtonBase dw    0000d, 0172d, 0039d, 0191d, backButton

nextButtonBase dw    0280d, 0172d, 0320d, 0191d, nextButton

decryptButtonBase dw 0000d, 0143d, 0107d, 0174d, decryptButton

encryptButtonBase dw 0213d, 0143d, 0320d, 0174d, encryptButton

restartButtonBase dw 0263d, 0172d, 0320d, 0191d, restartButton

;===== In Out Library =====
mouseX dw 0000d
mouseY dw 0000d

clickStatus dw 0000d

noClick equ 0d
leftClick equ 1d
rightClick equ 2d
bothClick equ 3d

currentStringReadIndex dw 0000d

;===== String Coodinates =====
nameX equ 88d
nameY equ 138d

passwordX equ 93d
passwordY equ 138d

precentX equ 71
precentY equ 120

;===== BMP Characters =====
BMP_CharBMPBuffer db '00.bmp', 0
BMP_TesterString db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 0
BMP_TesterString2 db 'abcdefghijklmnopqrstuvwxyz1234567890.%', 0