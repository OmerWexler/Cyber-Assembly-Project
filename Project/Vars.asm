;===== Main Vars =====
File1 db 'testfile.txt', 0,'$'
File1H dw ?
writeLengh dw ?
readLengh dw 10
toPrint db 20h dup(0)
PrintAble db 'Print macro works$'
toPrint2 db 'abcd$'
BMPFileName db 'test.bmp',0

;===== Graphic Vars =====
PBMPS_BMPFileHandle dw ?
PBMPS_BMPHeader db 54 dup (0)
PBMPS_BMPPalette db 256*4 dup (0)
PBMPS_BMPBuffer db 320 dup (0)
PBMPS_Error_Msg db 'Error while openeing file for BMP printing$'

;==== Files Vars =====
ReadBuffer db 100d dup(0)