;===== Sends all below params into an outside file =====
;Params:
; -Pkeys
; -Fkeys
; -Password
macro createDataFile
    pushAll
    
	call createDataFile_PROC

    popAll
endm createDataFile

proc createDataFile_PROC
    initBasicProc 0

    createFile dataFileName, [currentWriteFileHandle]

    writeToFile [currentWriteFileHandle], [keysArrayLength], Pkeys
    writeToFile [currentWriteFileHandle], [FkeysArrayLength], Fkeys 
    writeToFile [currentWriteFileHandle], 2d, passwordLength    
    writeToFile [currentWriteFileHandle], [passwordLength], password    
    
    closeFile [currentWriteFileHandle]
    endBasicProc 0
    ret 0
endp createDataFile_PROC

;===== Copies all the data from the data file back into the CPU =====
macro retrieveDataFile
    pushAll
        
    call retrieveDataFile_PROC

    popAll
endm retrieveDataFile

proc retrieveDataFile_PROC
    initBasicProc 0

    openFile dataFileName, currentReadFileHandle, 'b'
    
    readFromFile currentReadFileHandle, [keysArrayLength], Pkeys
    readFromFile currentReadFileHandle, [FkeysArrayLength], Fkeys    
    readFromFile currentReadFileHandle, 2d, passwordLength 
    readFromFile currentReadFileHandle, [passwordLength], password  
    
    closeFile [currentReadFileHandle]

    mov [passwordLength], di
	mov [byte ptr password + di], 00d    

    endBasicProc 0
    ret 0
endp retrieveDataFile_PROC