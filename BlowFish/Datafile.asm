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
    writeToFile [currentWriteFileHandle], [passwordLength], password    
    writeToFile [currentWriteFileHandle], 2d, passwordLength    
    
    closeFile [currentWriteFileHandle]

    ;add a close file statement for data file
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
    readFromFile currentReadFileHandle, [passwordLength], password  
    readFromFile currentReadFileHandle, 2d, passwordLength  

    closeFile [currentReadFileHandle]

    endBasicProc 0
    ret 0
endp retrieveDataFile_PROC