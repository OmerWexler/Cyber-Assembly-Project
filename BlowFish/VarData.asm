;===== Keys Array =====
keys db '1415', '3846', '2884', '1058', '0781', '8628', '0679', '8230', '9550', '4081', '8410', '5559', '9303', '7566', '5648', '2712', '6692', '4326' 
	 
;===== Zero String =====
zeroString dw 0000d

;===== Password =====
password db 'defaultpass$'

;===== Misc =====
keysArrayLength dw 72d
readBuffer db 256d dup (0)