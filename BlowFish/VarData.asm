;===== Keys Array =====
keys db '1415', '3846', '2884', '1058', '0781', '8628', '0679', '8230', '9550', '4081', '8410', '5559', '9303', '7566', '5648', '2712', '6692', '4326' 
keysArrayLength dw 72d
	 
;===== Zero String =====
zeroString dw 0000d

;===== Password =====
password db 'defaultpass$'

;===== Files =====
readBuffer db 256d dup (0)
fileLength dw 673d

;===== File Data =====
TESTER db 'tester.txt'
TESTER_HANDLE dw ? 