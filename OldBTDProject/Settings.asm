; ===== Game =====
CurrentScreen db ''
; ===== BMP printing =====
OPENING_SCREEN_NAME db 'OPSN.bmp', 0
START_OPTION_OPENING_SCREEN_NAME db 'StrtHigh.bmp', 0
INFO_OPTION_OPENING_SCREEN_NAME  db 'InfoHigh.bmp', 0
SCREEN_WIDTH equ 320
SCREEN_HEIGHT equ 200

PBMP_TempHeader db 54 dup (0)
PBMP_TempPallete db 256 * 4 dup (0)
PBMP_TempHandle dw ?
PBMP_ScrLine db SCREEN_WIDTH dup (0)
PBMP_ErrorMsg db 'Error', 13, 10,'$'

; ===== Logic =====
LOGIC_BOOL_FLAG db 0

; ===== Keys ASCII =====
ASCII_Enter equ 13d
ASCII_RightArrow equ 16d
ASCII_LeftArrow equ 17d
ASCII_Esc equ 27d
ASCII_UpArrow equ 30d
ASCII_DownArrow equ 31d
ASCII_Space equ 32d
ASCII_0 equ 48d
ASCII_1 equ 49d
ASCII_2 equ 50d
ASCII_3 equ 51d
ASCII_4 equ 52d
ASCII_5 equ 53d
ASCII_6 equ 54d
ASCII_7 equ 55d
ASCII_8 equ 56d
ASCII_9 equ 57d
ASCII_A equ 65d
ASCII_B equ 66d
ASCII_C equ 67d
ASCII_D equ 68d
ASCII_E equ 69d
ASCII_F equ 70d
ASCII_G equ 71d
ASCII_H equ 72d
ASCII_I equ 73d
ASCII_J equ 74d
ASCII_K equ 75d
ASCII_L equ 76d
ASCII_M equ 77d 
ASCII_N equ 78d
ASCII_O equ 79d
ASCII_P equ 80d
ASCII_Q equ 81d
ASCII_R equ 82d
ASCII_S equ 83d
ASCII_T equ 84d
ASCII_U equ 85d
ASCII_V equ 86d
ASCII_W equ 87d
ASCII_X equ 88d
ASCII_Y equ 89d
ASCII_Z equ 90d
ASCII_a equ 97d
ASCII_b equ 98d
ASCII_c equ 99d
ASCII_d equ 100d
ASCII_e equ 101d
ASCII_f equ 102d 
ASCII_g equ 103d
ASCII_h equ 104d 
ASCII_i equ 105d
ASCII_j equ 106d
ASCII_k equ 107d
ASCII_l equ 108d
ASCII_m equ 109d
ASCII_n equ 110d
ASCII_o equ 111d
ASCII_p equ 112d
ASCII_q equ 113d
ASCII_r equ 114d
ASCII_s equ 115d
ASCII_t equ 116d
ASCII_u equ 117d 
ASCII_v equ 118d
ASCII_w equ 119d
ASCII_x equ 120d
ASCII_y equ 121d
ASCII_z equ 122d