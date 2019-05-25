;===== Allocate Fkeys =====
macro allocateFkeys 
    pushAll

    call allocateFkeys_PROC

    popAll
endm allocateFkeys

proc allocateFkeys_PROC
    initBasicProc 0
    
    transferIntoKey 'f', 1d, 4638h, 5306h
    transferIntoKey 'f', 2d, 7360h, 9657h
    transferIntoKey 'f', 3d, 1209h, 1807h
    transferIntoKey 'f', 4d, 6383h, 2716h
    transferIntoKey 'f', 5d, 6416h, 2748h
    transferIntoKey 'f', 6d, 8880h, 0786h
    transferIntoKey 'f', 7d, 9256h, 0290h
    transferIntoKey 'f', 8d, 2284h, 7210h
    transferIntoKey 'f', 9d, 4031h, 7211h
    transferIntoKey 'f', 10d, 8608h, 2041h
    transferIntoKey 'f', 11d, 9000h, 4229h
    transferIntoKey 'f', 12d, 6617h, 1196h
    transferIntoKey 'f', 13d, 3779h, 2133h
    transferIntoKey 'f', 14d, 7575h, 1149h
    transferIntoKey 'f', 15d, 5950h, 1566h
    transferIntoKey 'f', 16d, 0496h, 3186h
    transferIntoKey 'f', 17d, 2947h, 2654h
    transferIntoKey 'f', 18d, 7364h, 2523h
    transferIntoKey 'f', 19d, 0817h, 7036h
    transferIntoKey 'f', 20d, 7515h, 9067h
    transferIntoKey 'f', 21d, 3502h, 3507h
    transferIntoKey 'f', 22d, 2835h, 4056h
    transferIntoKey 'f', 23d, 7040h, 3867h      
    transferIntoKey 'f', 24d, 4351h, 3622h
    transferIntoKey 'f', 25d, 2247h, 7158h
    transferIntoKey 'f', 26d, 9150h, 4953h
    transferIntoKey 'f', 27d, 0984h, 4489h
    transferIntoKey 'f', 28d, 3330h, 9634h
    transferIntoKey 'f', 29d, 0878h, 0769h
    transferIntoKey 'f', 30d, 3259h, 9397h
    transferIntoKey 'f', 31d, 8054h, 1934h
    transferIntoKey 'f', 32d, 1447h, 3774h
    transferIntoKey 'f', 33d, 4184h, 2631h
    transferIntoKey 'f', 34d, 2986h, 0809h
    transferIntoKey 'f', 35d, 9888h, 6874h
    transferIntoKey 'f', 36d, 1326h, 0472h
    transferIntoKey 'f', 37d, 1569h, 5162h
    transferIntoKey 'f', 38d, 3965h, 8645h
    transferIntoKey 'f', 39d, 7302h, 1631h
    transferIntoKey 'f', 40d, 5981h, 9319h
    transferIntoKey 'f', 41d, 5167h, 3538h
    transferIntoKey 'f', 42d, 1297h, 4167h
    transferIntoKey 'f', 43d, 7294h, 7867h
    transferIntoKey 'f', 44d, 2422h, 9246h
    transferIntoKey 'f', 45d, 5436h, 6800h
    transferIntoKey 'f', 46d, 9806h, 7692h
    transferIntoKey 'f', 47d, 8238h, 2806h
    transferIntoKey 'f', 48d, 8996h, 4004h
    transferIntoKey 'f', 49d, 8243h, 5403h
    transferIntoKey 'f', 50d, 7014h, 1631h
    transferIntoKey 'f', 51d, 2046h, 5301h
    transferIntoKey 'f', 52d, 0318h, 9034h
    transferIntoKey 'f', 53d, 2041h, 0753h
    transferIntoKey 'f', 54d, 9301h, 1957h 
    transferIntoKey 'f', 55d, 1940h, 5747h
    transferIntoKey 'f', 56d, 2940h, 5839h
    transferIntoKey 'f', 57d, 6119h, 8362h
    transferIntoKey 'f', 58d, 5565h, 0394h
    transferIntoKey 'f', 59d, 8563h, 5268h
    transferIntoKey 'f', 60d, 2019h, 3854h
    transferIntoKey 'f', 61d, 1690h, 3538h
    
    endBasicProc 0
    ret 0
endp allocateFkeys_PROC

;===== PKeys Generation =====
macro generateFKeys
	pushAll
	
	call generateFKeys_PROC

	popAll
endm generateFKeys

proc generateFKeys_PROC
	
	initBasicProc 0
	
	;Stage 1 - Key data encryption using the given password.
	xor ax, ax
	xor di, di
	xor si, si
	
	mov cx, [FkeysArrayLength]
    GFK_passwordXorWithKeysIter_LABEL:
        cmp [password + si], 00d
        jne GFK_skipPasswordReset_LABEL
        
        xor si, si
		
    GFK_skipPasswordReset_LABEL:
        mov al, [byte ptr password + si]
        xor al, [byte ptr Fkeys + di]
        
        mov [byte ptr Fkeys + di], al
        
        inc di
        inc si
    
    loop GFK_passwordXorWithKeysIter_LABEL

    readFromFile currentReadFileHandle, [FkeysArrayLength], readBuffer
    
    xor si, si
    xor di, di
    
    mov si, offset readBuffer
    mov di, offset Fkeys

	mov cx, [FkeysArrayLength] 
	GFK_keyEncryptionWithBlowFish_LABEL:
    
        mov al, [byte ptr si]
        xor al, [byte ptr di]
        mov [byte ptr di], al
        
        inc di
        inc si

    loop GFK_keyEncryptionWithBlowFish_LABEL

	endBasicProc 0
	ret 0
endp generateFKeys_PROC 